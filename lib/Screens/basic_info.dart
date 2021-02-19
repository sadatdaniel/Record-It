import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base/Styles/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BasicInfo extends StatefulWidget {
  final String userEmail;
  final String userPassword;

  BasicInfo({Key key, @required this.userEmail, @required this.userPassword})
      : super(key: key);
  @override
  _BasicInfoState createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  bool isDoctor;
  final regFullNameController = TextEditingController();
  final regNIDController = TextEditingController();

  final hospitalCodeController = TextEditingController();

  List<String> _genders = ['Male', 'Female']; // Option 2
  String _selectedGender;

  List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ]; // Option 2
  String _selectedbloodGroup;

  List<String> _userTypes = [
    'Doctor',
    'Patient',
  ]; // Option 2
  String _selectedUser;

  String userName;
  int nID;

  int hospitalCode;
  var hospitalName = '';

  DateTime selectedDate = DateTime.now();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1950, 1),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.teal,
            ),
          ),
          child: child,
        );
      },
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  void getHospitalInfo(int code) async {
    var documentid;

    await firestoreInstance
        .collection("Hospitals")
        .where('Codes', arrayContains: code)
        .get()
        .then(
      (value) {
        print("checking if can get hospital info");
        print(value.docs.first.id);
        documentid = value.docs.first.id;
      },
    );

    await firestoreInstance.collection("Hospitals").doc(documentid).get().then(
      (value) {
        print(
          value.data(),
        );
        setState(() {
          hospitalName = value.data()['Hospital Name'];
          print(hospitalName);
        });
      },
    );
  }

  final firestoreInstance = FirebaseFirestore.instance;
  static String userID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    "Basic Info",
                    style: ktextStyle(FontWeight.w800, 20.0, Colors.black),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20),
            Padding(
              //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                  keyboardType: TextInputType.name,
                  style: ktextStyle(FontWeight.w600, 16.0, Colors.black),
                  controller: regFullNameController,
                  decoration: kdecoration('Your Full Name')),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              //padding: EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                  style: ktextStyle(FontWeight.w600, 16.0, Colors.black),
                  controller: regNIDController,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ], // Only numbers
                  keyboardType: TextInputType.number,
                  decoration: kdecoration('National ID Number')),
            ),
            SizedBox(
              height: 10,
            ),

            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xffe6e6e6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            //Responsible for dropdownmenu box color
                            color: Color(0xffe6e6e6),
                            border: Border.all(
                              color: Color(0xffe6e6e6),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              // fillColor: Colors.green,
                              hintText: 'Select Gender',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(5.0)),
                              // ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  'Gender',
                                  style: ktextStyle(
                                      FontWeight.w800, 14.0, Colors.black),
                                ), // Not necessary for Option 1
                                value: _selectedGender,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedGender = newValue;
                                    print(_selectedGender);
                                  });
                                },
                                items: _genders.map((gender) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      gender,
                                      style: ktextStyle(
                                          FontWeight.w800, 12.0, Colors.black),
                                    ),
                                    value: gender,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    // Expanded(
                    //   flex: 2,
                    //   child: Container(
                    //       decoration: BoxDecoration(
                    //           color: Color(0xffe6e6e6),
                    //           border: Border.all(),
                    //           borderRadius:
                    //               BorderRadius.all(Radius.circular(3))),
                    //       height: 47,
                    //       child: Align(
                    //         alignment: Alignment.centerLeft,
                    //         child: Padding(
                    //           padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //           child: Text(
                    //             "Select Birthday",
                    //             style: ktextStyle(
                    //                 FontWeight.w800, 12.0, Colors.black),
                    //           ),
                    //         ),
                    //       )),
                    // ),
                    // SizedBox(
                    //   width: 10,
                    // ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 47,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xffe6e6e6)),
                            ),
                            onPressed: () => _selectDate(context),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                      selectedDate == null
                                          ? "Select Birth Date"
                                          : "${selectedDate.toLocal()}"
                                              .split(' ')[0],
                                      style: ktextStyle(
                                          FontWeight.w800, 12.0, Colors.black)),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: Colors.black,
                                    size: 20.0,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xffe6e6e6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      // flex: 4,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            //Responsible for dropdownmenu box color
                            color: Color(0xffe6e6e6),
                            border: Border.all(
                              color: Color(0xffe6e6e6),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              // fillColor: Colors.green,
                              hintText: 'Select Blood Group',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(5.0)),
                              // ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  'Select Blood Group',
                                  style: ktextStyle(
                                      FontWeight.w800, 14.0, Colors.black),
                                ), // Not necessary for Option 1
                                value: _selectedbloodGroup,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedbloodGroup = newValue;
                                    print(_selectedbloodGroup);
                                  });
                                },
                                items: _bloodGroups.map((bloodGroup) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      bloodGroup,
                                      style: ktextStyle(
                                          FontWeight.w800, 12.0, Colors.black),
                                    ),
                                    value: bloodGroup,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 15, 0, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  child: Text(
                    "Create Account As",
                    style: ktextStyle(FontWeight.w800, 20.0, Colors.black),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Theme(
              data: Theme.of(context).copyWith(
                canvasColor: Color(0xffe6e6e6),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            //Responsible for dropdownmenu box color
                            color: Color(0xffe6e6e6),
                            border: Border.all(
                              color: Color(0xffe6e6e6),
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              enabledBorder: InputBorder.none,
                              // fillColor: Colors.green,
                              hintText: 'Select Account Type',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Spartan',
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                              // border: OutlineInputBorder(
                              //   borderRadius:
                              //       BorderRadius.all(Radius.circular(5.0)),
                              // ),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                hint: Text(
                                  'Select Account Type',
                                  style: ktextStyle(
                                      FontWeight.w800, 14.0, Colors.black),
                                ), // Not necessary for Option 1
                                value: _selectedUser,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedUser = newValue;
                                    print(_selectedUser);
                                    // addHospitalVarificationColumn();
                                  });
                                },
                                items: _userTypes.map((userType) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      userType,
                                      style: ktextStyle(
                                          FontWeight.w800, 14.0, Colors.black),
                                    ),
                                    value: userType,
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            if (_selectedUser == 'Doctor')
              Row(
                children: [
                  // Expanded(
                  //   flex: 2,
                  //   child: Padding(
                  //     // padding: const EdgeInsets.symmetric(horizontal: 40),
                  //     //padding: EdgeInsets.symmetric(horizontal: 15),
                  //     padding: EdgeInsets.only(left: 40),
                  //     child: Text(
                  //       "Hospital Code",
                  //       style: ktextStyle(FontWeight.w800, 16.0, Colors.black),
                  //     ),
                  //   ),
                  // ),
                  Align(
                    alignment: FractionalOffset.centerRight,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        //padding: EdgeInsets.symmetric(horizontal: 15),
                        child: TextField(
                            style:
                                ktextStyle(FontWeight.w600, 16.0, Colors.black),

                            // controller: regPasswordController1,
                            controller: hospitalCodeController,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ], // Only numbers
                            keyboardType: TextInputType.number,
                            decoration: kdecoration('Give Hospital Code')),
                      ),
                    ),
                  )
                ],
              ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Align(
                  alignment: FractionalOffset.bottomRight,
                  child: RoundedButton(
                    title: 'Next',
                    content: 'd',
                    fontcolor: Colors.white,
                    buttoncolor: Color(0xFFd35f5f),
                    function: () async {
                      if (hospitalCodeController.text.isEmpty) {
                        hospitalCode = 0;
                      } else {
                        hospitalCode = int.parse(hospitalCodeController.text);
                      }
                      await getHospitalInfo(hospitalCode);
                      // print(widget.userEmail);
                      // print(widget.userPassword);
                      // print(regFullNameController.text);
                      // print(regNIDController.text);
                      // print(_selectedUser);
                      // print(_selectedbloodGroup);
                      var dOB = "${selectedDate.toLocal()}".split(' ')[0];
                      // print(dOB);

                      if (_selectedUser == 'Doctor') {
                        isDoctor = true;
                      } else {
                        isDoctor = false;
                      }

                      try {
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: widget.userEmail,
                                password: widget.userPassword)
                            .then((value) {
                          var currentUser = FirebaseAuth.instance.currentUser;
                          firestoreInstance
                              .collection("Users")
                              .doc(currentUser.uid)
                              .set({
                            "email": widget.userEmail,
                            "Blood Group": _selectedbloodGroup,
                            "DOB": dOB,
                            "Full Name": regFullNameController.text,
                            "NID": regNIDController.text,
                            "isDoctor": isDoctor,
                            "Hospital Name": hospitalName
                          }).then((value) {
                            //docmunet ID will be uid
                            print(userID);
                            Navigator.pushNamed(context, '/success_page');
                          });
                        });
                      } catch (e) {
                        print("Could not get connection");
                      }

                      // Navigator.pushNamed(context, '/success_page');
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
}
