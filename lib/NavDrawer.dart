import 'package:flutter/material.dart';
import 'package:mrt/failureexecute.dart';
import 'package:mrt/pdftes.dart';
import 'package:mrt/testsearch.dart';
import 'package:mrt/unit.dart';
import 'package:mrt/preventive.dart';
import 'package:mrt/failureinput.dart';
import 'package:mrt/failureclose.dart';
import 'package:mrt/logout.dart';
import 'package:mrt/pages/home_page.dart';
import 'package:mrt/schedulewo.dart';
import 'package:mrt/historypreventive.dart';
import 'package:mrt/historyfailure.dart';
import 'package:mrt/inputwo.dart';
import 'package:mrt/closewo.dart';
import 'package:mrt/failurelist.dart';
import 'package:mrt/addwo.dart';
import 'package:mrt/manualacc.dart';
import 'package:mrt/material.dart';

class NavDrawer extends StatelessWidget {
  final padding = EdgeInsets.symmetric(horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        // color: HexColor('#2196F3'),
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 10, 5, 2),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      child: Image.asset(
                        'assets/images/Logo MRT.png',
                        // fit: BoxFit.cover,
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  // Image.asset("assets/images/logo.png", width: 500),
                  // InkWell(
                  //   onTap: () async {
                  //     await Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => HomePage(),
                  //       ),
                  //     );
                  //   },
                  //   child: Container(),
                  // ),
                  // Divider(color: Colors.white70),
                  ListTile(
                    leading: Icon(Icons.dashboard_sharp),
                    title: Text(
                      'Dashboard',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                  ),

                  ExpansionTile(
                    leading: Icon(Icons.calendar_today_sharp),
                    title: Text(
                      "Preventive Maintenance",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Schedule WO',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => testsearch()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Input WO',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => inputwo()));
                        },
                      ),
                      // ListTile(
                      //   title: Text(
                      //     'Execute WO',
                      //     style: TextStyle(
                      //         fontSize: 15, fontWeight: FontWeight.bold),
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => preventive()));
                      //   },
                      // ),
                      ListTile(
                        title: Text(
                          'Close WO',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => closewo()));
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.document_scanner),
                    title: Text(
                      "Corrective Maintenance",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      // ListTile(
                      //   title: Text(
                      //     'List Failure',
                      //     style: TextStyle(
                      //         fontSize: 15, fontWeight: FontWeight.bold),
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => failurelist()));
                      //   },
                      // ),
                      ListTile(
                        title: Text(
                          'Input Failure',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => failureinput()));
                        },
                      ),
                      // ListTile(
                      //   title: Text(
                      //     'Execute Failure',
                      //     style: TextStyle(
                      //         fontSize: 15, fontWeight: FontWeight.bold),
                      //   ),
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => failureexecute()));
                      //   },
                      // ),
                      ListTile(
                        title: Text(
                          'Close Failure',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => closefailure()));
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.history),
                    title: Text(
                      "History",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Preventive Maintenance',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => historypreventive()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Corrective Maintenance',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => historyfailure()));
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.print),
                    title: Text(
                      'Manual',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => manualacc()));
                    },
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.print),
                  //   title: Text(
                  //     'tes',
                  //     style: TextStyle(
                  //         fontSize: 18.0, fontWeight: FontWeight.bold),
                  //   ),
                  //   onTap: () {
                  //     Navigator.of(context).push(
                  //         MaterialPageRoute(builder: (context) => pdftes()));
                  //   },
                  // ),
                  ListTile(
                    leading: Icon(Icons.add),
                    title: Text(
                      'Create WO',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => pmchecksheet()));
                    },
                  ),
                  ExpansionTile(
                    leading: Icon(Icons.perm_device_information),
                    title: Text(
                      'Material Information',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Unit',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => unit()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Material',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => material()));
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Logout()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildHeader({
    required String urlImage,
    required String name,
    required String email,
    required VoidCallback onClicked,
  }) =>
      InkWell(
        onTap: onClicked,
        child: Container(
          padding: padding.add(EdgeInsets.symmetric(vertical: 40)),
          child: Row(
            children: [
              CircleAvatar(radius: 30, backgroundImage: NetworkImage(urlImage)),
              SizedBox(width: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}
