import 'dart:async';

import 'package:bookapp/main_pages.dart';
import 'package:bookapp/Repository/login_repository.dart';
import 'package:bookapp/register_page.dart';
import 'package:bookapp/utils/BezierContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPages extends StatefulWidget {
  @override
  _LoginPagesState createState() => _LoginPagesState();
}

class _LoginPagesState extends State<LoginPages> {
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Future<String> GetData(String a, String b) async {
    await LoginRepository().getData(a, b);
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: BezierContainer()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      SizedBox(height: 50),
                      _emailPasswordWidget(),
                      SizedBox(height: 20),
                      _submitButton(),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=> Register())),
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text('Register Account',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _username(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: userController,
              obscureText: isPassword,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              controller: passwordController,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showDialog();
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff039BE5), Color(0xff00897B)])),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'B',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 30,
            fontWeight: FontWeight.w700,
            color: Color(0xff00897B),
          ),
          children: [
            TextSpan(
              text: 'ook',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'App',
              style: TextStyle(color: Color(0xff039BE5), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _username("Email id"),
        _entryField("Password", isPassword: true),
      ],
    );
  }

  _showDialog() {
    var _value;

    LoginRepository()
        .getData(userController.text, passwordController.text)
        .then((value) => _value = value);

    showDialog(
        barrierDismissible: false,
        barrierColor: Colors.black54,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            elevation: 6,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            content: Container(
                height: 80,
                width: 80,
                child: Column(
                  children: [
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        "loading",
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.black,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ))
                  ],
                )),
          );
        });

    Timer(Duration(seconds: 3), () {
      setState(() {
        Navigator.of(context, rootNavigator: true).pop();
        if (_value == "1") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MainPages()));
        } else {
          _snackbar("Wrong username or Password");
        }
      });
    });
  }

  Widget _snackbar(String title) {
    final snackbar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.fixed,
        backgroundColor: Color(0xffB2EBF2),
        duration: Duration(seconds: 2),
        content: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xff212121),
            fontSize: 14.0,
            fontWeight: FontWeight.w700,
          ),
        ));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
