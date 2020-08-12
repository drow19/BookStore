import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:bookapp/Model/detail_trans_model.dart';
import 'package:bookapp/Repository/detail_repository.dart';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class DetailTrans extends StatefulWidget {
  final id;

  DetailTrans({this.id});

  @override
  _DetailTransState createState() => _DetailTransState();
}

class _DetailTransState extends State<DetailTrans> {
  List<DetailModel> listData = new List<DetailModel>();
  var transId;
  var date;
  String total;

  var format = new NumberFormat.currency(
      customPattern: "#.##", decimalDigits: 0, locale: "eu", symbol: "");

  Future<String> getData() async {
    final response = await DetailRepo().getData(widget.id);
    listData = jsonParse(response);
    var json = jsonDecode(response);
    var data = json['info'];
    transId = data['trans_id'];
    date = data['date'];
    total = data['total'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          automaticallyImplyLeading: true,
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [Color(0xff80deea), Color(0xffb4ffff)]),
        ),
        body: _loadData());
  }

  Widget _loadData() {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("error"),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(child: _data()),
                  _info()
                ],
              );
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _data() {
    return Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: listData.length,
          itemBuilder: (context, index) {
            print(listData[index].title);
            return Container(
              margin: new EdgeInsets.fromLTRB(4, 8, 4, 6),
              padding: new EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    new BoxShadow(color: Colors.black38, blurRadius: 2.0)
                  ]),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        height: 80,
                        width: 70,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(BaseUrl.baseUrl +
                                    "/book/image/" +
                                    listData[index].photo)))),
                    Flexible(
                      child: Container(
                        margin: new EdgeInsets.fromLTRB(6, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              child: Text(
                                listData[index].title,
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w700,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    "\$" +
                                        format.format(listData[index].prices),
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color(0xff7E57C2),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
  
  Widget _info(){
    return Container(
      color: Colors.black26,
      margin: EdgeInsets.fromLTRB(10, 4, 10, 10),
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaction ID",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )),
              Text(transId,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Transaction Date",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )),
              Text(date,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )),
              Text(
                  "\$" +
                      format.format(
                          int.parse(total.replaceAll(',', ""))),
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    color: Color(0xff80deea),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                  )),
            ],
          )
        ],
      ),
    );
  }
}
