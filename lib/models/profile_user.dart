import 'package:flutter/cupertino.dart';

class ProfileUser with ChangeNotifier {

  String? bio;

  ProfileUser({
    this.bio
  });

  void updateBio(String bioText) {
    bio = bioText;
    notifyListeners();
  }

}