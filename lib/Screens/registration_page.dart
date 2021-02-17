import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/Styles/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:fluttertoast/fluttertoast.dart';

import 'package:email_validator/email_validator.dart';
import 'basic_info.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final regEmailController = TextEditingController();
  final regPasswordController1 = TextEditingController();
  final regPasswordController2 = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfcfcfc),
      appBar: kappbar('Register'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 60.0, bottom: 50),
            //   child: Container(
            //     height: 150.0,
            //     width: 190.0,
            //     padding: EdgeInsets.only(top: 40),
            //     decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(200),
            //         color: Colors.grey),
            //     child: Center(
            //         // child: Image.asset('assets/logo_waryaa.png'),
            //         ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 50, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    "Merhaba",
                    style: kwelcomescreentextStyle(
                        FontWeight.bold, 60.0, Colors.black),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 0, 30),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 300.0,
                  child: TypewriterAnimatedTextKit(
                    speed: Duration(milliseconds: 300),
                    onTap: () {
                      print("Tap Event");
                    },
                    text: ["Habibi.", "u gay"],
                    textStyle: kwelcomescreentextStyle(
                        FontWeight.bold, 60.0, Color(0xFF00766c)),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  style: ktextStyle(FontWeight.w600, 20.0, Colors.black),
                  controller: regEmailController,
                  inputFormatters: [
                    FilteringTextInputFormatter.singleLineFormatter,
                  ], // Only numbers
                  decoration: kdecoration('Email Here')),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  style: ktextStyle(FontWeight.w600, 16.0, Colors.black),
                  obscureText: true,
                  controller: regPasswordController1,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ], // Only numbers
                  keyboardType: TextInputType.number,
                  decoration: kdecoration('Password Here (minimum 6 digit)')),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  style: ktextStyle(FontWeight.w600, 16.0, Colors.black),
                  obscureText: true,
                  controller: regPasswordController2,
                  keyboardType: TextInputType.number,
                  decoration:
                      kdecoration('Retype Your Password (minimum 6 digit)')),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(
            //       left: 15.0, right: 15.0, top: 15, bottom: 0),
            //   child: FlatButton(
            //     onPressed: () {},
            //     child: Text(
            //       'Get Your Password by SMS',
            //       style: TextStyle(color: Colors.blue, fontSize: 15),
            //     ),
            //   ),
            // ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: RoundedButton(
                    title: 'Next',
                    content: 'hello',
                    fontcolor: Colors.white,
                    buttoncolor: Color(0xFF00766c),
                    function: () {
                      print(regEmailController.text);
                      print(regPasswordController1.text);
                      print(regPasswordController2.text);

                      // if (regPasswordController1.text.length > 0 &&
                      //     regPasswordController2.text.length > 0) {
                      //   if (regPasswordController1 == regPasswordController2) {
                      //     Navigator.pushNamed(context, '/basic_info');
                      //   } else {
                      //     Toast.show("Passwords did not match", context,
                      //         duration: Toast.LENGTH_SHORT,
                      //         gravity: Toast.BOTTOM);
                      //   }
                      // } else {
                      //   Toast.show("Please add a password to continue", context,
                      //       duration: Toast.LENGTH_SHORT,
                      //       gravity: Toast.BOTTOM);
                      // }

                      if (EmailValidator.validate(regEmailController.text)) {
                        print("Correct");
                      } else {
                        _displaySnackBar(context,
                            "Email is not correct, please check again?");
                        print("Not correct");
                      }

                      if (regPasswordController1.text.length > 0 &&
                          regPasswordController1.text.length > 5) {
                        print("Correct");
                      } else {
                        _displaySnackBar(context,
                            "Password should be minimum 6 digits long");
                      }

                      if (regPasswordController2.text.length > 0 &&
                          regPasswordController2.text.length > 5) {
                        print("Correct");
                      } else {
                        _displaySnackBar(context,
                            "Password should be minimum 6 digits long");
                      }

                      if (regPasswordController2.text ==
                          regPasswordController1.text) {
                        print("Correct");
                      } else {
                        _displaySnackBar(context, "Password did not match");
                      }
//fix logic here

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BasicInfo(
                              userEmail: regEmailController.text,
                              userPassword: regPasswordController1.text),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _displaySnackBar(BuildContext context, String title) {
    final snackBar = SnackBar(content: Text(title));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
