import 'package:flutter/material.dart';
import 'package:base/Styles/styles.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SuccessPageNewRecord extends StatefulWidget {
  final String patientDocID;
  final String patientNID;

  const SuccessPageNewRecord({Key key, this.patientDocID, this.patientNID})
      : super(key: key);
  @override
  _SuccessPageNewRecordState createState() => _SuccessPageNewRecordState();
}

class _SuccessPageNewRecordState extends State<SuccessPageNewRecord> {
  final firestoreInstance = FirebaseFirestore.instance;
  var patientDocumentID;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfcfcfc),
      appBar: kappbar('Confirmation'),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: new BoxDecoration(
                  color: Color(0xFF00766c),
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
              'Successfully New Record is Added',
              textAlign: TextAlign.center,
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
                    title: 'Records',
                    //content: 'hello',
                    fontcolor: Colors.white,
                    buttoncolor: Color(0xFF00766c),
                    function: () {
                      // getUID().then(
                      //   (value) {
                      //     print("printinig value");
                      //     print(value);
                      //     print("printinig value finishes here");
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (context) => RecordsOfPatient(
                      //             patientDocID: value,
                      //             isDoctor: true,
                      //             patientNID: widget.patientNID),
                      //       ),
                      //     );
                      //     print(value);
                      //   },
                      // );

                      int count = 0;
                      Navigator.popUntil(context, (route) {
                        return count++ == 2;
                      });
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

  getUID() async {
    var userDocID = await firestoreInstance
        .collection("Users")
        .where('NID', isEqualTo: widget.patientNID)
        .get()
        .then((value) {
      print("correctone");
      print(value.docs.first.id);
      print("correctone finishes here");
      patientDocumentID = value.docs.first.id;
      print(patientDocumentID);
    });
    return patientDocumentID;
  }
}
