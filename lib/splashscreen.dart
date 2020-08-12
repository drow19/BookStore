import 'dart:async';

import 'package:bookapp/login_page.dart';
import 'package:bookapp/main_pages.dart';
import 'package:bookapp/utils/BezierContainer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this._timer();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Column(
          children: <Widget>[
            Container(
              height: height * .4,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Positioned(
                      top: -height * .15,
                      right: -MediaQuery.of(context).size.width * .4,
                      child: BezierContainer()),
                ],
              ),
            ),
            SizedBox(
              height: height * .1,
            ),
            Flexible(child: _title()),
          ],
        ),
      ),
    );
  }

  _timer() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var _duration = const Duration(seconds: 3);
    var id = shared.getInt("id");

    print(id);
    return Timer(_duration, () {
      if (id == null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => LoginPages()));
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainPages()));
      }
    });
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'B',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 50,
            fontWeight: FontWeight.w700,
            color: Color(0xff00897B),
          ),
          children: [
            TextSpan(
              text: 'ook',
              style: TextStyle(color: Colors.black, fontSize: 50),
            ),
            TextSpan(
              text: 'App',
              style: TextStyle(color: Color(0xff039BE5), fontSize: 50),
            ),
          ]),
    );
  }
}
