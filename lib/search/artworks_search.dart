import 'package:anime_fanarts/post.dart';
import 'package:flutter/material.dart';

class ArtworksSearch extends StatefulWidget {
  const ArtworksSearch({ Key? key }) : super(key: key);

  @override
  State<ArtworksSearch> createState() => _ArtworksSearchState();
}

class _ArtworksSearchState extends State<ArtworksSearch> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListView.builder(
        itemCount: 5,
        itemBuilder: (context, index) {
          return Post(
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
          );
        }
      ),
    );
  }
}