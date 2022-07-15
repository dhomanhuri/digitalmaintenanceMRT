import 'package:flutter/material.dart';

class ListInputField extends StatelessWidget {
  final String content;
  final control;

  ListInputField({required this.content, required this.control});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 27),
              child: Text(
                "-",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.blue[700], fontSize: 17),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 2, top: 2),
              height: 30,
              width: MediaQuery.of(context).size.width / 2.1,
              color: Colors.white,
              child: TextField(
                controller: control,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5.0),
                  border: OutlineInputBorder(),
                  hintText: "$content",
                  fillColor: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
