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

              // return Column(
              //   children: [
              //     RichText(
              //       text: TextSpan(
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 16,
              //         ),
              //         children: <TextSpan>[
              //           TextSpan(
              //             text: 'Following guidelines established for the operation and use of Animizu. They might arbitrarily change at our discretion as a result of changes in society and be sure to stay updated.\n\n',
              //             style: TextStyle(
              //               color: Colors.black,
              //               fontWeight: FontWeight.bold
              //             ),
              //           ),
              //           TextSpan(
              //             text: '• Do not reupload other’s works.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works that contain threats, defamation, or which cause economic or mental harm.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works that contain needlessly warped or distorted depictions of sex.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works that contain shockingly or disturbingly strong violence.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works that promote needlessly extreme ideas.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works with an unfavorable depiction of any ethnicity, belief, occupation, sex or religion.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works displaying the actions of religious cults or political extremists.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not upload works which contain clearly sexualized depictions of young children.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Do not add tags that are unrelated to the content of a work.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• If your work contain genitals or parts reminiscent of genitals and Sexual acts they must me consored.\n\n',
              //           ),
              //           TextSpan(
              //             text: 'The following works can be considered as prohibited acts and potential candidates for removal \n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: '• Submitting multiple prohibited works which violate above conditions\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Adding tags or comments which are defamatory, or which would cause economic or mental harm.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Posting user IDs or image IDs from this service on other websites or services for defamatory purposes.\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Anything that places extreme, excessive, or undue burden on the server(s).\n\n',
              //           ),
              //           TextSpan(
              //             text: 'Guideline for adding tags\n\n',
              //             style: TextStyle(
              //               fontWeight: FontWeight.bold
              //             )
              //           ),
              //           TextSpan(
              //             text: '• Add anime/manga name if have\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Add character(s) names if have\n\n',
              //           ),
              //           TextSpan(
              //             text: '• Add any other relevant tags if have\n\n',
              //           ),
              //         ],
              //       ), 
              //     ),
              //   ],
              // );
            }
          ),
        ),
      )
    );
  }
}