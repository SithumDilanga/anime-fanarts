import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/profile/users_profile_test.dart';
import 'package:anime_fanarts/services/profile_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/error_loading.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class FollowersList extends StatefulWidget {
  const FollowersList({ Key? key }) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> {

  static const _pageSize = 20;
  List followersList = [];
  ProfileReq _profileReq = ProfileReq();

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1,);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    super.initState();
  }

  void _fetchPage(int pageKey) async {

    final followersData = await _profileReq.getFollowersList(
      pageKey: pageKey,
      pageSize: _pageSize
    );

    print('followersData ${followersData['followers']}');

     try {
      final newItems = await followersData['followers'];

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // int nextPageKey = (pageKey + newItems.length) as int;
        int nextPageKey = (pageKey + 1);
        _pagingController.appendPage(newItems, nextPageKey);
      }
      
      setState(() {
        followersList = followersList + followersData['followers'];
      });

    } catch (error) {
      print('errpr $error');
      _pagingController.error = error;
    }

  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.primary,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
        title: Text(
          'Followers'
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(
          () => _pagingController.refresh(),
        ),
        color: Colors.blue[200],
        backgroundColor: ColorTheme.primary,
        child: PagedListView.separated(
          pagingController: _pagingController, 
          padding: EdgeInsets.symmetric(
            vertical: 12
          ),
          builderDelegate: PagedChildBuilderDelegate<dynamic>(
            animateTransitions: true,
            itemBuilder: (context, item, index) {

              return GestureDetector(
                child: Column(
                  children: [
                    if(item['user']['profilePic'] == 'default-profile-pic.jpg')
                      ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueGrey[700],
                          backgroundImage: AssetImage(
                            'assets/images/profile-img-placeholder.jpg'
                          ),
                        ),
                        trailing: Icon(
                          item['subscribed'] ? Icons.notifications_active_rounded : null,
                          color: ColorTheme.primary,
                        ),
                        title: Text(
                          '${item['user']['name']}',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
              
                    if(item['user']['profilePic'] != 'default-profile-pic.jpg')
                      ListTile(
                        leading: CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueGrey[700],
                          backgroundImage: ExtendedNetworkImageProvider(
                            '${item['user']['profilePic']}',
                            // cache: true,
                          ),
                        ),
                        trailing: Icon(
                          item['subscribed'] ? Icons.notifications_active_rounded : null,
                          color: ColorTheme.primary,
                        ),
                        title: Text(
                          '${item['user']['name']}',
                          style: TextStyle(
                            fontSize: 18
                          ),
                        ),
                      ),
                    SizedBox(height: 12.0,)
                  ],
                ),
                onTap: () {

                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, .0, 
                      // UsersProfile(name: widget.name, userId: widget.userId)
                      UsersProfileTest(
                        name: item['user']['name'], 
                        userId: item['user']['_id']
                      )
                    )
                  );

                },
              );

            },
            noItemsFoundIndicatorBuilder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  'No followers to show!',
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                ),
              ),
            ),
            newPageErrorIndicatorBuilder: (context) => ErrorLoading(
              errorMsg: 'Error loading list!', 
              onTryAgain: _pagingController.refresh
            ),
            firstPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
            newPageProgressIndicatorBuilder: (context) => LoadingAnimation(),
            firstPageErrorIndicatorBuilder: (context) => ErrorLoading(
                errorMsg: 'Error loading list!', 
                onTryAgain: _pagingController.refresh
              ) 
            ),
             
          separatorBuilder: (context, index) => SizedBox(),
        ),
      ),
    );
  }
}