import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  @override
  Widget build(BuildContext context) {
    return SfCalendar(
      view: CalendarView.month,
      monthViewSettings: MonthViewSettings(
        dayFormat: 'EEE',
      ),
      todayTextStyle: TextStyle(fontWeight: FontWeight.bold),
      headerStyle: CalendarHeaderStyle(
          textAlign: TextAlign.center,
          backgroundColor: Colors.blue[600],
          textStyle: TextStyle(
              fontSize: 25,
              fontStyle: FontStyle.normal,
              letterSpacing: 5,
              color:Colors.white,
              fontWeight: FontWeight.w500)),
    );
  }
}
