import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toolapp/homepage.dart';
import 'package:toolapp/qrcode.dart';
import 'package:toolapp/screen2.dart';
import 'package:toolapp/test.dart';
import 'package:toolapp/testpage.dart';

void main() async {
  // To use Firebase, we have to initialize it first.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int pageIndex = 0;

  static const List<Widget> pages = <Widget>[
    Contacts(),
    QRScanner(),
    Screen2(),
    testpage(),
  ];

  void navigationTapped(int page) {
    setState(() {
      pageIndex = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text('Toolsomethingapp'),

      ),
      body: Center(
        child: pages.elementAt(pageIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(.60),
        selectedFontSize: 20,
        unselectedFontSize: 14,
        type: BottomNavigationBarType.fixed,
          items: [

            BottomNavigationBarItem(

              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: "Home",
            ),


                BottomNavigationBarItem(
              icon: Icon(
                Icons.qr_code,
                color: Colors.white,
              ),
              label: "Scan",
            ),

            BottomNavigationBarItem(
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ),

              label: "Add",

            ),
            BottomNavigationBarItem(

              icon: Icon(
                Icons.gps_fixed,
                color: Colors.white,
              ),
              label: "Test Page",
            ),
          ],
          onTap: navigationTapped,
          currentIndex: pageIndex,

        ),

    );
  }
}
