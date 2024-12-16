import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider((ref) {
  return SecureStorageService();
});

class SecureStorageService {
  final FlutterSecureStorage preferences = const FlutterSecureStorage();

  void mailKaydet(String? phoneNumber) async {
    await preferences.write(key: 'mail', value: phoneNumber);
  }

  Future<String?> mailGetir() async {
    var number = await preferences.read(key: 'mail');

    return number;
  }

  void passwordKaydet(String? password) async {
    await preferences.write(key: 'password', value: password);
  }

  Future<String?> passwordGetir() async {
    var password = await preferences.read(key: 'password');

    return password;
  }
}
