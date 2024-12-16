import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hizmetim/core/utils.dart';
import 'package:hizmetim/features/auth/repository/auth_repository.dart';
import 'package:hizmetim/features/auth/repository/secure_storage_service.dart';
import 'package:hizmetim/features/auth/screens/login_screen.dart';
import 'package:hizmetim/models/user_model.dart';
import 'package:hizmetim/navigate_methods.dart';

// Kullanıcı modelini tutan bir StateProvider
final userProvider = StateProvider<UserModel?>((ref) => null);

// AuthController'ı sağlayan bir StateNotifierProvider
final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) => AuthController(
          authRepository: ref.watch(authRepositoryProvider),
          ref: ref,
        ));

final authStateChangesProvider = StreamProvider<User?>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

// Auth işlemlerini yöneten AuthController sınıfı
class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository; // AuthRepository örneği
  final Ref _ref; // Riverpod Ref örneği

  AuthController({required AuthRepository authRepository, required Ref ref})
      : _authRepository = authRepository,
        _ref = ref,
        super(false); // Başlangıçta yükleniyor durumu false

  Stream<User?> get authStateChanges => _authRepository.authStateChanges;

  // Google ile giriş yapma fonksiyonu
  void signInWithGoogle(BuildContext context) async {
    state = true; // Yükleniyor durumunu true yap
    final user =
        await _authRepository.signInWithGoogle(); // Google ile giriş yap
    state = false; // Yükleniyor durumunu false yap
    user.fold(
        (l) => showSnackBar(context, l.message), // Hata durumunda mesaj göster
        (userModel) => _ref.read(userProvider.notifier).update(
            (state) => userModel)); // Başarılı durumda kullanıcıyı güncelle
  }

  // Email ve şifre ile kayıt olma fonksiyonu
  void signUpWithEmail(
      BuildContext context, String email, String password, String name) async {
    state = true; // Yükleniyor durumunu true yap
    final result = await _authRepository.signUpWithEmail(email, password, name);
    state = false; // Yükleniyor durumunu false yap

    result.fold(
      (failure) {
        // Hata durumunda mesaj göster
        if (mounted) {
          showSnackBar(context, failure.message);
        }
      },
      (_) {
        // Doğrulama e-postası gönderildi mesajını göster
        if (mounted) {
          showSnackBar(
            context,
            'E-posta adresinize doğrulama kodu gönderilmiştir. Lütfen e-postanızı kontrol ediniz.',
          );
          // İsteğe bağlı olarak giriş sayfasına yönlendirin
          NavigationMethod.navigate(context, const LoginScreen());
        }
      },
    );
  }

  void signInWithEmail(
      BuildContext context, String email, String password) async {
    state = true; // Yükleniyor durumunu true yap
    final user = await _authRepository.signInWithEmail(email, password);
    state = false; // Yükleniyor durumunu false yap

    user.fold(
      (failure) {
        // Hata durumunda mesaj göster
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

            // HomeScreen'e yönlendir
          } else {
            showSnackBar(context, 'Lütfen e-posta adresinizi doğrulayın.');
            // Gerekirse yeniden doğrulama e-postası gönderilebilir
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
      signInWithEmail(context, email, password);
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
