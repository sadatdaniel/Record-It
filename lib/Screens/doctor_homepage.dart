import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/Styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'records_page.dart';
import 'records_page_from_doctor.dart';

class SearchPatient extends StatefulWidget {
  @override
  _SearchPatientState createState() => _SearchPatientState();
}

class _SearchPatientState extends State<SearchPatient> {
  final firestoreInstance = FirebaseFirestore.instance;
  var patientDocumentID;
  final nidController = TextEditingController();

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to go back to the login page?'),
            actions: <Widget>[
              new GestureDetector(
                  onTap: () => Navigator.of(context).pop(false),
                  child: RoundedButton(
                    title: "NO",
                    buttoncolor: Color(0xFFd35f5f),
                    function: () {
                      Navigator.of(context).pop(false);
                    },
                  )),
              SizedBox(height: 16),
              new GestureDetector(
                //onTap: () => Navigator.of(context).pop(true),

                child: RoundedButton(
                  title: "YES",
                  buttoncolor: Color(0xFFd35f5f),
                  function: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/login');
                  },
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xFFfcfcfc),
        appBar: kappbar('Search Patient'),
        body: Center(
          // heightFactor: 10,
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 40.0, right: 40.0, top: 150, bottom: 0),
                // padding: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                    keyboardType: TextInputType.number,
                    style: ktextStyle(FontWeight.w600, 16.0, Colors.black),
                    controller: nidController,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ], // Only numbers
                    decoration: kdecoration('Type National ID Number Here')),
              ),
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: RoundedButton(
                  title: 'Search',
                  fontcolor: Colors.white,
                  buttoncolor: Color(0xFFd35f5f),
                  function: () {
                    getUID().then((value) {
                      print("printinig value");
                      print(value);
                      print("printinig value finishes here");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecordsOfPatient(
                              patientDocID: patientDocumentID,
                              isDoctor: true,
                              patientNID: nidController.text),
                        ),
                      );
                      print(value);
                    });

                    print(nidController.text);
                  },
                ),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.bottomLeft,
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RoundedButton(
                      buttoncolor: Color(0xFFd35f5f),
                      title: "Log Out",
                      function: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushNamed(context, '/login');
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  getUID() async {
    var userDocID = await firestoreInstance
        .collection("Users")
        .where('NID', isEqualTo: nidController.text)
        .get()
        .then((value) {
      // print("correctone");
      // print(value.docs.first.id);
      // print("correctone finishes here");
      patientDocumentID = value.docs.first.id;
      // print(patientDocumentID);
    });
    return patientDocumentID;
  }
}
