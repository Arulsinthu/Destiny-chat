import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../gv_chat_icons.dart';
import './login_screen.dart';
import './signup_screen.dart';
import '../buttons/primary_button.dart';

class WelcomeScreen2 extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen2({Key? key}) : super(key: key);

  @override
  _WelcomeScreen2State createState() => _WelcomeScreen2State();
}

class _WelcomeScreen2State extends State<WelcomeScreen2> {
  googleLogin() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) return;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    // if (!documentSnapshot.exists) {
    //   await showUsernameDialog(credential);
    // } else {

    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/k.jpeg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                child: Align(
                  alignment: Alignment(0.0, 0.3),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100.0)),
                          minimumSize: Size(150, 70),
                          primary: Color(0xFFFedd3c0),
                          elevation: 0),
                      onPressed: () {
                        Navigator.of(context).pushNamed(LoginScreen.routeName);
                      },
                      child: Text(
                        'Log in',
                        style: GoogleFonts.aladin(
                            fontSize: 40, color: Colors.black),
                      )),
                ),
              ),
              Container(
                  alignment: Alignment(0.0, 0.55),
                  child: ElevatedButton.icon(
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFFFedd3c0)),
                      onPressed: () {
                        googleLogin();
                      },
                      icon: Icon(CustomIcons.google),
                      label: Text('Sign in with Google'))),
              Container(
                alignment: Alignment(-0.5, 0.73),
                child: Text(
                  'No Account ? ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment(0.5, 0.75),
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(SignupScreen.routeName);
                    },
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    )),
              ),
            ],
          )),
    );
  }
}
