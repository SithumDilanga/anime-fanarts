import 'package:anime_fanarts/profile/users_profile.dart';
import 'package:anime_fanarts/search/artworks_search.dart';
import 'package:anime_fanarts/search/search-3.dart';
import 'package:anime_fanarts/search/users_search.dart';
import 'package:anime_fanarts/settings/settings.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:flutter/material.dart';

class SearchStart extends StatefulWidget {
  const SearchStart({ Key? key }) : super(key: key);

  @override
  State<SearchStart> createState() => _SearchStartState();
}

class _SearchStartState extends State<SearchStart> with SingleTickerProviderStateMixin {

  late TabController _tabController;

  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {
          _activeIndex = _tabController.index;
        });
      }
    });

    print('tabindex $_activeIndex');
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xffF0F0F0),
          appBar: AppBar(
            backgroundColor: Color(0xffF0F0F0),
            elevation: 0,
            title: Builder(builder: (context){
              final index = DefaultTabController.of(context)!.index;   
              return Text(
                _activeIndex == 0 ? 'Search Artworks' : 'Search Users',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18
                ),
              );
            }),
            // title: Text(
            //   DefaultTabController.of(context)?.index == 0 ? 'Search Artworks' : 'Search Users',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 18
            //   ),
            // ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }, 
            ),
            automaticallyImplyLeading: false,
            actions: <Widget> [
              IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
                onPressed: () {

                  Navigator.of(context).push(
                    RouteTransAnim().createRoute(
                      1.0, 0.0,
                      Search3(
                        tabIndex: _activeIndex,
                      )
                    )
                  );

                  // showSearch(
                  //   context: context, 
                  //   delegate: MySearchDelegate(),
                  // );
    
                }, 
              ),
              SizedBox(width: 16.0,)
            ],
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: ColorTheme.primary,
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  width: 2.0,
                  color: ColorTheme.primary
                ),
                insets: EdgeInsets.symmetric(
                  horizontal: 16.0
                )
              ),
              labelColor: ColorTheme.primary,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(
                  text: 'Artworks',
                ),
                Tab(
                  text: 'Users',
                ),
              ]
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ArtworksSearch(),
              UsersSearch()
            ],
          )
        ),
      ),
    );
  }
}