import 'package:anime_fanarts/auth/forgot_password.dart';
import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/models/user_login.dart';
import 'package:anime_fanarts/services/auth_req.dart';
import 'package:anime_fanarts/services/block_user_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:anime_fanarts/auth/sign_up.dart';

class Login extends StatefulWidget {
  const Login({ Key? key }) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  // AuthService _authService = AuthService();

  // text fields
  String email = '';
  String password = '';

  AuthReq _authReq = AuthReq();
  BlockUserReq _blockUserReq = BlockUserReq();

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

  // ---------- End validation functions --------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child:  SafeArea(
          child: Form(
              child: Stack(
                children: [
                  Image.asset(
                    'assets/images/animizu cover 4x3.jpeg',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 16.0),
                  //   child: Align(
                  //     alignment: Alignment.topCenter,
                  //     child: Stack(
                  //       children: [
                  //         Text(
                  //           "It's all about Anime/Manga artworks",
                  //           style: TextStyle(
                  //             // color: Colors.white,
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //             foreground: Paint()
                  //             ..style = PaintingStyle.stroke
                  //             ..strokeWidth = 3
                  //             ..color = ColorTheme.primary,
                  //           ),
                  //         ),
                  //         Text(
                  //           "It's all about Anime/Manga artworks",
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 20,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  // Center(
                  //   child: Column(
                  //     children: [
                  //       SizedBox(height: 28.0,),
                  //       Container(
                  //         padding: EdgeInsets.all(8.0),
                  //         decoration: BoxDecoration(
                  //           border: Border.all(
                  //             color: Colors.white,
                  //             width: 1.5
                  //           ),
                  //           borderRadius: BorderRadius.circular(16)
                  //         ),
                  //         child: Text(
                  //           'Animizu',
                  //           style: GoogleFonts.alegreyaSans(
                  //             color: Colors.white,
                  //             fontSize: 38,
                  //             fontWeight: FontWeight.bold
                  //           ),
                  //         ),
                  //       ),
                  //       SizedBox(height: 4.0,),
                  //       // Text(
                  //       //   'make someone inspire',
                  //       //   style: TextStyle(
                  //       //     color: Colors.white
                  //       //   ),
                  //       // ),
                  //       SizedBox(height: 16.0,),
                  //       Text(
                  //         'one place for anime fanarts',
                  //         style: GoogleFonts.patrickHand(
                  //           color: Colors.white,
                  //           fontSize: 24
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(8.0, 16.0, 0, 0),
                  //   child: IconButton(
                  //     icon: Icon(Icons.arrow_back, color: Colors.white, size: 32.0,), 
                  //     onPressed: () {
                  //       Navigator.pop(context);
                  //     }
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 200.0, 16.0, 0),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
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
                              'Password', 
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
                            SizedBox(height: 8.0,),
                            GestureDetector(
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  'forgot password',
                                  style: TextStyle(
                                    color: ColorTheme.primary,
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),
                              onTap: () {

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPassword()
                                  ),
                                );

                              },
                            ),
                            SizedBox(height: 48.0,),
                            Center(
                              child: RaisedButton(
                                child: Text('LOGIN', style: TextStyle(fontSize: 16.0, color: Colors.white),),
                                color: ColorTheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                padding: EdgeInsets.fromLTRB(66.0, 16.0, 66.0, 16.0),
                                onPressed:(
                                  emailErrorText == null &&
                                  passwordErrorText == null
                                ) ? () async {

                                  // final snackBar = SnackBar(
                                  //   content: const Text('Yay! A SnackBar!'),
                                  //   action: SnackBarAction(
                                  //     label: 'Undo',
                                  //     onPressed: () {
                                  //       // Some code to undo the change.
                                  //     },
                                  //   ),
                                  // );

                                  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  
                                    if(email.isEmpty || password.isEmpty) {
                                    
                                      Fluttertoast.showToast(
                                        msg: "Please fill all the required fields",
                                        toastLength: Toast.LENGTH_SHORT,
                                        );
          
                                      } else {
                                    
                                        if(email.isEmpty || password.isEmpty) {
                                      
                                          Fluttertoast.showToast(
                                            msg: "Please fill all the required fields",
                                            toastLength: Toast.LENGTH_SHORT,
                                          );
  
                                    } else {

                                      final snackBar = SnackBar(
                                        content: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 16.0,),
                                            Text('Logging in...'),
                                          ],
                                        ),
                                        duration: Duration(days: 1),
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  
                                    _authReq.loginUser(userLogin: UserLogin(
                                      email: email, 
                                      password: password
                                    )).then((value) {

                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                      _blockUserReq.getBlockedUsers(
                                        isWhenLogin: true
                                      ).whenComplete(() {

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyApp(selectedPage: 0,)),
                                          (Route<dynamic> route) => false,
                                        );

                                      });


                                    }).onError((error, stackTrace) {

                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                      return Future.error(error!);

                                    });
                                    // .whenComplete(() => {
                                    //   Navigator.push(
                                    //     context,
                                    //     MaterialPageRoute(
                                    //       builder: (context) => MyApp()
                                    //     ),
                                    //   )
                                      // })
  
                                    }

                                  }
        
                                } : null,
                              ),
                            ),
                            SizedBox(height: 16.0,),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: "Don't have an account ? ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(
                                          color: ColorTheme.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = (){
                                          Navigator.of(context).push(
                                            RouteTransAnim().createRoute(
                                              1.0, 0.0, 
                                              SignUp()
                                            )
                                          );
                                        }
                                      )
                                    ]
                                  ), 
                                ),
                              ),
                          ]
                        )
                      )  
                    )
                  )
                ],
              )
            ),
        ),
        ),
      );
  }
}