import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:anime_fanarts/auth/sign_up.dart';
// import 'package:motivational_quotes/home/home.dart';
// import 'package:motivational_quotes/services/auth.dart';

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
                    'assets/images/kimi no wa 3.jpg',
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: 28.0,),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5
                            ),
                            borderRadius: BorderRadius.circular(16)
                          ),
                          child: Text(
                            'Anime Fanarts',
                            style: GoogleFonts.alegreyaSans(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: 4.0,),
                        // Text(
                        //   'make someone inspire',
                        //   style: TextStyle(
                        //     color: Colors.white
                        //   ),
                        // ),
                        SizedBox(height: 16.0,),
                        Text(
                          'one place for anime fanarts',
                          style: GoogleFonts.patrickHand(
                            color: Colors.white,
                            fontSize: 24
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8.0, 16.0, 0, 0),
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white, size: 32.0,), 
                      onPressed: () {
                        Navigator.pop(context);
                      }
                    ),
                  ),
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
                              cursorColor: Colors.amber[700],
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: (Colors.amber[700]!))
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
                              cursorColor: Colors.amber[700],
                              decoration: InputDecoration(
                                //hintText: 'Enter your Password'
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: (Colors.amber[700]!))
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
                            SizedBox(height: 48.0,),
                            Center(
                              child: RaisedButton(
                                child: Text('LOGIN', style: TextStyle(fontSize: 16.0, color: Colors.white),),
                                color: Colors.amber[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25)
                                ),
                                padding: EdgeInsets.fromLTRB(66.0, 16.0, 66.0, 16.0),
                                onPressed:(
                                  emailErrorText == null &&
                                  passwordErrorText == null
                                ) ? () async {
                                  
                                  if(email.isEmpty || password.isEmpty) {
        
                                    Fluttertoast.showToast(
                                      msg: "Please fill all the required fields",
                                      toastLength: Toast.LENGTH_SHORT,
                                    );
        
                                  } else {
        
                                    // logging a user with email and password
                                    // dynamic result = await _authService.signInWithEmailAndPassword(email, password);
        
                                    // // if(result == null) {
                                    // //     // changing the errorMsg
                                    // //     setState(() {
        
                                    // //       Fluttertoast.showToast(
                                    // //         msg: "Plaese enter a valid email and password",
                                    // //         toastLength: Toast.LENGTH_LONG,
                                    // //         gravity: ToastGravity.BOTTOM,
                                    // //         fontSize: 16.0
                                    // //       );
                                    // //     });
        
                                    // //   } 
                                    //   if(result != null) {
        
                                    //     Fluttertoast.showToast(
                                    //       msg: "Login Success!",
                                    //       toastLength: Toast.LENGTH_LONG,
                                    //       gravity: ToastGravity.BOTTOM,
                                    //       fontSize: 16.0
                                    //     );
        
                                    //     Navigator.pushAndRemoveUntil(
                                    //       context,
                                    //       MaterialPageRoute(builder: (context) => Home(selectedPage: 1,)),
                                    //       (Route<dynamic> route) => false,
                                    //     );
                                    //   }
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
                                      fontSize: 16.0
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Sign Up',
                                        style: TextStyle(
                                          color: Colors.amber[600],
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline
                                        ),
                                        recognizer: TapGestureRecognizer()..onTap = (){
                                          print('tapped');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SignUp()
                                            ),
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