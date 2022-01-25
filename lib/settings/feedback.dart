import 'package:anime_fanarts/services/firestore_service.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class GiveFeedback extends StatelessWidget {
  GiveFeedback({ Key? key }) : super(key: key);

  final FirestoreService _firestireService = FirestoreService();

  final TextEditingController _feedbackTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
          'Give feedback'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 32.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Your feedback is precious to us. It helps us to make Anime fanarts even better',
                style: TextStyle(
                  fontSize: 18.0, 
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 24.0,),
              Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorTheme.primary
                  ),
                  borderRadius: BorderRadius.circular(3)
                ),
                child: TextFormField(
                  controller: _feedbackTextController,
                  cursorColor: ColorTheme.primary,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: ColorTheme.primary),
                    // ),
                    // errorText: emailErrorText
                    hintText: 'type feedback here...',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(
                    fontSize: 16
                  ),
                  // validation
                  validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                  onChanged: (val) {
                  
                  },
                ),
              ),
              SizedBox(height: 124.0,),
              // Linkify(
              //   onOpen: (link) async {
              //     if (await canLaunch(link.url)) {
              //       await launch(link.url);
              //     } else {
              //       throw 'Could not launch $link';
              //     }
              //   },
              //   text: 'If you would like to give us more info about your feedback please be kind enough to fill this feedaback form.',
              //   style: TextStyle(
              //     fontSize: 16.0, 
              //     color: Colors.black,
              //     fontWeight: FontWeight.normal,
              //     height: 1.3
              //   ),
              //   linkStyle: TextStyle(
              //     color: ColorTheme.primary,
              //     fontSize: 16,
              //     fontWeight: FontWeight.w500,
              //   ),
              // ),
              // SizedBox(height: 32.0,),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0
                    ),
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: ColorTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                  onPressed: () {

                    if(_feedbackTextController.text.isNotEmpty) {

                      _firestireService.sendUserFeedback(
                        _feedbackTextController.text, 
                        '123'
                      ).whenComplete(() {

                        Fluttertoast.showToast(
                          msg: "Thank you for your valuable thoughts!",
                          toastLength: Toast.LENGTH_SHORT,
                        );

                        Navigator.of(context).pop();

                      });

                    } else {

                      Fluttertoast.showToast(
                        msg: "Please give us your valuable thoughts!",
                        toastLength: Toast.LENGTH_SHORT,
                      );

                    }
              
                  }, 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}