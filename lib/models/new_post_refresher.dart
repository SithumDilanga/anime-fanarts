import 'package:flutter/cupertino.dart';

class NewPostFresher extends ChangeNotifier {

  bool isPostAdded;

  NewPostFresher({
    required this.isPostAdded
  });

  void updateIsPostAdded(bool isPostAdded) {
    this.isPostAdded = isPostAdded;
    notifyListeners();
  }


}