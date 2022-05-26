import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/search/artworks_search.dart';
import 'package:anime_fanarts/search/users_search.dart';
import 'package:anime_fanarts/settings/contact_us.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class Search3 extends StatefulWidget {

  final int tabIndex;

  const Search3({Key? key, required this.tabIndex}) : super(key: key);

  @override
  _Search3State createState() => _Search3State();
}

class _Search3State extends State<Search3> {
  static const historyLength = 5;

  List<String> _searchHistory = [
    'fuchsia',
    'flutter',
    'widgets',
    'resocoder',
  ];

  List<String>? filteredSearchHistory;

  String selectedTerm = '';

  List<String> filterSearchTerms({
    @required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      putSearchTermFirst(term);
      return;
    }

    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController? controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FloatingSearchBar(
        controller: controller,
        elevation: 1,
        body: FloatingSearchBarScrollNotifier(
          child: SearchResultsListView(
            searchTerm: selectedTerm,
            tabIndex: widget.tabIndex
          ),
        ),
        transition: CircularFloatingSearchBarTransition(),
        physics: BouncingScrollPhysics(),
        title: Text(
          selectedTerm,
          style: Theme.of(context).textTheme.headline6,
        ),
        hint: 'Search and find out...',
        actions: [
          FloatingSearchBarAction.searchToClear(),
        ],
        onQueryChanged: (query) {
          setState(() {
            filteredSearchHistory = filterSearchTerms(filter: query);
          });
        },
        onSubmitted: (query) {
          setState(() {
            addSearchTerm(query);
            selectedTerm = query;
          });
          controller!.close();
        },
        builder: (context, transition) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Material(
              color: Colors.white,
              elevation: 4,
              child: Builder(
                builder: (context) {
                  if (filteredSearchHistory!.isEmpty &&
                      controller!.query.isEmpty) {
                    return Container(
                      height: 56,
                      width: double.infinity,
                      alignment: Alignment.center,
                      child: Text(
                        'Start searching',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    );
                  } else if (filteredSearchHistory!.isEmpty) {
                    return ListTile(
                      title: Text(controller!.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller!.query);
                          selectedTerm = controller!.query;
                        });
                        controller!.close();
                      },
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: filteredSearchHistory
                          !.map(
                            (term) => ListTile(
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                });
                                controller!.close();
                              },
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class SearchResultsListView extends StatelessWidget {
  final String searchTerm;
  final int tabIndex;

  const SearchResultsListView({
    Key? key,
    required this.searchTerm, 
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (searchTerm == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.search,
              size: 64,
            ),
            Text(
              'Start searching',
              style: Theme.of(context).textTheme.headline5,
            )
          ],
        ),
      );
    }

    final fsb = FloatingSearchBar.of(context);


    // return Padding(
    //   padding: const EdgeInsets.only(top: 76),
    //   child: MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: DefaultTabController(
    //       length: 2,
    //       child: Scaffold(
    //         backgroundColor: Color(0xffF0F0F0),
    //         appBar: PreferredSize(
    //           preferredSize: Size.fromHeight(kToolbarHeight),
    //           child: TabBar(
    //             indicatorColor: ColorTheme.primary,
    //             labelColor: ColorTheme.primary,
    //             unselectedLabelColor: Colors.grey[700],
    //             tabs: [
    //               Tab(
    //                 text: 'Artworks',
    //               ),
    //               Tab(
    //                 text: 'Users',
    //               ),
    //             ],
    //           ),
    //         ),
    //         body: TabBarView(
    //           children: [
    //             ArtworksSearch(),
    //             UsersSearch()
    //           ],
    //         )
    //       ),
    //     ),
    //   ),
    // );

    if(tabIndex == 0) {

      return ListView(
      padding: EdgeInsets.only(
        top: 92 //fsb.height + fsb.margins.vertical
      ),
      children: List.generate(
        1,
        (index) => Column(
            children: [
              GestureDetector(
                child: Post(
                  id: 'sdsd',
                  name: 'SDLive',
                  profilePic: 'https://i.pinimg.com/550x/75/3c/73/753c73bc1696a9c20afb3f1c22eae84f.jpg' ,
                  desc: 'description',
                  postImg: ['https://i.pinimg.com/originals/b9/6c/e2/b96ce262d5dfa77fd68dffc06d4881ed.png'],
                  userId: 'sdsd12',
                  date: '2022-03-18T08:37:43.687+00:00', //formattedDate,
                  reactionCount: 10,
                  commentCount: 5,
                  isUserPost: false,
                  isReacted: false,
                  // reactedPosts: reactedPost
                ),
                // child: ListTile(
                //   leading: CircleAvatar(
                //     radius: 24,
                //     backgroundColor: Colors.blueGrey[700],
                //     backgroundImage: ExtendedNetworkImageProvider(
                //       'https://i.pinimg.com/736x/67/d6/af/67d6af844900ef007771d41daf9df35c.jpg',
                //       // cache: true,
                //     ),
                //   ),
                //   title: Text(
                //     'Levi Ackerman',
                //     style: TextStyle(
                //       fontSize: 18
                //     ),
                //   ),
                //   subtitle: Text(
                //     '@username'
                //   ),
                // ),
                onTap: () {

                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      ContactUs()
                    )
                  );

                },
              ),
              SizedBox(height: 12.0,)
            ],
          )
      ),
    );

    } else if(tabIndex == 1) {

      return ListView(
      padding: EdgeInsets.only(
        top: 92 //fsb.height + fsb.margins.vertical
      ),
      children: List.generate(
        1,
        (index) => Column(
            children: [
              GestureDetector(
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.blueGrey[700],
                    backgroundImage: ExtendedNetworkImageProvider(
                      'https://i.pinimg.com/736x/67/d6/af/67d6af844900ef007771d41daf9df35c.jpg',
                      // cache: true,
                    ),
                  ),
                  title: Text(
                    'Levi Ackerman',
                    style: TextStyle(
                      fontSize: 18
                    ),
                  ),
                  subtitle: Text(
                    '@username'
                  ),
                ),
                onTap: () {

                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0, 
                      ContactUs()
                    )
                  );

                },
              ),
              SizedBox(height: 12.0,)
            ],
          )
      ),
    );

    }

    return LoadingAnimation();
    
  }
}