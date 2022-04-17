import 'package:shared_preferences/shared_preferences.dart';


class SharedPref {

  static SharedPreferences? _preferences;

  static const _keyIsWelcomed = 'welcome';
  static const _keyUserName = 'userName';
  static const _keyProfilePic = 'profileImage';
  static const _keyIsDevTokenSent = 'deviceToken';

  static Future init() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  // ---------------- gritie features -------------------
  
  static Future<bool> setUserName(String userName) async {
    return await _preferences!.setString(_keyUserName, userName);
  }

  static String? getUserName() {
    return _preferences?.getString(_keyUserName) ?? 'Test';
  }

  // ---------- profile image -----------------

  static Future<bool> setProfilePic(String profileImage) async {
    return await _preferences!.setString(_keyProfilePic, profileImage);
  }

  static String? getProfilePic() {
    return _preferences?.getString(_keyProfilePic);
  }

  // ---------- End profile image -----------------

  // ---------- is welcomed -----------------

  static Future<bool> setIsWelcomed(bool isWelcomed) async {
    return await _preferences!.setBool(_keyIsWelcomed, isWelcomed);
  }

  static bool getIsWelcomed() {
    return _preferences!.getBool(_keyIsWelcomed) ?? false;
  }

  // ---------- End is welcomed -----------------

  // ---------- is device token sent -----------------

  static Future<bool> setIsDevTokenSent(bool isWelcomed) async {
    return await _preferences!.setBool(_keyIsDevTokenSent, isWelcomed);
  }

  static bool getIsDevTokenSent() {
    return _preferences!.getBool(_keyIsDevTokenSent) ?? false;
  }

  // ---------- End device token sent -----------------

}