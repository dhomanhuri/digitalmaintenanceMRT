import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

class InputField extends StatelessWidget {
  final String label;
  final String content;
  final type;
  final control;

  InputField(
      {required this.label,
      required this.content,
      required this.type,
      required this.control});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width / 2.3,
              child: Text(
                "$label",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.blue[700], fontSize: 17),
              ),
            ),
            SizedBox(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  ':',
                  style: TextStyle(color: Colors.blue[700], fontSize: 17),
                ),
              ),
              width: 30.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 5, bottom: 2, top: 2),
              height: 30,
              width: MediaQuery.of(context).size.width / 2.6,
              color: Colors.white,
              child: TextField(
                keyboardType: type,
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

// class InputFieldTime extends StatefulWidget {
//   final String label;

//   InputFieldTime({required this.label});

//   @override
//   State<InputFieldTime> createState() => _InputFieldTimeState();
// }

// class _InputFieldTimeState extends State<InputFieldTime> {
//   DateTime? selectedDate;
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (BuildContext context, BoxConstraints constraints) {
//         return Row(
//           children: <Widget>[
//             Container(
//               width: MediaQuery.of(context).size.width / 2.3,
//               child: Text(
//                 "${widget.label}",
//                 textAlign: TextAlign.left,
//                 style: TextStyle(color: Colors.blue[700], fontSize: 17),
//               ),
//             ),
//             SizedBox(
//               child: Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   ':',
//                   style: TextStyle(color: Colors.blue[700], fontSize: 17),
//                 ),
//               ),
//               width: 30.0,
//             ),
//             Container(
//               margin: EdgeInsets.only(left: 5, bottom: 2, top: 2),
//               height: 30,
//               width: MediaQuery.of(context).size.width / 2.6,
//               color: Colors.white,
//               alignment: Alignment.center,
//               child: DateTimeField(
//                   use24hFormat: true,
//                   dateTextStyle: TextStyle(fontSize: 16),
//                   decoration: const InputDecoration(
//                     hintText: "Tanggal",
//                     contentPadding: EdgeInsets.all(5),
//                     border: OutlineInputBorder(),
//                     fillColor: Colors.white,
//                   ),
//                   selectedDate: selectedDate,
//                   onDateSelected: (DateTime value) {
//                     setState(() {
//                       selectedDate = value;
//                     });
//                   }),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

class InputTime extends StatefulWidget {
  final String label;
  final control;

  InputTime({required this.label, this.control});

  @override
  State<InputTime> createState() => _InputTimeState();
}

class _InputTimeState extends State<InputTime> {
  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);
  void _selectTime() async {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2025));
    // final TimeOfDay? newTime = await showTimePicker(
    //   context: context,
    //   initialTime: _time,
    // );
    // if (newTime != null) {
    //   setState(() {
    //     _time = newTime;
    //     widget.control.text = _time.format(context) as String;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Row(
          children: <Widget>[
            //   Container(
            //     width: MediaQuery.of(context).size.width / 3.5,
            //     child: Text(
            //       widget.label,
            //       textAlign: TextAlign.left,
            //       style: TextStyle(color: Colors.black, fontSize: 17),
            //     ),
            //   ),
            //   SizedBox(
            //     child: Align(
            //       alignment: Alignment.centerRight,
            //       child: Text(
            //         ':',
            //         style: TextStyle(color: Colors.blue[700], fontSize: 17),
            //       ),
            //     ),
            //     width: 40.0,
            //   ),
            Container(
              margin: EdgeInsets.only(left: 5, bottom: 1, top: 1),
              height: 30,
              width: MediaQuery.of(context).size.width -
                  (MediaQuery.of(context).size.width / 10),
              color: Colors.white,
              child: TextField(
                controller: widget.control,
                readOnly: true,
                style: TextStyle(fontSize: 16.0, color: Colors.black),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5.0),
                    border: OutlineInputBorder(),
                    fillColor: Colors.white,
                    hintText: widget.label),
                onTap: _selectTime,
              ),
            ),
          ],
        );
      },
    );
  }
}
