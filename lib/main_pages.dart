import 'package:bookapp/cart_pages.dart';
import 'package:bookapp/list_book_pages.dart';
import 'package:bookapp/profile_pages.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPages extends StatefulWidget {

  @override
  _MainPagesState createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages> {
  int _currentIndex = 0;
  var nnn;

  final List<Widget> pages = [
    new ListBook(),
    new ChartPages(),
    new ProfilePages()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        child: pages[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          elevation: 5,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            new BottomNavigationBarItem(
                icon: Image.asset(
                  "assets/ic_book.png",
                  height: 20,
                  width: 20,
                  color: Color(0xff80deea),
                ),
                title: Text('Home',
                    style: GoogleFonts.portLligatSans(
                      textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff00897B),
                    ))),
            new BottomNavigationBarItem(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Color(0xff80deea),
                ),
                title: Text('Cart',
                    style: GoogleFonts.portLligatSans(
                      textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff00897B),
                    ))),
            new BottomNavigationBarItem(
                icon: SizedBox(
                    height: 25,
                    width: 25,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/profile.jpg"),
                    )),
                title: Text('Profile',
                    style: GoogleFonts.portLligatSans(
                      textStyle: Theme.of(context).textTheme.display1,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff00897B),
                    ))),
          ]),
    );
  }


}
