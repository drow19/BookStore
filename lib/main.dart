import 'package:bookapp/Model/cartmodel.dart';
import 'package:bookapp/login_page.dart';
import 'package:bookapp/main_pages.dart';
import 'package:bookapp/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:hive/hive.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  var appDocument = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocument.path);
  Hive.registerAdapter(CartModelAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
