import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hizmetim/core/constants/constants.dart';
import 'package:hizmetim/core/constants/firebase_constants.dart';
import 'package:hizmetim/core/failure.dart';
import 'package:hizmetim/core/providers/firebase_provider.dart';
import 'package:hizmetim/core/type_defs.dart';
import 'package:hizmetim/models/user_model.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider),
    ));

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? 'No Name',
          email: userCredential.user!.email ?? 'No Email',
          userType: 'user',
          isAuthenticated: true,
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          bio: 'Kendinden Bahset!',
          balance: 0,
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid);
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.sendEmailVerification();

      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: userCredential.user!.email ?? 'No Email',
        userType: 'user',
        isAuthenticated: false,
        profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
        bio: 'Kendinden Bahset!',
        balance: 0,
      );

      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      await _auth.signOut();

      return right(null);
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Bir hata oluştu'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;

      await user.reload();
      user = _auth.currentUser!;

      if (user.emailVerified) {
        await _users.doc(user.uid).update({
          'isAuthenticated': true,
        });

        UserModel userModel = await getUserData(user.uid);
        return right(userModel);
      } else {
        await _auth.signOut();
        return left(Failure(
            'E-posta adresinizi doğrulamadınız. Lütfen doğrulayıp tekrar deneyin.'));
      }
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Bir hata oluştu.'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Future<UserModel> getUserData(String uid) async {
    DocumentSnapshot doc = await _users.doc(uid).get();
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
