import 'package:shared_preferences/shared_preferences.dart';


class SharedPref {

  static SharedPreferences? _preferences;

  static const _keyQuoteList = 'quoteList';
  static const _keyDateTimeList = 'dateTimeList';

  static Future init() async {
    return _preferences = await SharedPreferences.getInstance();
  }

  static Future setQuoteList(List<String> quoteList) async {
    return await _preferences!.setStringList(_keyQuoteList, quoteList);
  }

  static List<String>? getQuoteList() {
    return _preferences!.getStringList(_keyQuoteList);
  }

  static Future setDateTimeList(List<String> dateTimeList) async {
    return await _preferences!.setStringList(_keyDateTimeList, dateTimeList);
  }

  static List<String>? getDateTimeList() {
    return _preferences!.getStringList(_keyDateTimeList);
  }

  // ---------------- gritie features -------------------

  static const _keyIsWelcomed = 'welcome';
  static const _keyUserName = 'userName';

  static Future<bool> setIsWelcomed(bool isWelcomed) async {
    return await _preferences!.setBool(_keyIsWelcomed, isWelcomed);
  }

  static bool getIsWelcomed() {
    return _preferences!.getBool(_keyIsWelcomed) ?? false;
  }
  
  static Future<bool> setUserName(String userName) async {
    print('userName ' +  userName.toString());
    return await _preferences!.setString(_keyUserName, userName);
  }

  static String? getUserName() {
    return _preferences?.getString(_keyUserName) ?? 'Test';
  }

  // profile image

  static const _keyProfilePic = 'profileImage';

  static Future<bool> setProfilePic(String profileImage) async {
    print('prifilePic ' +  profileImage.toString());
    return await _preferences!.setString(_keyProfilePic, profileImage);
  }

  static String getProfilePic() {
    return _preferences?.getString(_keyProfilePic) ?? 'Test';
  }


}