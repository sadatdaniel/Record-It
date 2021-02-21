import 'package:base/Screens/records_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/Styles/styles.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    logoutFirst();
  }

  logoutFirst() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> closeTheApp() {
    SystemNavigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: closeTheApp,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: kappbar('Login'),
        backgroundColor: Color(0xFFfcfcfc),
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
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(15, 0, 0, 30),
              //   child: Align(
              //     alignment: Alignment.centerLeft,
              //     child: Container(
              //       child: Text(
              //         "Habibi.",
              //         style: kwelcomescreentextStyle(
              //             FontWeight.bold, 60.0, Color(0xFFd35f5f)),
              //       ),
              //     ),
              //   ),
              // ),
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
                          FontWeight.bold, 60.0, Color(0xFFd35f5f)),
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
                    style: ktextStyle(FontWeight.w600, 16.0, Colors.black),
                    controller: loginEmailController,
                    // inputFormatters: [
                    //   FilteringTextInputFormatter.digitsOnly,
                    //   LengthLimitingTextInputFormatter(10),
                    // ], // Only numbers
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
                    controller: loginPasswordController,
                    keyboardType: TextInputType.number,
                    decoration: kdecoration('Password Here')),
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
              SizedBox(
                height: 30,
              ),
              RoundedButton(
                title: 'Login',
                content: 'hello',
                fontcolor: Colors.white,
                buttoncolor: Color(0xFFd35f5f),
                function: () async {
                  print(loginEmailController.text);
                  print(loginPasswordController.text);
                  await _login(
                      loginEmailController.text, loginPasswordController.text);
                },
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Text(
                    'Do Not Have An Account?',
                    style: ktextStyle(FontWeight.w900, 15.0, Colors.black),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: RoundedButton(
                      function: () {
                        Navigator.pushNamed(context, '/registration');
                      },
                      title: 'Register',
                      content: 'hello',
                      fontcolor: Colors.white,
                      // buttoncolor: Color(0xFFd35f5f),
                      buttoncolor: Color(0xFFd35f5f),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<User> _login(userEmail, userPassword) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userEmail, password: userPassword);

      _getUserInfo();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    return null;
  }

  _getUserInfo() {
    var currentUser = FirebaseAuth.instance.currentUser;
    firestoreInstance.collection("Users").doc(currentUser.uid).get().then(
      (value) {
        bool isDoctor = value.get('isDoctor');
        if (value.get('isDoctor')) {
          Navigator.pushNamed(context, '/search_patient_page');
        } else {
          var patientNID = value.get('NID');
          // Navigator.pushNamed(context, '/records');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Records(
                patientDocID: currentUser.uid,
                patientNID: patientNID,
                isDoctor: isDoctor,
              ),
            ),
          );
        }
      },
    );
  }
}
