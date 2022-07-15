import 'package:flutter/material.dart';
import 'package:mrt/pages/home_page.dart';
import 'package:mrt/pages/login_page.dart';
import 'package:mrt/utils/secure_storage.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
//  const MyApp({ Key? key }) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Widget _defaultHome = LoginPage();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    String _token = await SecureStorage.getToken();
    print('token: ' + _token);
    if (_token.isNotEmpty) _defaultHome = HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MRT Station',
      home: _defaultHome,
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/login': (BuildContext context) => LoginPage()
      },
    );
  }
}
