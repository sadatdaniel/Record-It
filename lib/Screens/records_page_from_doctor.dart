import 'package:flutter/material.dart';
import 'package:base/Styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reports_page_from_doctor.dart';
import 'new_record_page.dart';

class RecordsOfPatient extends StatefulWidget {
  final String patientDocID;
  final bool isDoctor;
  final String patientNID;

  RecordsOfPatient(
      {Key key,
      @required this.patientDocID,
      @required this.isDoctor,
      this.patientNID})
      : super(key: key);
  @override
  _RecordsOfPatientState createState() => _RecordsOfPatientState();
}

class _RecordsOfPatientState extends State<RecordsOfPatient> {
  final firestoreInstance = FirebaseFirestore.instance;
  var currentUser;

  String doctorName = '';
  String docID;

  @override
  void initState() {
    // print("hello from reports_page_from_doctor");
    // print(widget.patientDocID);
    // print("hello ends from reports_page_from_doctor");
    // getDocName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfcfcfc),
      appBar: kappbar('Records'),
      body: Center(
        // heightFactor: 10,
        child: Padding(
          padding: const EdgeInsets.all(10),
          // padding: EdgeInsets.symmetric(horizontal: 40),

          child: StreamBuilder(
            stream: firestoreInstance
                .collection("Users")
                .doc(widget.patientDocID)
                .collection('Medical Records')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  thickness: 0.3,
                  color: Colors.grey,
                ),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      print("$index was pressed");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Reports(
                            snapshot: snapshot,
                            index: index,
                            patientDocID: widget.patientDocID,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        snapshot.data.docs[index].data()['doctorID'].toString(),
                        // doctorName,
                        style: ktextStyle(FontWeight.w700, 16.0, Colors.black),
                      ),
                      subtitle: Text(
                        snapshot.data.docs[index]
                            .data()['Additional Note']
                            .toString(),
                        style: ktextStyle(FontWeight.w600, 12.0, Colors.black),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: widget.isDoctor ? true : false,
        child: RoundedButton(
          title: 'Add New',
          content: 'hello',
          fontcolor: Colors.white,
          buttoncolor: Color(0xFF00766c),
          function: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewRecord(
                  patientDocID: widget.patientDocID,
                  patientNID: widget.patientNID,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Future<bool> _checkIfDocExists() async {
  //   var currentUser = FirebaseAuth.instance.currentUser;
  //   final snapshot = await firestoreInstance
  //       .collection("Users")
  //       .doc(currentUser.uid)
  //       .collection("Medical Records")
  //       .get();

  //   if (snapshot.docs.isEmpty) {
  //     print("No records found");
  //     return false;
  //   } else {
  //     print("Some records are found");
  //     return true;
  //   }
  // }

  // Widget showList() {
  //   var currentUser = FirebaseAuth.instance.currentUser;

  //   return Center(
  //     // heightFactor: 10,
  //     child: Padding(
  //       padding: const EdgeInsets.all(10),
  //       // padding: EdgeInsets.symmetric(horizontal: 40),

  //       child: StreamBuilder(
  //         stream: firestoreInstance
  //             .collection("Users")
  //             .doc(currentUser.uid)
  //             .collection('Medical Records')
  //             .snapshots(),
  //         builder:
  //             (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //           if (!snapshot.hasData) {
  //             return Center(
  //               child: CircularProgressIndicator(),
  //             );
  //           }

  //           return ListView.separated(
  //             separatorBuilder: (context, index) => Divider(
  //               thickness: 0.3,
  //               color: Colors.grey,
  //             ),
  //             itemCount: snapshot.data.docs.length,
  //             itemBuilder: (BuildContext context, int index) {
  //               return GestureDetector(
  //                 onTap: () {
  //                   print("$index was pressed");
  //                 },
  //                 child: ListTile(
  //                   title: Text(
  //                     snapshot.data.docs[index].data()['name'].toString(),
  //                     style: ktextStyle(FontWeight.w700, 16.0, Colors.black),
  //                   ),
  //                   subtitle: Text(
  //                     snapshot.data.docs[index]
  //                         .data()['Additional Notes']
  //                         .toString(),
  //                     style: ktextStyle(FontWeight.w600, 12.0, Colors.black),
  //                   ),
  //                 ),`
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  getDocName() async {
    await firestoreInstance
        .collection('Users')
        .doc(widget.patientDocID)
        .get()
        .then(
      (value) {
        setState(() {
          docID = value.data()['doctorID'];
          print("printing doctor ID from records doctor");
          print(docID);
        });
      },
    );
    await firestoreInstance.collection('Users').doc(docID).get().then(
      (value) {
        setState(() {
          doctorName = value.data()['Full Name'];
          print(doctorName);
          print("trying to print docName");
        });
        // nid = value.data()['NID'];
        // email = value.data()['email'];
      },
    );
  }

  getUID() async {
    var userID = await firestoreInstance
        .collection("Users")
        .where('NID', isEqualTo: widget.patientDocID)
        .get()
        .then((value) {
      print(value.docs.first.id);
      currentUser = value.docs.first.id;
    });
    return userID;
  }
}
