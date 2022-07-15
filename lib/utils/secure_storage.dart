import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage();

  static Future setToken(String token) async =>
      await _storage.write(key: 'token', value: token);

  static Future<String> getToken() async =>
      await _storage.read(key: 'token') ?? '';

  static Future setCookie(String token) async =>
      await _storage.write(key: 'cookie', value: token);

  static Future<String> getCookie() async =>
      await _storage.read(key: 'cookie') ?? '';

  static Future setRole(String token) async =>
      await _storage.write(key: 'role', value: token);

  static Future<String> getRole() async =>
      await _storage.read(key: 'role') ?? '';

  static Future setDepartment(String token) async =>
      await _storage.write(key: 'department', value: token);

  static Future<String> getDepartment() async =>
      await _storage.read(key: 'department') ?? '';

  // static Future setFkdepartmen(String department) async =>
  //     await _storage.write(key: 'department', value: department);

  // static Future<String> getFkdepartment() async =>
  //     await _storage.read(key: 'department') ?? '';

  Future deleteSecureData(String key) async {
    var delete = await _storage.delete(key: key);
    return delete;
  }

  static deleteSecureAll() async {
    await _storage.deleteAll();
  }
}
