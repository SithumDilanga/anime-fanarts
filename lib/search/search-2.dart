import 'package:anime_fanarts/search/artworks_search.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';

class Search2 extends StatefulWidget {
  const Search2({ Key? key }) : super(key: key);

  @override
  State<Search2> createState() => _Search2State();
}

class _Search2State extends State<Search2> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded
            ),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: MySearchDelegate(),
              );
            }, 
          )
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        // Use this to change the query's text style
        headline6: TextStyle(
          fontSize: 20.0, 
          color: Colors.black
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xffF0F0F0),
        elevation: 0
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        
        // Use this change the placeholder's text style
        hintStyle: TextStyle(fontSize: 24.0),
      ),
    );
  }

  List<String> searchResults = [
    'AOT',
    'Demon slayer',
    'Death note',
    'Wotakoi'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(
          Icons.clear_rounded,
          color: Colors.black,
        ),
        onPressed: () {

          if(query.isEmpty) {
            close(context, null); //close searchbar
          } else {
            query = '';
          }

        }, 
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_rounded,
        color: Colors.black,
      ),
      onPressed: () => close(context, null), // close the screen 
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: Color(0xffF0F0F0),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: TabBar(
              indicatorColor: ColorTheme.primary,
              labelColor: ColorTheme.primary,
              unselectedLabelColor: Colors.grey[700],
              tabs: [
                Tab(
                  text: 'Artworks',
                ),
                Tab(
                  text: 'Users',
                ),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              ArtworksSearch(),
              Icon(Icons.directions_transit),
            ],
          )
        ),
      ),
    );

    // return Center(
    //   child: Text(
    //     query,
    //     style: const TextStyle(
    //       fontSize: 64,
    //       fontWeight: FontWeight.bold
    //     ),
    //   ),
    // );
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    // List<String> suggestions = [
    //   'AOT',
    //   'Demon slayer',
    //   'Death note',
    //   'Wotakoi'
    // ];

    List<String> suggestions = searchResults.where((searchResult) {

      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);

    }).toList();

    return Material(
      color: Color(0xffF0F0F0),
      child: ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
    
          final suggestion = suggestions[index];
    
          return ListTile(
            title: Text(
              suggestion,
            ),
            onTap: () {
              query = suggestion;
    
              showResults(context);
            },
          );
    
        }
      ),
    );
  }



}