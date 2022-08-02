import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// @dzolotov насколько хорошая идея хранить ревизию в FlutterSecureStorage?

class RevisionDataSource {
  final _storage = const FlutterSecureStorage();
  final _key = 'revision_key';

  Future<void> setRevision(int revision) async {
    _storage.write(
      key: _key,
      value: revision.toString(),
    );
  }

  Future<int?> getRevision() async {
    return int.tryParse(await _storage.read(key: _key) ?? '');
  }

  Future<void> resetRevision() async {
    _storage.delete(key: _key);
  }
}
