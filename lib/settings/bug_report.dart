import 'package:anime_fanarts/services/firestore_service.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class BugReport extends StatelessWidget {
  BugReport({ Key? key }) : super(key: key);

  final FirestoreService _firestireService = FirestoreService();

  final TextEditingController _deviceTextController = TextEditingController();
  final TextEditingController _andriodTextController = TextEditingController();
  final TextEditingController _descTextController = TextEditingController();

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
          'Bug report'
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We appreciate you for taking your time to report bugs. It helps us to make Anime fanarts even better',
                style: TextStyle(
                  fontSize: 18.0, 
                  color: Colors.black,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 24.0,),
              RichText(
                text: TextSpan(
                  text: 'Device you use ',
                  style: TextStyle(
                    fontSize: 18.0, 
                    color: Colors.black,
                    fontWeight: FontWeight.w800
                  ),
                  children: [
                    TextSpan(
                      text: '(eg: samsung galaxy 9A)',
                      style: TextStyle(
                        fontSize: 16.0, 
                        color: Colors.black,
                        fontWeight: FontWeight.normal
                      )
                    )
                  ],
                ),
              ),
              // Text(
              //   'Device you use (eg: samsung galaxy 9A)',
              //   style: TextStyle(
              //     fontSize: 18.0, 
              //     color: Colors.black,
              //     fontWeight: FontWeight.w800
              //   ),
              // ),
              SizedBox(height: 16.0,),
              Container(
                // margin: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  controller: _deviceTextController,
                  cursorColor: ColorTheme.primary,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: ColorTheme.primary),
                    // ),
                    // errorText: emailErrorText
                    hintText: 'type your device...',
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
              SizedBox(height: 24.0,),
              Text(
                'Andriod version you use',
                style: TextStyle(
                  fontSize: 18.0, 
                  color: Colors.black,
                  fontWeight: FontWeight.w800
                ),
              ),
              SizedBox(height: 16.0,),
              Container(
                // margin: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  controller: _andriodTextController,
                  cursorColor: ColorTheme.primary,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: ColorTheme.primary),
                    // ),
                    // errorText: emailErrorText
                    hintText: 'type your andriod version...',
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
              SizedBox(height: 24.0,),
              Text(
                'Describe the issue',
                style: TextStyle(
                  fontSize: 18.0, 
                  color: Colors.black,
                  fontWeight: FontWeight.w800
                ),
              ),
              SizedBox(height: 16.0,),
              Container(
                // margin: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                  controller: _descTextController,
                  cursorColor: ColorTheme.primary,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    // focusedBorder: UnderlineInputBorder(
                    //   borderSide: BorderSide(color: ColorTheme.primary),
                    // ),
                    // errorText: emailErrorText
                    hintText: 'type descriptio here...',
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
              SizedBox(height: 32.0,),
              Linkify(
                onOpen: (link) async {
                  if (await canLaunch(link.url)) {
                    await launch(link.url);
                  } else {
                    throw 'Could not launch $link';
                  }
                },
                text: 'If you would like to give us more info about the issue please be kind enough to send us an email girtie.contact@gmail.com',
                style: TextStyle(
                  fontSize: 16.0, 
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  height: 1.3
                ),
                linkStyle: TextStyle(
                  color: ColorTheme.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32.0,),
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

                    if(_deviceTextController.text.isNotEmpty && _andriodTextController.text.isNotEmpty && _descTextController.text.isNotEmpty) {

                      _firestireService.sendBugReports(
                        _deviceTextController.text, 
                        _andriodTextController.text,
                        _descTextController.text,
                        '123'
                      ).whenComplete(() {

                        Fluttertoast.showToast(
                          msg: "Thank you for your valuable time!",
                          toastLength: Toast.LENGTH_SHORT,
                        );

                        Navigator.of(context).pop();

                      });

                    } else {

                      Fluttertoast.showToast(
                        msg: "Please be kind enough to fill all the required fields!",
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