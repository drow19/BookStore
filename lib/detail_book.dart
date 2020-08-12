import 'dart:math';
import 'package:bookapp/Model/cartmodel.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:bookapp/utils/StarDisplay.dart';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:flutter/material.dart';

class DetailBook extends StatefulWidget {
  final id;
  final title;
  final desc;
  final price;
  final photo;
  final publisher;
  final author;

  DetailBook(
      {this.id,
      this.title,
      this.desc,
      this.price,
      this.photo,
      this.publisher,
      this.author});

  @override
  _DetailBookState createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  var _valueRating = [2, 3, 4, 5];
  var _reader = [23, 30, 39, 48, 40, 99, 100, 88, 236, 77, 19, 88];
  var format = new NumberFormat.currency(
      customPattern: "##,##", decimalDigits: 0, locale: "eu", symbol: "");
  var _category = ["Science", "Biography", "Education", "Technology"];
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(_category[
      Random().nextInt(_category.length)]),
      elevation: 0.5,
    );

    final topLeft = Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Hero(
            tag: widget.title,
            child: Material(
              elevation: 15.0,
              shadowColor: Colors.yellow.shade900,
              child: Image(
                image: NetworkImage(BaseUrl.baseUrl + "/book/image/" + widget.photo),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );

    final topRight = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        text(
          widget.title,
          size: 16.0,
          isBold: true,
          padding: EdgeInsets.only(top: 16.0),
        ),
        text(
          'by $widget.author',
          color: Colors.black54,
          size: 12.0,
          padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
        ),
        Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child: _rating()),
        text(
          "\$" + format.format(widget.price),
          color: Color(0xff7E57C2),
          isBold: true,
          padding: EdgeInsets.only(top: 4.0),
        ),
        SizedBox(height: 26.0),
        GestureDetector(
          onTap: () async {
            await Hive.openBox("cartmodel");
            var cart = Hive.box("cartmodel");


            cart.add(CartModel(
                id: widget.id,
                title: widget.title,
                description: widget.desc,
                prices: widget.price,
                publisher: widget.publisher,
                author: widget.author,
                photo: widget.photo));

            _snackBar(context);
          },
          child: Container(
            height: 40,
            width: 160,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Colors.blue.shade700,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                      blurRadius: 5)
                ],
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.blue),
            child: Center(
                child: Text(
                  "Add To Cart",
                  style: TextStyle(fontSize: 13, color: Colors.white),
                )),
          ),
        )
      ],
    );

    final topContent = Container(
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(flex: 2, child: topLeft),
          Flexible(flex: 3, child: topRight),
        ],
      ),
    );

    final bottomContent = Container(
      height: 300.0,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Text(
          widget.desc,
          style: TextStyle(
            fontSize: 13.0,
            height: 1.5,
          ),
        ),
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: appBar,
      body: Column(
        children: <Widget>[topContent, bottomContent],
      ),
    );
  }

  text(String data,
      {Color color = Colors.black87,
        num size = 14,
        EdgeInsetsGeometry padding = EdgeInsets.zero,
        bool isBold = false}) =>
      Padding(
        padding: padding,
        child: Text(
          data,
          style: TextStyle(
            color: color,
            fontSize: size.toDouble(),
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      );

  Widget _rating() {
    int i = _valueRating[Random().nextInt(_valueRating.length)];
    int r = _reader[Random().nextInt(_reader.length)];
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 0, 4),
      child: Row(
        children: [
          StarDisplayWidget(color: Color(0xffFFD600), value: i),
          SizedBox(
            width: 5,
          ),
          _styleType("$r ratings")
        ],
      ),
    );
  }

  Widget _styleType(String title) {
    TextStyle _style = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black54,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
    );

    return Text(
      title,
      style: _style,
    );
  }

  _snackBar(BuildContext context){
    final snackbar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xffB2EBF2),
        duration: Duration(seconds: 2),
        content: Container(
          child: Text(
            "Added",
            style: TextStyle(
              fontFamily: 'Roboto',
              color: Color(0xff212121),
              fontSize: 16.0,
              fontWeight: FontWeight.w700,
            ),
          ),
        ));
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }
}
