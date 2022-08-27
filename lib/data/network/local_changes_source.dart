import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LocalChangesDataSource {
  final _storage = const FlutterSecureStorage();
  final _key = 'local_changes_key';

  Future<void> setLocalChanges(bool localChanges) async {
    _storage.write(
      key: _key,
      value: localChanges.toString(),
    );
  }

  Future<bool> getLocalChanges() async {
    return (await _storage.read(key: _key) ?? '') == 'true';
  }

  Future<void> resetLocalChanges() async {
    _storage.delete(key: _key);
  }
}
