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

/// `authRepositoryProvider`, `AuthRepository` sınıfının bir örneğini sağlayan bir Provider'dır.
/// Bu sınıf, Firestore, FirebaseAuth ve GoogleSignIn bağımlılıklarını alır.
final authRepositoryProvider = Provider((ref) => AuthRepository(
      firestore: ref.read(firestoreProvider),
      auth: ref.read(authProvider),
      googleSignIn: ref.read(googleSignInProvider),
    ));

/// `AuthRepository` sınıfı, kullanıcı kimlik doğrulama işlemlerini yönetir.
/// Firestore, FirebaseAuth ve GoogleSignIn bağımlılıklarını alır.
class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  /// `AuthRepository` yapıcı metodu, Firestore, FirebaseAuth ve GoogleSignIn bağımlılıklarını alır.
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
  })  : _firestore = firestore,
        _auth = auth,
        _googleSignIn = googleSignIn;

  /// `_users`, Firestore'daki kullanıcılar koleksiyonuna referans sağlar.
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? 'No Name',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          balance: 0,
          awards: [],
        );
        await _users.doc(userCredential.user!.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<void> signUpWithEmail(String email, String password, String name) async {
    try {
      // Kullanıcıyı e-posta ve şifre ile Firebase'e kaydet
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // E-posta doğrulama bağlantısını gönder
      await userCredential.user!.sendEmailVerification();

      // Yeni kullanıcı için UserModel oluştur
      UserModel userModel = UserModel(
        name: name,
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false, // Kullanıcı henüz doğrulanmadı
        balance: 0,
        awards: [],
      );

      // Kullanıcı verilerini Firestore'a kaydet
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      // Kullanıcının oturumunu kapat
      await _auth.signOut();

      return right(null); // Başarılı
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Bir hata oluştu'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

// filepath: /Applications/GitHub Projects/hizmetim/lib/features/auth/repository/auth_repository.dart
  FutureEither<UserModel> signInWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User user = userCredential.user!;
      await user.reload();

      if (user.emailVerified) {
        await _users.doc(user.uid).update({
          'isAuthenticated': true,
        });

        // Notify listeners or update authentication state here
        // For example:
        // authProvider.updateAuthState(true);

        UserModel userModel = await getUserData(user.uid).first;
        return right(userModel);
      } else {
        await _auth.signOut();
        return left(Failure('Lütfen e-posta adresinizi doğrulayın.'));
      }
    } on FirebaseAuthException catch (e) {
      return left(Failure(e.message ?? 'Bir hata oluştu'));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  /// `getUserData`, belirli bir kullanıcı kimliğine sahip kullanıcının verilerini alır.
  /// Kullanıcı verilerini bir akış olarak döner.
  Stream<UserModel> getUserData(String uid) {
    return _users.doc(uid).snapshots().map((event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
