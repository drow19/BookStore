import 'package:bookapp/Model/history_model.dart';
import 'package:bookapp/Repository/history_repository.dart';
import 'package:bookapp/detail_transaction.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';

class HistoryPages extends StatefulWidget {
  @override
  _HistoryPagesState createState() => _HistoryPagesState();
}

class _HistoryPagesState extends State<HistoryPages> {
  List<HistoryModel> listdata = new List<HistoryModel>();

  var format = new NumberFormat.currency(
      customPattern: "##,##", decimalDigits: 0, locale: "eu", symbol: "");

  Future<String> getData() async {
    listdata = await HistoryRepo().getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("History Transaction"),
        automaticallyImplyLeading: true,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xff80deea), Color(0xffb4ffff)]),
      ),
      body: _loadData(),
    );
  }

  Widget _loadData() {
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              print("error : " + snapshot.error.toString());
              return _isEmpty("Error");
            } else {
              return _data();
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
        child: ListView.separated(
            separatorBuilder: (ctx, i) {
              return Divider();
            },
            itemCount: listdata.length,
            itemBuilder: (context, index) {
              var x = listdata[index].total.replaceAll(',', "");
              return GestureDetector(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => DetailTrans(
                          id: listdata[index].transId,
                        ))),
                child: Container(
                  margin: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(listdata[index].transId.toString()),
                      Text("\$" + format.format(int.parse(x)),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: Color(0xff7E57C2),
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                          )),
                      Text(listdata[index].date),
                    ],
                  ),
                ),
              );
            }));
  }

  Widget _isEmpty(String title) {
    return Center(
      child: Container(
        child: Text(
          title,
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
}
