import 'package:flutter/material.dart';
import 'package:base/Styles/styles.dart';
import 'login_page.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Login()), (route) => false);
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Color(0xFFfcfcfc),
        appBar: kappbar('Register'),
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Container(
                  width: 200.0,
                  height: 200.0,
                  decoration: new BoxDecoration(
                    color: Color(0xFFd35f5f),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.done_rounded,
                    size: 150,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                'Account Creation was Successful',
                style: ktextStyle(FontWeight.w900, 20.0, Colors.black),
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Align(
                    alignment: FractionalOffset.bottomRight,
                    child: RoundedButton(
                      title: 'Login',
                      //content: 'hello',
                      fontcolor: Colors.white,
                      buttoncolor: Color(0xFFd35f5f),
                      function: () {
                        Navigator.pushNamed(context, '/login');
                      },
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
}
