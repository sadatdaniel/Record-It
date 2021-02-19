import 'package:flutter/material.dart';

// final kappbar = AppBar(
//         elevation: 0,
//         backgroundColor: Color(0xFFfcfcfc),
//         title: Text(
//           "Settings",
//           style: TextStyle(
//               fontFamily: 'Spartan',
//               fontWeight: FontWeight.w900,
//               color: Colors.black),
//         ),
//       );

kappbar(String title) {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Color(0xFFfcfcfc),
    title: Text(
      title,
      style: TextStyle(
          fontFamily: 'Spartan',
          fontWeight: FontWeight.w900,
          color: Colors.black),
    ),
  );
}

kdecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.black,
      fontFamily: 'Spartan',
      fontWeight: FontWeight.w800,
      fontSize: 14,
    ),
    contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
    filled: true,
    fillColor: Color(0xffe6e6e6),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffe6e6e6), width: 1.0),
      // borderRadius: BorderRadius.all(Radius.circular(5.0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color(0xffe6e6e6), width: 2.0),
      // borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
  );
}

Color kGreenButtonColor = Color(0xFFd35f5f);
Color kRedButtonColor = Color(0xFFd35f5f);
Color kDefaultButtonColor = Color(0xFFd35f5f);

ktextStyle(FontWeight weight, size, color) {
  return TextStyle(
    color: color,
    fontFamily: 'Spartan',
    fontWeight: weight,
    fontSize: size,
  );
}

kwelcomescreentextStyle(FontWeight weight, size, color) {
  return TextStyle(
    color: color,
    // fontFamily: 'Merriweather',
    fontFamily: 'Merriweather',
    fontWeight: weight,
    fontSize: size,
  );
}

class RoundedButton extends StatelessWidget {
  final String title;
  final Function function;
  final String content;
  final Color fontcolor;
  final Color buttoncolor;

  RoundedButton(
      {this.title,
      this.function,
      this.content,
      this.fontcolor,
      this.buttoncolor});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 150,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(5),
          backgroundColor: MaterialStateProperty.all<Color>(buttoncolor),
        ),
        onPressed: () {
          function();
        },
        child: Text(
          title,
          style: ktextStyle(FontWeight.w900, 20.0, fontcolor),
        ),
      ),
    );
  }
}
