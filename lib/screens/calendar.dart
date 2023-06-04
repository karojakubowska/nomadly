import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../models/Date.dart';
import '../utils/app_layout.dart';

class CalendarScreen extends StatefulWidget {
  List<BookDate> bookedDates;
  //List<DateTime> bookedDates;
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
  List<DateTime> list = [];
  late DateTime start = DateTime.now();
  late DateTime end = DateTime.now();
  late List<DateTime> _blackoutDates;
  late Orientation _deviceOrientation;

  @override
  void initState() {
    _blackoutDates = _getBlackoutDates();
    super.initState();
  }

  // List<DateTime> _getBlackoutDates() {
  //   final List<DateTime> dates = <DateTime>[];
  //   final DateTime startDate =
  //       DateTime.now().subtract(const Duration(days: 500));
  //   final DateTime endDate = DateTime.now().add(const Duration(days: 500));
  //   final Random random = Random();
  //   for (DateTime date = startDate;
  //       date.isBefore(endDate);
  //       date = date.add(Duration(days: random.nextInt(30)))) {
  //     if (date.weekday != DateTime.saturday &&
  //         date.weekday != DateTime.sunday) {
  //       dates.add(date);
  //     }
  //   }

  //   return dates;
  // }
  List<DateTime> _getBlackoutDates() {
    // List<DateTime> x=toListOfDates(widget.bookedDates);
    // return x;
    //final List<DateTime> dates = <DateTime>[];

    // for (var booked in widget.bookedDates) {
    //   if (booked.hour != 11 &&
    //       booked.hour!=14) {
    //     list.add(booked);
    //   }
    // }

    for (int i = 0; i < widget.bookedDates.length; i++) {
      BookDate date = widget.bookedDates[i];
      if (i < widget.bookedDates.length - 1) {
        //jeśli nieostatni element to
        BookDate dateNext =
            widget.bookedDates[i + 1]; //sprawdzamy kolejny element po aktylnym
        if (date.hour == '11' && dateNext.hour == '14' ||
            date.hour == '14' && dateNext.hour == '11') {
          list.add(date.date!);
        } else if (date.hour == '12') {
          list.add(date.date!);
        }
      } else {
        if (date.hour == '11') {
          //  list.add(date);
        } else if (date.hour == '12') {
          list.add(date.date!);
        }
      }
    }
    return list;
  }

  @override
  void didChangeDependencies() {
    _deviceOrientation = MediaQuery.of(context).orientation;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    final Widget cardView = Card(
      elevation: 10,
      margin: const EdgeInsets.fromLTRB(10, 30, 10, 0),
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
          child: _getBlackoutDatePicker()),
    );
    return Scaffold(
        backgroundColor: const Color(0x00171a21),
        body: Container(
          height: size.height,
          width: size.width, //size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(children: <Widget>[
            //const Gap(100),
            SizedBox(
              height: 370,
              child: ListView(children: <Widget>[cardView]),
            ),
            // Expanded(
            //     flex: 1,
            //     child: Column(
            //       children: [
            //     Text('StartRangeDate:' '$_startDate'),
            //     Text('EndRangeDate:' '$_endDate'),
            //       ],
            //     )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_startDate),
                const Gap(10),
                Text(_endDate),
              ],
            ),

            ElevatedButton(
              child: const Text('Search'),
              onPressed: () => {
                widget.onChooseDate(
                  start,
                  end,
                ),
                Navigator.pop(context),
              },
            )
          ]),
        ));
  }

  SfDateRangePicker _getBlackoutDatePicker() {
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
          blackoutDates: _getBlackoutDates(),
          firstDayOfWeek: 1,
          dayFormat: 'EEE'),
      navigationMode: DateRangePickerNavigationMode.snap,
      onSelectionChanged: selectionChanged,
    );
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if(list.isNotEmpty){
      for (DateTime date in list) {
        if (date.isAfter(args.value.startDate) &&
            date.isBefore(args.value.endDate ?? args.value.startDate)) {
          _startDate =
              "Sorry this dates are already taken :( Choose different dates";
          //_endDate = "+1";
        } else if (args.value.startDate == args.value.endDate) {
          _startDate = "Minimal reservation time is one night";
          // _endDate = "+1";
        } }}
        //  if (args.value.startDate == (args.value.endDate ?? args.value.startDate)) {
        //   _startDate = "Minimal reservation time is one night";
        //    _endDate = "";
        // }
         //else{ 
          _startDate = DateFormat.yMMMMd('en_US').format(args.value.startDate);
          _endDate = DateFormat.yMMMMd('en_US')
              .format(args.value.endDate ?? args.value.startDate)
                  .toString();
                  //}
          start = args.value.startDate;

          end = args.value.endDate ?? args.value.startDate;
       // }
     // }
    });
    if (_startDate ==
        "Sorry this dates are already taken :( Choose different dates") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                  child: const Text(
                      "Info")),
              content: Text(_startDate),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'))
              ],
            );
          });
    }
    if (_startDate == "Minimal reservation time is one night") {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Container(
                  child: const Text(
                      "Info")),
              content: Text(_startDate),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('close'))
              ],
            );
          });
    }
  }

  List<DateTime> toListOfDates(List<BookDate> bookedDates) {
    List<DateTime> x = [];
    bookedDates.forEach((element) {
      x.add(element.date!);
    });
    return x;
  }
}
