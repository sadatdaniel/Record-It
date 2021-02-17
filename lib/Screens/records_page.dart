import 'package:flutter/material.dart';
import 'package:base/Styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'reports_page_from_doctor.dart';

class Records extends StatefulWidget {
  final String patientDocID;
  final String patientNID;
  final bool isDoctor;

  Records(
      {Key key,
      @required this.patientDocID,
      @required this.patientNID,
      @required this.isDoctor})
      : super(key: key);
  @override
  _RecordsState createState() => _RecordsState();
}

class _RecordsState extends State<Records> {
  final firestoreInstance = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  // bool docExists;
  @override
  void initState() {
    print(widget.patientNID);
    print(widget.isDoctor);
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
                .doc(currentUser.uid)
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
                        // isThreeLine: true,
                        title: Text(
                          snapshot.data.docs[index].data()['Title'].toString(),
                          style:
                              ktextStyle(FontWeight.w700, 16.0, Colors.black),
                        ),
                        subtitle: getSubtitle(snapshot, index)),
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
          function: () {
            Navigator.pushNamed(context, '/new_record');
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
  //                 ),
  //               );
  //             },
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  // Widget showFist() {
  //   return Center(
  //     child: Text("No Records Found"),
  //   );
  // }

  Text getSubtitle(snapshot, int index) {
    String from =
        snapshot.data.docs[index].data()['Duration']['from'].toString();
    String until =
        snapshot.data.docs[index].data()['Duration']['until'].toString();

    // isDateGone(until);

    if (isDateGone(until)) {
      return Text(
        "$from to $until".toString(),
        style: ktextStyle(FontWeight.w800, 12.0, Colors.red),
      );
    } else {
      return Text(
        "$from to $until".toString(),
        style: ktextStyle(FontWeight.w800, 12.0, Colors.green),
      );
    }
  }

  isDateGone(String date) {
    var now = DateTime.now();
    var until = DateTime.parse(date);

    if (until.compareTo(now) > 0) {
      return false;
    } else {
      return true;
    }
  }
}
