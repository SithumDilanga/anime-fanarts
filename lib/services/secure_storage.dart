import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {

  static final _storage = FlutterSecureStorage();

  static const _keyToken = 'bearer_token';
  static const _keyUserId = 'user_id';
  static const _keyDeviceId = 'device_id';

  static Future setToken(String token) async => await _storage.write(
    key: _keyToken, 
    value: token
  );

  static Future<String?> getToken() async => await _storage.read(key: _keyToken);

  static Future deleteToken() async => await _storage.delete(key: _keyToken);

  // --------------- userId ------------------

  static Future setUserId(String token) async => await _storage.write(
    key: _keyUserId, 
    value: token
  );

  static Future<String?> getUserId() => _storage.read(key: _keyUserId);

  // --------------- End userId ------------------

  // --------------- userId ------------------

  static Future setDeviceId(String deviceId) async => await _storage.write(
    key: _keyDeviceId, 
    value: deviceId
  );

  static Future<String?> getDeviceId() => _storage.read(key: _keyDeviceId);

  // --------------- End userId ------------------
  
}