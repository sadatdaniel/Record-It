import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/Styles/styles.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'success_page_new_record.dart';

final firestoreInstance = FirebaseFirestore.instance;

class NewRecord extends StatefulWidget {
  final String patientDocID;
  final String patientNID;

  const NewRecord({Key key, this.patientDocID, this.patientNID})
      : super(key: key);
  @override
  _NewRecordState createState() => _NewRecordState();
}

class _NewRecordState extends State<NewRecord> {
  static List<String> symptomsList = [null];
  static List<String> medicationList = [null];

  final notesController = TextEditingController();
  final titleController = TextEditingController();

  int duration = 0;
  String currentDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  DateTime dateUntil;
  int minHeight = 80;

  String returnDateFromDateTime(String dateUntil) {
    return DateFormat("yyyy-MM-dd").format(DateTime.parse(dateUntil));
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController;

  final _formKeyForMed = GlobalKey<FormState>();
  TextEditingController _medController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _medController = TextEditingController();
    print("printing from new_record_page ${widget.patientDocID}");
  }

  @override
  void dispose() {
    _nameController.dispose();
    _medController.dispose();
    super.dispose();
  }

  //////////////////////////////

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFfcfcfc),
      appBar: kappbar('Add New Record'),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Title",
                          style:
                              ktextStyle(FontWeight.w800, 20.0, Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: titleController,
                      enableInteractiveSelection: true,
                      style: ktextStyle(FontWeight.w600, 14.0, Colors.black),

                      maxLines: null,
                      // textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                        hintText: 'Add a title of this record',
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Symptoms",
                          style:
                              ktextStyle(FontWeight.w800, 20.0, Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe6e6e6),
                          border: Border.all(
                            color: Color(0xffe6e6e6),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // name textfield

                              Text(
                                'Add Symptoms',
                                style: ktextStyle(
                                    FontWeight.w800, 14.0, Colors.black),
                              ),
                              ..._getSymps(),
                              SizedBox(
                                height: 40,
                              ),
                              // Center(
                              //   child: RoundedButton(
                              //     function: () {
                              //       if (_formKey.currentState.validate()) {
                              //         _formKey.currentState.save();
                              //       }
                              //       print(symptomsList);
                              //     },
                              //     title: "Save",
                              //     fontcolor: Colors.white,
                              //     buttoncolor: Color(0xFF00766c),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Medications",
                          style:
                              ktextStyle(FontWeight.w800, 20.0, Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xffe6e6e6),
                          border: Border.all(
                            color: Color(0xffe6e6e6),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Form(
                        key: _formKeyForMed,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Medications',
                                style: ktextStyle(
                                    FontWeight.w800, 14.0, Colors.black),
                              ),
                              ..._getMeds(),
                              SizedBox(
                                height: 50,
                              ),
                              // Center(
                              //   child: RoundedButton(
                              //     function: () {
                              //       if (_formKeyForMed.currentState.validate()) {
                              //         _formKeyForMed.currentState.save();
                              //       }
                              //       print(medicationList);
                              //     },
                              //     title: "Save",
                              //     fontcolor: Colors.white,
                              //     buttoncolor: Color(0xFF00766c),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Duration",
                          style:
                              ktextStyle(FontWeight.w800, 20.0, Colors.black),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 0),
                      child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                              color: Color(0xffe6e6e6),
                              border: Border.all(
                                color: Color(0xffe6e6e6),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  duration <= 1
                                      ? duration.toString() + ' Day'
                                      : duration.toString() + ' Days',
                                  style: ktextStyle(
                                      FontWeight.w900, 30.0, Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                Slider(
                                  value: duration.toDouble(),
                                  min: 0,
                                  max: 60.0,
                                  activeColor: Color(0xFF00766c),
                                  onChanged: (double value) {
                                    setState(() {
                                      duration = value.toInt();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  duration == 0
                                      ? ''
                                      : "From $currentDate to " +
                                          returnDateFromDateTime(DateTime.now()
                                              .add(new Duration(days: duration))
                                              .toString()),
                                  style: ktextStyle(
                                      FontWeight.w900, 14.0, Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ))),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Text(
                          "Additional Note",
                          style:
                              ktextStyle(FontWeight.w800, 20.0, Colors.black),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: TextField(
                      controller: notesController,
                      enableInteractiveSelection: true,
                      style: ktextStyle(FontWeight.w600, 14.0, Colors.black),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      // textAlign: TextAlign.center,
                      decoration: new InputDecoration(
                        hintText: 'Add additional note here',
                        border: new OutlineInputBorder(
                          borderRadius: const BorderRadius.all(
                            const Radius.circular(0.0),
                          ),
                          borderSide: new BorderSide(
                            color: Colors.black,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: RoundedButton(
                        title: 'Save',
                        content: 'hello',
                        fontcolor: Colors.white,
                        buttoncolor: Color(0xFF00766c),
                        function: () {
                          var until = returnDateFromDateTime(DateTime.now()
                              .add(new Duration(days: duration))
                              .toString());
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SuccessPageNewRecord(
                                patientDocID: widget.patientDocID,
                              ),
                            ),
                          );
                          setUserData(
                              notesController.text,
                              currentDate,
                              until,
                              symptomsList,
                              medicationList,
                              true,
                              titleController.text);
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // floatingActionButton: RoundedButton(
      //   title: 'Save',
      //   content: 'hello',
      //   fontcolor: Colors.white,
      //   buttoncolor: Color(0xFF00766c),
      //   function: () {
      //     var until = returnDateFromDateTime(
      //         DateTime.now().add(new Duration(days: duration)).toString());
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => SuccessPageNewRecord(
      //           patientDocID: widget.patientDocID,
      //         ),
      //       ),
      //     );
      //     setUserData(notesController.text, currentDate, until, symptomsList,
      //         medicationList, true);
      //   },
      // ),
    );
  }

  List<Widget> _getSymps() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < symptomsList.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: SympTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(i == symptomsList.length - 1, i),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  setUserData(String note, String from, String until, List symptoms,
      List medications, isactive, String title) async {
    var doctorID = FirebaseAuth.instance.currentUser.uid;
    print("Doctor ID: $doctorID");
    print("USER ID: ${widget.patientDocID}");
    var doctorName;
    var hospitalName;

    var currentUser = FirebaseAuth.instance.currentUser;
    await firestoreInstance
        .collection("Users")
        .doc(currentUser.uid)
        .get()
        .then((value) {
      print(value.data());
      setState(() {
        doctorName = value.data()['Full Name'];
        hospitalName = value.data()['Hospital Name'];
      });
    });

    await firestoreInstance
        .collection("Users")
        .doc(widget.patientDocID)
        .collection("Medical Records")
        .add({
      "Hospital Name": hospitalName,
      "Title": title,
      "Additional Note": note,
      "Duration": {"from": from, "until": until},
      "doctorID": doctorID,
      "doctorName": doctorName,
      "Symptoms": symptoms,
      "Medications": medications,
      "isActive": isactive
    });
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          symptomsList.insert(0, null);
        } else
          symptomsList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  List<Widget> _getMeds() {
    List<Widget> medsTextFields = [];
    for (int i = 0; i < medicationList.length; i++) {
      medsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Row(
          children: [
            Expanded(child: MedTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveMedButton(i == medicationList.length - 1, i),
          ],
        ),
      ));
    }
    return medsTextFields;
  }

  /// add / remove button
  Widget _addRemoveMedButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          // add new text-fields at the top of all friends textfields
          medicationList.insert(0, null);
        } else
          medicationList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SympTextFields extends StatefulWidget {
  final int index;
  SympTextFields(this.index);
  @override
  _SympTextFieldsState createState() => _SympTextFieldsState();
}

class _SympTextFieldsState extends State<SympTextFields> {
  TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = _NewRecordState.symptomsList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _nameController,
      onChanged: (v) => _NewRecordState.symptomsList[widget.index] = v,
      decoration: InputDecoration(
        hintText: 'Add new entry',
        hintStyle: ktextStyle(FontWeight.w600, 14.0, Colors.black),
      ),
      validator: (v) {
        if (v.trim().isEmpty) return 'You did not add any entry';
        return null;
      },
    );
  }
}

class MedTextFields extends StatefulWidget {
  final int index;
  MedTextFields(this.index);
  @override
  _MedTextFieldsState createState() => _MedTextFieldsState();
}

class _MedTextFieldsState extends State<MedTextFields> {
  TextEditingController _medController;

  @override
  void initState() {
    super.initState();
    _medController = TextEditingController();
  }

  @override
  void dispose() {
    _medController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _medController.text = _NewRecordState.medicationList[widget.index] ?? '';
    });

    return TextFormField(
      controller: _medController,
      onChanged: (v) => _NewRecordState.medicationList[widget.index] = v,
      decoration: InputDecoration(
        hintText: 'Add new entry',
        hintStyle: ktextStyle(FontWeight.w600, 14.0, Colors.black),
      ),
      validator: (v) {
        if (v.trim().isEmpty) return 'You did not add any entry';
        return null;
      },
    );
  }
}
