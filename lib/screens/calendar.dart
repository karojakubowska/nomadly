import 'dart:math';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  List<DateTime> bookedDates;
  final void Function(DateTime, DateTime) onChooseDate;
  CalendarScreen(
      {super.key, required this.bookedDates, required this.onChooseDate});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body:
  //        Column(

  //          children: [
  //           Gap(50),
  //            Container(
  //             height: 400,
  //             width: 350,
  //     child: SfDateRangePicker(
  //       view: DateRangePickerView.month,
  //       selectionMode: DateRangePickerSelectionMode.range,
  //     ),
  //   ),
  //          ],
  //        ));
  // }
  late String _startDate =
      DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
  late String _endDate =
      DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
  late DateTime start = DateTime.now();
  late DateTime end = DateTime.now();
  late List<DateTime> _blackoutDates;
  late Orientation _deviceOrientation;

  @override
  void initState() {
    _blackoutDates = _getBlackoutDates();
    super.initState();
  }

  List<DateTime> _getBlackoutDates() {
    final List<DateTime> dates = <DateTime>[];
    final DateTime startDate =
        DateTime.now().subtract(const Duration(days: 500));
    final DateTime endDate = DateTime.now().add(const Duration(days: 500));
    final Random random = Random();
    for (DateTime date = startDate;
        date.isBefore(endDate);
        date = date.add(Duration(days: random.nextInt(30)))) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        dates.add(date);
      }
    }

    return dates;
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final Widget cardView = Card(
      elevation: 10,
      margin: const EdgeInsets.all(30),
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: _getBlackoutDatePicker(widget.bookedDates)),
    );
    return Scaffold(
        backgroundColor: const Color(0x00171a21),
        body: Column(children: <Widget>[
          Expanded(
              flex: 8,
              child: ListView(children: <Widget>[
                SizedBox(
                  height: 450,
                  child: cardView,
                )
              ])),
          Expanded(
              flex: 1,
              child: Container(
                  child: Column(
                children: [
                  Text('StartRangeDate:' '$_startDate'),
                  Text('EndRangeDate:' '$_endDate'),
                ],
              ))),
          ElevatedButton(
            child: const Text('Search'),
            onPressed: () => {
              widget.onChooseDate(
                start,
                end,
              ),
            },
          )
        ]));
  }

  SfDateRangePicker _getBlackoutDatePicker(List<DateTime> list) {
    return SfDateRangePicker(
      selectionMode: DateRangePickerSelectionMode.range,
      toggleDaySelection: true,
      showTodayButton: true,
      maxDate: DateTime.now().add(const Duration(days: 365)),
      minDate: DateTime.now(),
      enablePastDates: false,
      monthCellStyle: const DateRangePickerMonthCellStyle(
          blackoutDateTextStyle: TextStyle(
              color: Colors.grey, decoration: TextDecoration.lineThrough)),
      monthViewSettings: DateRangePickerMonthViewSettings(
          enableSwipeSelection: false,
          showTrailingAndLeadingDates: true,
          blackoutDates: list,
          firstDayOfWeek: 1,
          dayFormat: 'EEE'),
      navigationMode: DateRangePickerNavigationMode.snap,
      onSelectionChanged: selectionChanged,
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      for (DateTime date in widget.bookedDates) {
        if (date.isAfter(args.value.startDate) &&
            date.isBefore(args.value.endDate ?? args.value.startDate)) {
          _startDate = "wybierz inny termin byczq";
          _endDate = "+1";
        } else {
          _startDate = DateFormat('dd, MMMM yyyy')
              .format(args.value.startDate)
              .toString();
          _endDate = DateFormat('dd, MMMM yyyy')
              .format(args.value.endDate ?? args.value.startDate)
              .toString();
          start = args.value.startDate;
          end = args.value.endDate ?? args.value.startDate;
        }
      }
    });
  }
}
