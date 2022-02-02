import 'package:anime_fanarts/auth/reset_password.dart';
import 'package:anime_fanarts/services/auth_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class VerificationCode extends StatefulWidget {

  final String email;

  VerificationCode({ Key? key, required this.email }) : super(key: key);

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {

  AuthReq _authReq = AuthReq();

  final TextEditingController _otpTextController = TextEditingController();
  

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
              'Verification code',
              style: TextStyle(
                fontSize: 18.0, 
                color: Colors.black,
                fontWeight: FontWeight.w800
              ),
            ),
            SizedBox(height: 8.0,),
            Text(
              'verification code has been sent to your email address',
              style: TextStyle(
                fontSize: 16.0, 
                color: Colors.black,
                fontWeight: FontWeight.normal
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
                controller: _otpTextController,
                cursorColor: ColorTheme.primary,
                // maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  // focusedBorder: UnderlineInputBorder(
                  //   borderSide: BorderSide(color: ColorTheme.primary),
                  // ),
                  // errorText: emailErrorText
                  hintText: 'type verification code here...',
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
            // SizedBox(height: 28.0,),
            
            SizedBox(height: 28.0,),
            Center(
              child: Container(
                width: double.infinity,
                child: ElevatedButton( 
                  child: Text(
                    'NEXT', 
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
                  onPressed:() async {

                    if(_otpTextController.text.isNotEmpty) {

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPassword(
                            otpCode: _otpTextController.text,
                          )
                        ),
                      );

                    }
                    
                    if(_otpTextController.text.isEmpty) {

                      Fluttertoast.showToast(
                        msg: "Please enter verification code!",
                        toastLength: Toast.LENGTH_SHORT,
                      );

                    }
                    
                  },
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}