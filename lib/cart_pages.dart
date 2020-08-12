import 'dart:async';
import 'package:bookapp/Model/cartmodel.dart';
import 'package:bookapp/Repository/cart_repository.dart';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ChartPages extends StatefulWidget {
  @override
  _ChartPagesState createState() => _ChartPagesState();
}

class _ChartPagesState extends State<ChartPages> {
  var format = new NumberFormat.currency(
      customPattern: "##,##", decimalDigits: 0, locale: "eu", symbol: "");

  int total = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: _titles(),
        automaticallyImplyLeading: false,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xff80deea), Color(0xffb4ffff)]),
      ),
      body: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            new BoxShadow(color: Colors.black38, blurRadius: 2.0)
          ]),
          child: _loadData()),
    );
  }

  Widget _titles() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          text: 'B',
          style: GoogleFonts.portLligatSans(
            textStyle: Theme.of(context).textTheme.display1,
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff00897B),
          ),
          children: [
            TextSpan(
              text: 'ook',
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            TextSpan(
              text: 'App',
              style: TextStyle(color: Color(0xff039BE5), fontSize: 20),
            ),
          ]),
    );
  }

  Widget _loadData() {
    return FutureBuilder(
        future: Hive.openBox("cartmodel"),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              var cart = Hive.box("cartmodel");
              if (cart.isEmpty) {
                return _isEmpty();
              } else {
                return Column(
                  children: [
                    Flexible(
                      child: WatchBoxBuilder(
                          box: cart,
                          builder: (context, cart) {
                            return ListView.builder(
                                itemCount: cart.length,
                                itemBuilder: (ctx, index) {
                                  CartModel _cartModel = cart.getAt(index);
                                  return _listItem(cart, _cartModel, index);
                                });
                          }),
                    ),
                    getTotal(cart)
                  ],
                );
              }
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _isEmpty() {
    return Center(
      child: Container(
        child: Text(
          "Cart is Empty",
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _listItem(Box<dynamic> cartBox, CartModel cart, int index) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [new BoxShadow(color: Colors.black38, blurRadius: 2.0)]),
      child: ListTile(
        leading: Container(
            height: 80,
            width: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: NetworkImage(
                        BaseUrl.baseUrl + "/book/image/" + cart.photo)))),
        title: Text(
          cart.title,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Container(
          margin: EdgeInsets.only(top: 6),
          child: Text("\$" + format.format(cart.prices),
              style: TextStyle(
                fontFamily: 'Roboto',
                color: Color(0xff80deea),
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              )),
        ),
        trailing: Container(
          child: GestureDetector(
              onTap: () {
                if (cartBox.length == 1) {
                  setState(() {
                    cartBox.deleteAt(index);
                  });
                } else {
                  cartBox.deleteAt(index);
                }
              },
              child: Icon(
                Icons.close,
                color: Colors.red,
              )),
        ),
      ),
    );
  }

  Widget getTotal(var data) {
    Map<dynamic, dynamic> raw = data.toMap();
    List list = raw.values.toList();
    CartModel _cartx;
    var _sum = [];

    for (int i = 0; i < raw.length; i++) {
      _cartx = list[i];
      _sum.add(_cartx.prices);
    }
    total = _sum.sumBy((ll) => ll);
    print(total);

    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Total",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )),
            trailing: Text("\$" + format.format(total),
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Color(0xff80deea),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                )),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 30,
              width: 100,
              margin: new EdgeInsets.all(10),
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xff80deea), Color(0xffb4ffff)]),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    new BoxShadow(color: Colors.black38, blurRadius: 2.0)
                  ]),
              child: GestureDetector(
                onTap: () {
                  _showDialog(data);
                },
                child: Center(
                    child: Text(
                  "Buy",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  ),
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(var data) {

    var _value;
    CartRepo().postData(data).then((value) => _value = value);

    showDialog(
      barrierDismissible: false,
        barrierColor: Colors.black54,
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            content: Container(
              height: 80,
                width: 80,
                child: Column(
                  children: [
                    Center(child: CircularProgressIndicator(),),
                    Expanded(child: Center(child: Text("loading", style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),),))
                  ],
                )),
          );
        });

    Timer(Duration(seconds: 5), () {
      setState(() {
        Navigator.of(context, rootNavigator: true).pop();
        if (_value == "1") {
          _snackbar("success");
        } else {
          _snackbar("error");
        }
      });
    });
  }

  Widget _snackbar(String title) {
    final snackbar = SnackBar(
        elevation: 6.0,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Color(0xffB2EBF2),
        duration: Duration(seconds: 2),
        content: Text(
          title,
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xff212121),
            fontSize: 16.0,
            fontWeight: FontWeight.w700,
          ),
        ));
    Scaffold.of(context).showSnackBar(snackbar);
  }
}

extension ListUtils<T> on List<T> {
  //get sum from list prices
  num sumBy(num f(T element)) {
    num sum = 0;
    for (var item in this) {
      sum += f(item);
    }
    return sum;
  }
}
