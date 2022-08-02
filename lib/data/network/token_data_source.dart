import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenDataSource {
  final _storage = const FlutterSecureStorage();
  final _key = 'token_key';

  Future<void> setToken(String token) async {
    _storage.write(
      key: _key,
      value: token,
    );
  }

  Future<String?> getToken() async {
    return _storage.read(key: _key);
  }

  Future<void> resetToken() async {
    _storage.delete(key: _key);
  }
}
