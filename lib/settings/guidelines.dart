import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GuideLines extends StatelessWidget {
  const GuideLines({ Key? key }) : super(key: key);

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
          'Animizu Guidelines'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: importantPagesCollection.doc('n40buJt4f2bT7IqL5us0').get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {

                Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;

                return Column(
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'Following guidelines established for the operation and use of Animizu. They might arbitrarily change at our discretion as a result of changes in society and be sure to stay updated.\n\n',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        TextSpan(
                          text: '${data['guideLineText'].toString().replaceAll('/n', '\n')}',
                        ),
                        
                        TextSpan(
                          text: 'The following works can be considered as prohibited acts and potential candidates for removal \n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                          text: '${data['prohibitedActText'].toString().replaceAll('/n', '\n')}',
                        ),
                        
                        TextSpan(
                          text: 'Guideline for adding tags\n\n',
                          style: TextStyle(
                            fontWeight: FontWeight.bold
                          )
                        ),
                        TextSpan(
                          text: '${data['tagGuideLineText'].toString().replaceAll('/n', '\n')}',
                        ),
                      ],
                    ), 
                  ),
                ],
              );

              }

              return Center(
                child: LoadingAnimation()
              );

            }
          ),
        ),
      )
    );
  }
}