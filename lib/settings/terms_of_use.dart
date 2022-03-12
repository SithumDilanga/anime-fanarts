import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:anime_fanarts/utils/colors.dart';

class TermsOfUse extends StatelessWidget {
  const TermsOfUse({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    CollectionReference importantPagesCollection = FirebaseFirestore.instance.collection('importantPages');

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
          'Animizu Terms of use'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: importantPagesCollection.doc('ZMfhmc4NE3usr6U8M2Tl').get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {

                Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;

                return Text(
                  '${data['termsOfUse'].toString().replaceAll('/n', '\n')}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                );
              }
            
              return Center(
                child: LoadingAnimation()
              );

            }
          )
        )
      )
    );
  }
}