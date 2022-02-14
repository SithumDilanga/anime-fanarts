import 'package:flutter/cupertino.dart';

class NewPostFresher extends ChangeNotifier {

  bool isPostAdded;
  bool isPostDeleted;

  NewPostFresher({
    required this.isPostAdded,
    required this.isPostDeleted
  });

  void updateIsPostAdded(bool isPostAdded) {
    this.isPostAdded = isPostAdded;
    notifyListeners();
  }

  void updateIsPostDeleted(bool isPostDeleted) {
    this.isPostDeleted = isPostDeleted;
    notifyListeners();
  }


}