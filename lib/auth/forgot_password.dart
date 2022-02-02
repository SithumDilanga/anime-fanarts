import 'package:anime_fanarts/auth/verification_code.dart';
import 'package:anime_fanarts/services/auth_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({ Key? key }) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  AuthReq _authReq = AuthReq();

  String email = '';

  String? get emailErrorText {

    bool isValid = EmailValidator.validate(email);

    if(email.isEmpty) {
      return null;
    }

    if (!isValid) {
      return 'Invalid email';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Color(0xffF0F0F0),
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: ColorTheme.primary,
          ),
          onPressed: () {
            Navigator.pop(context);
          }, 
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          // vertical: 24.0,
          horizontal: 24.0
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Verification code will be sent to your email, then you can reset your password',
              style: TextStyle(
                fontSize: 24.0, 
                color: Colors.black,
                fontWeight: FontWeight.bold
              ),
            ),
            SizedBox(height: 48.0,),
            Text(
              'Your email',
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
                cursorColor: ColorTheme.primary,
                // maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  // focusedBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: ColorTheme.primary),
                  // ),
                  // errorText: emailErrorText,
                  hintText: 'type email here...',
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
                  setState(() {
                    email = val;
                  });
                },
              ),
            ),
            SizedBox(height: 28.0,),
            Center(
              child: Container(
                width: double.infinity,
                child: ElevatedButton( 
                  child: Text(
                    'SEND', 
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.white
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: ColorTheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)
                    ),
                    padding: EdgeInsets.fromLTRB(66.0, 16.0, 66.0, 16.0),
                  ),
                  onPressed:(emailErrorText == null) ? () async {

                    if(email.isNotEmpty) {

                      dynamic response = await _authReq.forgotPassword(
                        email
                      );

                      print('shitty response $response');

                      if(response == 200) {

                         Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VerificationCode(
                              email: email,
                            )
                          ),
                        );

                        Fluttertoast.showToast(
                          msg: "Verification code has been sent to your email!",
                          toastLength: Toast.LENGTH_SHORT,
                        );
                                                
                      } else {

                        Fluttertoast.showToast(
                          msg: "Error sending verification code!",
                          toastLength: Toast.LENGTH_SHORT,
                        );

                      }

                      // .whenComplete(() {

                        

                      //   Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => VerificationCode(
                      //         email: email,
                      //       )
                      //     ),
                      //   );

                      // });

                      if(email.isEmpty) {
                        
                        Fluttertoast.showToast(
                          msg: "Please enter your email!",
                          toastLength: Toast.LENGTH_SHORT,
                        );

                      }

                    }

                  } : null,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}