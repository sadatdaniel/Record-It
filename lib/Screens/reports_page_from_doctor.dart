import 'package:base/Screens/new_record_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:base/Styles/styles.dart';

class Reports extends StatefulWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  final int index;
  final String patientDocID;
  Reports({
    Key key,
    @required this.snapshot,
    @required this.index,
    @required this.patientDocID,
  }) : super(key: key);
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  String bloodGroup = '';
  String fullName = '';
  String dob = '';
  String nid = '';
  String email = '';
  String docName = '';
  String docID = '';
  String status = '';
  List medications = [];
  List symptoms = [];
  String hospitalName = '';
  String title = '';
  String doubleCheckDocName;

  @override
  void initState() {
    getPatientDetails();
    var value = widget.snapshot.data.docs[widget.index];
    setState(() {
      //status = value.data()['isActive'];
      title = value.data()['Title'];
      doubleCheckDocName = value.data()['doctorName'];
      hospitalName = value.data()['Hospital Name'];
      medications = List.from(value.data()['Medications']);
      symptoms = List.from(value.data()['Symptoms']);
      // print("printing experimental values");
      // print(docName);
      // print(title);
      // print(hospitalName);
      // print("printing experimental values exit");
      // print(doubleCheckDocName);
      // print("printing double values exit");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFfcfcfc),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Color(0xFFfcfcfc),
        title: Text(
          // "Record ${widget.index}",
          title,
          style: TextStyle(
              fontFamily: 'Spartan',
              fontWeight: FontWeight.w900,
              color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: () {
                print("hello");
              },
              child: Icon(
                Icons.share,
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text("Record Details",
                textAlign: TextAlign.left,
                style: ktextStyle(FontWeight.w600, 20.0, Colors.black)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.all(15.0),
              width: double.infinity,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color(0xffe6e6e6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Prescribed by: $docName',
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'Hospital Name: $hospitalName',
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "From: ${widget.snapshot.data.docs[widget.index].data()['Duration']['from'].toString()} to ${widget.snapshot.data.docs[widget.index].data()['Duration']['until'].toString()}",
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    widget.snapshot.data.docs[widget.index].data()['isActive']
                        ? "Status: Active"
                        : "Status: Not Active",
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.teal),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text("Patient Details",
                textAlign: TextAlign.left,
                style: ktextStyle(FontWeight.w600, 20.0, Colors.black)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.all(15.0),
              width: double.infinity,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color(0xffe6e6e6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name : $fullName',
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Email: $email",
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Date of Birth: $dob",
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "National ID Number: $nid",
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    "Blood Group: $bloodGroup",
                    style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text("Symptoms",
                textAlign: TextAlign.left,
                style: ktextStyle(FontWeight.w600, 20.0, Colors.black)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: new Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Color(0xffe6e6e6),
                ),
                child: _listToText(symptoms)
                // children: [_listToText(medications)],
                ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text("Medications",
                textAlign: TextAlign.left,
                style: ktextStyle(FontWeight.w600, 20.0, Colors.black)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: new Container(
                alignment: Alignment.centerLeft,
                padding: new EdgeInsets.all(15.0),
                width: double.infinity,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  color: Color(0xffe6e6e6),
                ),
                child: _listToText(medications)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 30.0),
            child: Text("Additional Notes",
                textAlign: TextAlign.left,
                style: ktextStyle(FontWeight.w600, 20.0, Colors.black)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
            child: new Container(
              alignment: Alignment.centerLeft,
              padding: new EdgeInsets.all(15.0),
              width: double.infinity,
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                color: Color(0xffe6e6e6),
              ),
              child: Text(
                widget.snapshot.data.docs[widget.index]
                    .data()['Additional Note']
                    .toString(),
                style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _listToText(List items) {
    List<Widget> list = new List<Widget>();
    for (var i = 0; i < items.length; i++) {
      list.add(
        new Text(
          "• " + items[i],
          style: ktextStyle(FontWeight.w800, 14.0, Colors.black),
        ),
      );
    }
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start, children: list);
  }

//widget.snapshot.data.docs[widget.index].data()['Duration']['from'].toString()

  getPatientDetails() async {
    docID =
        widget.snapshot.data.docs[widget.index].data()['doctorID'].toString();

    await firestoreInstance
        .collection('Users')
        .doc(widget.patientDocID)
        .get()
        .then(
      (value) {
        setState(() {
          fullName = value.data()['Full Name'];
          bloodGroup = value.data()['Blood Group'];
          dob = value.data()['DOB'];
          nid = value.data()['NID'];
          email = value.data()['email'];
          // status = value.data()['isActive'];
          medications = List.from(
              widget.snapshot.data.docs[widget.index].data()['Medications']);
          symptoms = List.from(
              widget.snapshot.data.docs[widget.index].data()['Symptoms']);
        });
      },
    );
    await firestoreInstance.collection('Users').doc(docID).get().then(
      (value) {
        setState(() {
          docName = value.data()['Full Name'];
          print(docName);
          print("trying to print docName");
        });
        // nid = value.data()['NID'];
        // email = value.data()['email'];
      },
    );
  }
}
