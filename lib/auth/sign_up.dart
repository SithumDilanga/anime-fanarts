import 'package:anime_fanarts/auth/log_in.dart';
import 'package:anime_fanarts/main.dart';
import 'package:anime_fanarts/models/user_sign_up.dart';
import 'package:anime_fanarts/services/auth_req.dart';
import 'package:anime_fanarts/utils/colors.dart';
import 'package:anime_fanarts/utils/route_trans_anim.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({ Key? key }) : super(key: key);  

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  // AuthService _authService = AuthService();

  // to identify the form
  final _formKey = GlobalKey<FormState>();

  AuthReq _authReq = AuthReq();

  // text fields
  String username = '';
  String name = '';
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

  String? get usernameErrorText {

    if (username.isNotEmpty && username.length < 4) {
      return 'Username must be at least 4 characterss';
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
    return Material(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: SingleChildScrollView(
          child: SafeArea(
            child: Form(
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/animizu cover 4x3.jpeg',
                      height: 300,
                      width: double.infinity,
                       fit: BoxFit.cover,
                    ),
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
                    //   padding: const EdgeInsets.fromLTRB(8.0, 32.0, 0, 0),
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
                                'Username', 
                                style: TextStyle(
                                  fontSize: 16.0, 
                                  color: Colors.grey
                                ),
                              ),
                              TextFormField(
                                // controller: _textController,
                                cursorColor: ColorTheme.primary,
                                decoration: InputDecoration(
                                  //hintText: 'Enter your Name'
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorTheme.primary)
                                  ),
                                  errorText: usernameErrorText
                                ),
                                style: TextStyle(
                                  fontSize: 18
                                ),
                                inputFormatters: [
                                  // not letting user add white spaces
                                  FilteringTextInputFormatter.deny(
                                    RegExp(r'\s')
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    username = val;
                                  });
                                },
                              ),    
                              SizedBox(height: 16.0),   
                              Text(
                                'Name', 
                                style: TextStyle(
                                  fontSize: 16.0, 
                                  color: Colors.grey
                                ),
                              ),
                              TextFormField(
                                // controller: _textController,
                                cursorColor: ColorTheme.primary,
                                decoration: InputDecoration(
                                  //hintText: 'Enter your Name'
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: ColorTheme.primary)
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 18
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    name = val;
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
                              SizedBox(height: 16.0),
                              Text(
                                'Confirm Password', 
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
                                onChanged: (val) {
                                  setState(() {
                                    confirmPassword = val;
                                  });
                                },
                              ),
                              SizedBox(height: 24.0,),
                              Center(
                                child: ElevatedButton( 
                                  child: Text(
                                    'SIGN UP', 
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
                                    usernameErrorText == null &&
                                    passwordErrorText == null && 
                                    confirmPSErrorText == null
                                  ) ? () async {
                                    
                                    if(email.isEmpty || username.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
              
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
                                            Text('Signing up...'),
                                          ],
                                        ),
                                        duration: Duration(days: 1),
                                      );

                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
          
                                      _authReq.signUp(userSignUp: UserSignUp(
                                        name: name,
                                        username: username,
                                        email: email,
                                        password: password,
                                        passwordConfirm: confirmPassword
                                      )).then((value) {

                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(builder: (context) => MyApp(selectedPage: 0)),
                                          (Route<dynamic> route) => false,
                                        );

                                      }).onError((error, stackTrace) {

                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();

                                        return Future.error(error!);

                                      });
                                     
                                    }
                                  } : null,
                                ),
                              ),
                              SizedBox(height: 16.0,),
                              Center(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Login',
                                        style: TextStyle(
                                          color: ColorTheme.primary,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = (){
                                          print('tapped');
                                          Navigator.of(context).push(
                                            RouteTransAnim().createRoute(
                                              1.0, 0.0, 
                                              Login()
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
        ),
    );
  }
}