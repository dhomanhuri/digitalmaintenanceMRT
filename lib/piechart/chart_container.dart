import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class ChartContainer extends StatelessWidget {
  final Color color;
  final String title;
  final Widget chart;

  const ChartContainer({
    Key? key,
    required this.title,
    required this.color,
    required this.chart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 200,
          padding: EdgeInsets.all(10),
          // decoration: BoxDecoration(
          //   // color: HexColor('#24b273'),
          //   borderRadius: BorderRadius.circular(20),
          //   border: Border.all(
          //     color: Colors.red,
          //     width: 3,
          //   ),
          // ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Expanded(
                  child: Container(
                padding: EdgeInsets.only(top: 10),
                child: chart,
              ))
            ],
          ),
        ),
      ),
    );
  }
}
