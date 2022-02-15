import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/services/auth_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ResetPassword extends StatefulWidget {

  final String otpCode;

  ResetPassword({ Key? key, required this.otpCode }) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  AuthReq _authReq = AuthReq();

  String email = '';
  String password = '';
  String confirmPassword = '';

  // ---------- validation functions --------------

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

   String? get passwordErrorText {
    // final text = _textController.value.text;
    if (password.isNotEmpty && password.length < 8) {
      return 'Password must be more than 8 characters';
    }
      return null;
    }

  String? get confirmPSErrorText {

    if (confirmPassword.isNotEmpty && confirmPassword.length < 8) {
      return 'Password must be more than 8 characters';
    }

    if(confirmPassword.isNotEmpty && confirmPassword != password) {
      return 'Password does not match';
    }
      return null;
    }

  // ---------- End validation functions --------------

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Reset your password', 
                    style: TextStyle(
                      fontSize: 24.0, 
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 36.0),
                  Text(
                    'Email', 
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.grey
                      ),
                    ),
                  TextFormField(
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: emailErrorText
                      // hintText: 'Enter your Email'
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    // validation
                    validator: (val) => val!.isEmpty ? 'Enter an Email' : null,
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'New password', 
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.grey
                      ),
                    ),
                  TextFormField(
                    obscureText: true,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: passwordErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    // validation
                    // validator: (val) => val!.length < 6 ? 'Enter password 6+ characters long' : null,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Confirm password', 
                    style: TextStyle(
                      fontSize: 16.0, 
                      color: Colors.grey
                      ),
                    ),
                  TextFormField(
                    obscureText: true,
                    cursorColor: ColorTheme.primary,
                    decoration: InputDecoration(
                      //hintText: 'Enter your Password'
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: ColorTheme.primary)
                      ),
                      errorText: confirmPSErrorText
                    ),
                    style: TextStyle(
                      fontSize: 18
                    ),
                    // validation
                    // validator: (val) => val!.length < 6 ? 'Enter password 6+ characters long' : null,
                    onChanged: (val) {
                      setState(() {
                        confirmPassword = val;
                      });
                    },
                  ),
                  SizedBox(height: 28.0,),
                  Center(
                  child: Container(
                    width: double.infinity,
                    child: ElevatedButton( 
                      child: Text(
                        'RESET', 
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
                      onPressed:(
                        emailErrorText == null &&
                        passwordErrorText == null &&
                        confirmPSErrorText == null
                      ) ? () async {
        
                        if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                  
                          Fluttertoast.showToast(
                            msg: "Please fill all the required fields",
                            toastLength: Toast.LENGTH_SHORT,
                          );
                  
                        } else {
        
                          dynamic response = await _authReq.resetPassword(
                            email, 
                            widget.otpCode, 
                            password, 
                            confirmPassword
                          );
        
                          if(response == 200) {
        
                            Fluttertoast.showToast(
                              msg: "Password reset successfully!",
                              toastLength: Toast.LENGTH_SHORT,
                            );
        
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyApp()
                              ),
                            );
        
                          } else if(response == 401) {

                            Fluttertoast.showToast(
                              msg: "token is invalid or has expired!",
                              toastLength: Toast.LENGTH_SHORT,
                            );

                          }
        
                        }
                        
                        // if(email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                    
                        //   Fluttertoast.showToast(
                        //     msg: "Please fill all the required fields",
                        //     toastLength: Toast.LENGTH_SHORT,
                        //   );
                    
                        // } else {
              
                        //   _authReq.signUp(userSignUp: UserSignUp(
                        //     name: username,
                        //     username: username,
                        //     email: email,
                        //     password: password,
                        //     passwordConfirm: confirmPassword
                        //   )).then((value) => {
        
                        //     Navigator.pushAndRemoveUntil(
                        //       context,
                        //       MaterialPageRoute(builder: (context) => MyApp()),
                        //       (Route<dynamic> route) => false,
                        //     )
        
                        //   }).onError((error, stackTrace) {
                        //     print('yoyo $error');
                        //     return Future.error(error!);
                        //   });
                         
                        // }
                      } : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}