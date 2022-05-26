import 'package:anime_fanarts/post.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';

class ArtworksSearch extends StatefulWidget {
  const ArtworksSearch({ Key? key }) : super(key: key);

  @override
  State<ArtworksSearch> createState() => _ArtworksSearchState();
}

class _ArtworksSearchState extends State<ArtworksSearch> {

  List tags = ['GlowArt', 'Sketch', 'DigitalArt', 'Cosplay', 'Original', 'AnimeGirl', 'Watercolor', '3D'];
  List imageLinks = [
    'https://i.pinimg.com/736x/0d/05/2e/0d052e818fff7d5491adadfacb4dd3af.jpg',
    'https://www.drawingskill.com/wp-content/uploads/5/Anime-Sketch-Art-Drawing.jpg',
    'https://64.media.tumblr.com/cc27537b836f11ff2beb195bda5a6be5/tumblr_oz44dxcjN41wt7ek9o1_1280.jpg',
    'https://akibamarket.com/wp-content/uploads/2022/05/104852-spy-x-family-neneko-sorprende-con-un-cosplay-de-anya-forger.png',
    'https://i.pinimg.com/736x/7b/49/26/7b4926b483e66d34e46a3d8eaad2453b.jpg',
    'https://data.whicdn.com/images/323989653/original.jpg',
    'https://pm1.narvii.com/6790/3fa83eb88d03ab037f1fbf8651c022e3138e55b5v2_hq.jpg',
    'https://i.pinimg.com/564x/11/01/29/1101296915a58a6eb2b29839360881ef.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF0F0F0),
      child: GridView.builder(
        padding: EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 1 / 1,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8
        ),
        itemCount: tags.length,
        itemBuilder: (BuildContext context, index) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              '#${tags[index]}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.white
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                // opacity: 0.5,
                colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.7), BlendMode.dstATop
                ),
                image: NetworkImage(
                  '${imageLinks[index]}'
                ),
                fit: BoxFit.cover
              ),
            ),
          );
        }
      ),
      // child: ListView.builder(
      //   itemCount: 1,
      //   itemBuilder: (context, index) {
      //     return Post(
      //       id: 'sdsd',
      //       name: 'SDLive',
      //       profilePic: 'https://i.pinimg.com/550x/75/3c/73/753c73bc1696a9c20afb3f1c22eae84f.jpg' ,
      //       desc: 'description',
      //       postImg: ['https://i.pinimg.com/originals/b9/6c/e2/b96ce262d5dfa77fd68dffc06d4881ed.png'],
      //       userId: 'sdsd12',
      //       date: '2022-03-18T08:37:43.687+00:00', //formattedDate,
      //       reactionCount: 10,
      //       commentCount: 5,
      //       isUserPost: false,
      //       isReacted: false,
      //       // reactedPosts: reactedPost
      //     );
      //   }
      // ),
    );
  }
}