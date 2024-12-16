import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/utils.dart';
import 'package:hizmetim/features/auth/repository/auth_repository.dart';
import 'package:hizmetim/features/auth/repository/secure_storage_service.dart';
import 'package:hizmetim/features/auth/screens/login_screen.dart';
import 'package:hizmetim/models/user_model.dart';
import 'package:hizmetim/navigate_methods.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  void signInWithGoogle(BuildContext context) async {
    state = true;
    final user = await _authRepository.signInWithGoogle();
    state = false;
    user.fold(
        (l) => showSnackBar(context, l.message),
        (userModel) =>
            _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void signUpWithEmailAndPassword(
      BuildContext context, String email, String password, String name) async {
    state = true;
    final result =
        await _authRepository.signUpWithEmailAndPassword(email, password, name);
    state = false;

    result.fold(
      (failure) {
        if (mounted) {
          showSnackBar(context, failure.message);
        }
      },
      (_) {
        if (mounted) {
          showSnackBar(
            context,
            'E-posta adresinize doğrulama kodu gönderilmiştir. Lütfen e-postanızı kontrol ediniz.',
          );

          NavigationMethod.navigate(context, const LoginScreen());
        }
      },
    );
  }

  void signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    state = true;
    final user =
        await _authRepository.signInWithEmailAndPassword(email, password);
    state = false;

    user.fold(
      (failure) {
        if (mounted) {
          showSnackBar(context, failure.message);
        }
      },
      (userModel) {
        if (mounted) {
          if (userModel.isAuthenticated) {
            _ref.read(userProvider.notifier).state = userModel;
            var secureStorageService = _ref.read(secureStorageProvider);
            secureStorageService.mailKaydet(email);
            secureStorageService.passwordKaydet(password);
          } else {
            showSnackBar(context, 'Lütfen e-posta adresinizi doğrulayın.');
          }
        }
      },
    );
  }

  Future<void> loginWithSecureStorage(BuildContext context) async {
    var secureStorageService = _ref.read(secureStorageProvider);

    String? email = await secureStorageService.mailGetir();
    String? password = await secureStorageService.passwordGetir();
    if (email != null && password != null) {
      signInWithEmailAndPassword(context, email, password);
    }
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUserData(uid);
  }

  void logout() {
    _authRepository.logOut();
    var secureStorageService = _ref.read(secureStorageProvider);
    secureStorageService.mailKaydet(null);
    secureStorageService.passwordKaydet(null);
    _ref.read(userProvider.notifier).state = null;
  }
}
