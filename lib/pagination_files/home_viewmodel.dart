import 'package:anime_fanarts/pagination_files/ui_constants.dart';
import 'package:anime_fanarts/services/get_create_posts.dart';
import 'package:flutter/widgets.dart';

class HomeViewModel extends ChangeNotifier {

  static const int ItemRequestThreshold = 15;

  GetCreatePosts _getCreatePosts = GetCreatePosts();

  late List _items;
  late List _reactedPosts = [];

  List get items => _items;

  List get getReactedPosts => _reactedPosts;

  int _currentPage = 0;

  init() async {

    final allPostsData = await _getCreatePosts.getAllPosts(
      0,
      5
    );

    final newFetchedItems = await allPostsData['data']['posts'];
      
    // _items = newFetchedItems;

    print('_items $_items');

  }

  HomeViewModel() {
    
    //  init();
    _items = List.generate(15, (index) {
      return {
        "_id": "6234ce3ed42a3e49f817d282",
        "description": "",
        "commentCount": [
            {
                "_id": 1,
                "commentCount": 0
            }
        ],
        "postImages": [
            "https://animizu-img.s3.ap-southeast-1.amazonaws.com/6234c5afd42a3e49f817cfed/postImg-6234c5afd42a3e49f817cfed-1647627836647.jpeg"
        ],
        "tags": [
            "jj"
        ],
        "reactions": [
            {
                "_id": 1,
                "reactionCount": 2
            }
        ],
        "user": {
            "_id": "6234c5afd42a3e49f817cfed",
            "name": "Komi san",
            "profilePic": "https://animizu-img.s3.ap-southeast-1.amazonaws.com/6234c5afd42a3e49f817cfed/userPP-6234c5afd42a3e49f817cfed-1647627114357.jpg"
        },
        "createdAt": "2022-03-18T18:23:58.897Z",
        "__v": 0
    };
    });

    _reactedPosts = List.generate(1, (index) {
      return {
        "_id": "6234e8bbd42a3e49f817d6c9",
        "reaction": 1,
        "reactionKey": "6234c5afd42a3e49f817cfed6234ce3ed42a3e49f817d282",
        "post": "6234ce3ed42a3e49f817d282",
        "user": "6234c5afd42a3e49f817cfed",
        "createdAt": "2022-03-18T20:16:59.216Z",
        "__v": 0
      };
    });

  }

  Future handleItemCreated(int index) async {
    var itemPosition = index + 1;
    var requestMoreData =
        itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
    var pageToRequest = itemPosition ~/ ItemRequestThreshold;

    if (requestMoreData && pageToRequest > _currentPage) {
      print('handleItemCreated | pageToRequest: $pageToRequest');
      _currentPage = pageToRequest;
      _showLoadingIndicator();

      await Future.delayed(Duration(seconds: 2));
      // var newFetchedItems = List<String>.generate(
      //     15, (index) => 'Title page:$_currentPage item: $index'
      // );

      List newPostData = [];

      final allPostsData = await _getCreatePosts.getAllPosts(
        _currentPage,
        ItemRequestThreshold
      );

    
      final newFetchedItems = await allPostsData['data']['posts'];

      final reactedPostItems = await allPostsData['data']['reacted'];

      for(int i = 0; i < newFetchedItems.length; i++) {
        newPostData.add(newFetchedItems[i]['_id']);
        print('newFetchedItems[i][_id] ${newFetchedItems[i]['_id']}');
      }


      _items.addAll(newFetchedItems); //newPostData
      _reactedPosts.addAll(reactedPostItems);

      _removeLoadingIndicator();
    }

    print('_currentPage $_currentPage');
    print('newpagination ${_items}');
  }

  void _showLoadingIndicator() {
    _items.add(LoadingIndicatorTitle);
    notifyListeners();
  }

  void _removeLoadingIndicator() {
    _items.remove(LoadingIndicatorTitle);
    notifyListeners();
  }
}

// class HomeViewModelNew extends StatefulWidget {
//   const HomeViewModelNew({ Key? key }) : super(key: key);

//   @override
//   State<HomeViewModelNew> createState() => _HomeViewModelNewState();
// }

// class _HomeViewModelNewState extends State<HomeViewModelNew> {
  

//   Future handleItemCreated(int index) async {
//     var itemPosition = index + 1;
//     var requestMoreData =
//         itemPosition % ItemRequestThreshold == 0 && itemPosition != 0;
//     var pageToRequest = itemPosition ~/ ItemRequestThreshold;

//     if (requestMoreData && pageToRequest > _currentPage) {
//       print('handleItemCreated | pageToRequest: $pageToRequest');
//       _currentPage = pageToRequest;
//       _showLoadingIndicator();

//       await Future.delayed(Duration(seconds: 2));
//       // var newFetchedItems = List<String>.generate(
//       //     15, (index) => 'Title page:$_currentPage item: $index'
//       // );

//       List newPostData = [];

//       final allPostsData = await _getCreatePosts.getAllPosts(
//         _currentPage,
//         ItemRequestThreshold
//       );

    
//       final newFetchedItems = await allPostsData['data']['posts'];

//       for(int i = 0; i < newFetchedItems.length; i++) {
//         newPostData.add(newFetchedItems[i]['_id']);
//         print('newFetchedItems[i][_id] ${newFetchedItems[i]['_id']}');
//       }


//       _items.addAll(newPostData);

//       _removeLoadingIndicator();
//     }

//     print('_currentPage $_currentPage');
//     print('newpagination ${_items}');
//   }

//   void _showLoadingIndicator() {
//     _items.add(LoadingIndicatorTitle);
//     notifyListeners();
//   }

//   void _removeLoadingIndicator() {
//     _items.remove(LoadingIndicatorTitle);
//     notifyListeners();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
      
//     );
//   }
// }