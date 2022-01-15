import 'package:anime_fanarts/post.dart';
import 'package:flutter/material.dart';

class Explore extends StatefulWidget {
  const Explore({ Key? key }) : super(key: key);

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Post(
          id: '123',
          name: 'Levi Ackerman',
          profilePic: 'https://cdna.artstation.com/p/assets/images/images/031/257/402/large/yukisho-art-vector-6.jpg?1603101769&dl=10',
          desc: 'hello!',
          postImg: 'https://images.alphacoders.com/120/thumb-1920-1203420.png',
          userId: 'user123',
          date: '15 jan 2022',
          reactionCount: 4,
          isUserPost: true
        );
      },
    );
  }
}