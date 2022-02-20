import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/loading_animation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({ Key? key }) : super(key: key);

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
          'Animizu Privacy & policy'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 16.0
          ),
          child: FutureBuilder<DocumentSnapshot>(
            future: importantPagesCollection.doc('4hgLX5cp2uwc4nHvSeEd').get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              
            
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {

                Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;

                return Text(
                  '${data['privacyPolicy'].toString().replaceAll('/n', '\n')}',
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
          ),
        ),
      ),
    );
  }
}