import 'package:flutter/cupertino.dart';

class ReactedPosts extends ChangeNotifier{

  List reactedPosts;
  Set removedReactionList = Set();

  ReactedPosts({
    required this.reactedPosts,
    required this.removedReactionList
  });

  void addPostToReactedList(dynamic postId) {
    reactedPosts.add(postId);
    notifyListeners();
  }

  void removePostFromReactedList(dynamic postId) {
    reactedPosts.remove(postId);
    notifyListeners();
  }

  void addReactedLists(List reactedNewPosts) {
    reactedPosts = reactedPosts + reactedNewPosts;
    notifyListeners();    
  }

  void addToRemovedReactionList(dynamic postId) {
    removedReactionList.add(postId);
    notifyListeners();
  }

  void removeFromRemovedReactionList(dynamic postId) {
    removedReactionList.remove(postId);
    notifyListeners();
  }

}