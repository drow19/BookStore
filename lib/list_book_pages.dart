import 'dart:math';
import 'package:bookapp/Model/book_model.dart';
import 'package:bookapp/Model/cartmodel.dart';
import 'package:bookapp/Repository/book_repository.dart';
import 'package:bookapp/detail_book.dart';
import 'package:bookapp/history_page.dart';
import 'package:bookapp/utils/StarDisplay.dart';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';

class ListBook extends StatefulWidget {
  @override
  _ListBookState createState() => _ListBookState();
}

class _ListBookState extends State<ListBook> {
  List<BookModel> listData = new List<BookModel>();
  var format = new NumberFormat.currency(
      customPattern: "##,##", decimalDigits: 0, locale: "eu", symbol: "");
  var _valueRating = [2, 3, 4, 5];
  var _category = ["Science", "Biography", "Education", "Technology"];
  final TextEditingController _controller = new TextEditingController();

  Future<String> getData(String search) async {
    listData = await BookRepository().getData(search, "1");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: _titles(),
        actions: [
          IconButton(
              icon: Icon(
                Icons.note_add,
                color: Color(0xff039BE5),
              ),
              onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => HistoryPages())))
        ],
        automaticallyImplyLeading: false,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [Color(0xff80deea), Color(0xffb4ffff)]),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Column(
          children: [_search(), Flexible(child: _loadData(_controller.text))],
        ),
      ),
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

  Widget _search() {
    return Container(
      margin: const EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: new EdgeInsets.only(left: 8, right: 8),
            child: new TextField(
              controller: _controller,
              onSubmitted: (_controller) {
                setState(() {});
              },
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: _controller.text == ""
                      ? null
                      : IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            setState(() {
                              FocusScope.of(context).requestFocus(FocusNode());
                              _controller.clear();
                              _loadData("");
                            });
                          }),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  hintText: 'Book Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0))),
            ),
          )
        ],
      ),
    );
  }

  Widget _loadData(String search) {
    print(search + _controller.text);
    return FutureBuilder(
        future: getData(search),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Connection Error",
                  style: GoogleFonts.portLligatSans(
                    textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff00897B),
                  )),
            );
          } else {
            return Container(
              margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: listData.length,
                  itemBuilder: (context, index) {
                    return _data(listData[index]);
                  }),
            );
          }
        });
  }

  Widget _data(BookModel book) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailBook(
                      id: book.id,
                      title: book.title,
                      desc: book.description,
                      photo: book.photo,
                      price: book.prices,
                      author: book.author,
                      publisher: book.publisher,
                    )));
      },
      child: Container(
        margin: new EdgeInsets.fromLTRB(4, 8, 4, 6),
        padding: new EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [new BoxShadow(color: Colors.black38, blurRadius: 2.0)]),
        child: Container(
          child: Row(
            children: [
              Container(
                  height: 130,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              BaseUrl.baseUrl + "/book/image/" + book.photo)))),
              Flexible(
                child: Container(
                  margin: new EdgeInsets.fromLTRB(6, 0, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          book.title,
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
                      SizedBox(
                        height: 2,
                      ),
                      Container(
                        width: 200,
                        child: Text(
                          book.description,
                          style: TextStyle(
                            fontFamily: 'Spectral',
                            color: Colors.black,
                            fontSize: 13.0,
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        children: [
                          Container(
                            width: 70,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Color(0xffC5CAE9),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text(_category[
                                    Random().nextInt(_valueRating.length)])),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 70,
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                                color: Color(0xffC5CAE9),
                                borderRadius: BorderRadius.circular(8)),
                            child: Center(
                                child: Text(_category[
                                    Random().nextInt(_valueRating.length)])),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      StarDisplayWidget(
                          color: Color(0xffFFD600),
                          value: _valueRating[
                              Random().nextInt(_valueRating.length)]),
                      SizedBox(
                        height: 6,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("\$" + format.format(book.prices),
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                color: Color(0xff7E57C2),
                                fontSize: 16.0,
                                fontWeight: FontWeight.w700,
                              )),
                          GestureDetector(
                            onTap: () async {
                              await Hive.openBox("cartmodel");
                              var cart = Hive.box("cartmodel");

                              cart.add(CartModel(
                                  id: book.id,
                                  title: book.title,
                                  description: book.description,
                                  prices: book.prices,
                                  publisher: book.publisher,
                                  author: book.author,
                                  photo: book.photo));

                              List<CartModel> li = List<CartModel>();
                              li.add(CartModel(
                                  id: book.id,
                                  title: book.title,
                                  description: book.description,
                                  prices: book.prices,
                                  publisher: book.publisher,
                                  author: book.author,
                                  photo: book.photo));

                              print(cart.length);

                              /*int sum = li
                                  .map((expense) => expense.prices)
                                  .fold(0, (prev, amount) => prev + amount);*/

                              final snackbar = SnackBar(
                                  elevation: 6.0,
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Color(0xffB2EBF2),
                                  duration: Duration(seconds: 2),
                                  content: Text(
                                    "Added",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      color: Color(0xff212121),
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ));
                              Scaffold.of(context).showSnackBar(snackbar);
                            },
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                  color: Color(0xff80deea),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "Add To Cart",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
