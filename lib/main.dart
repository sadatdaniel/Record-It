import 'package:flutter/material.dart';
import 'Screens/login_page.dart';
import 'Screens/registration_page.dart';
import 'Screens/basic_info.dart';
import 'Screens/success_page.dart';
import 'Screens/doctor_homepage.dart';
import 'Screens/records_page.dart';
import 'Screens/new_record_page.dart';
import 'Screens/success_page_new_record.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  User currentUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  String initPage;

  // @override
  // void initState() {
  //   try {
  //     currentUser = auth.currentUser;
  //     if (currentUser != null) {
  //       initPage = '/search_patient_page';
  //       /*
  //     here id is static variable which declare as a page name.
  //      */
  //     } else {
  //       initPage = '/login';
  //     }
  //   } catch (e) {
  //     print(e);
  //     initPage = '/login';
  //   }
  // }

  @override
  void initState() {
    initPage = '/login';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: initPage,
      routes: {
        // '/': (context) => HomeScreen(),
        '/login': (context) => Login(),
        '/registration': (context) => Registration(),
        '/basic_info': (context) => BasicInfo(),
        '/success_page': (context) => SuccessPage(),
        '/search_patient_page': (context) => SearchPatient(),
        '/records': (context) => Records(),
        '/new_record': (context) => NewRecord(),
        '/success_page_new_record': (context) => SuccessPageNewRecord(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
