import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPref {

  static SharedPreferences? _preferences;

  static const _keyIsWelcomed = 'welcome';
  static const _keyUserName = 'userName';
  static const _keyProfilePic = 'profileImage';
  static const _keyIsDevTokenSent = 'deviceToken';
  static const _keyBlockedUsersIdsList = 'blockedUserIds';
  static const _keyBlockedUsersNamesList = 'blockedUserNames';

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

  // ---------- blocked user ids -----------------

  static Future setBlockedUserIdsList({required String blockedUserId}) async {

    // if(isWhenLogin) {
      
    //   _preferences!.remove(_keyBlockedUsersIdsList);

    // }

    List<String>? blockedUserIdList = getBlockedUserIdsList();

    blockedUserIdList?.add(blockedUserId); 

    return await _preferences!.setStringList(_keyBlockedUsersIdsList, blockedUserIdList!);
  }

  static Future setUnblockedUser(String blockedUserId) async {

    List<String>? blockedUserIdList = getBlockedUserIdsList();

    blockedUserIdList?.remove(blockedUserId); 

    return await _preferences!.setStringList(_keyBlockedUsersIdsList, blockedUserIdList!);
  }

  static List<String>? getBlockedUserIdsList() {
    return _preferences!.getStringList(_keyBlockedUsersIdsList) ?? [];
  }


  // ---------- End blocked user ids -----------------


  // ---------- blocked user names -----------------

  static Future setBlockedUserNamesList(String name) async {

    List<String>? blockedUserNamesList = getBlockedUserNamesList();

    blockedUserNamesList?.add(name); 

    return await _preferences!.setStringList(_keyBlockedUsersNamesList, blockedUserNamesList!);
  }

  
  static List<String>? getBlockedUserNamesList() {
    return _preferences!.getStringList(_keyBlockedUsersNamesList) ?? [];
  }


  // ---------- End blocked user ids -----------------

  static Future removeSpecificCache(String keyName) async {

    _preferences!.remove(keyName);

  }

}