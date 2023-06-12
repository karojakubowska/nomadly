import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../models/Date.dart';
import '../utils/app_layout.dart';

class CalendarScreen extends StatefulWidget {
  List<BookDate> bookedDates;
  DateTime? startDate;
  DateTime? endDate;

  //List<DateTime> bookedDates;
  final void Function(DateTime, DateTime) onChooseDate;

  CalendarScreen(
      {super.key,
      required this.bookedDates,
      required this.onChooseDate,
      this.startDate,
      this.endDate});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late String _startDate =
      DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
  late String _endDate =
      DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
  List<DateTime> list = [];
  DateTime start = DateTime.now();

  DateTime end = DateTime.now();
  late List<DateTime> _blackoutDates;
  late Orientation _deviceOrientation;

  @override
  void initState() {
    start = DateTime.now();
    end = DateTime.now();
    super.initState();
  }

  List<DateTime> _getBlackoutDates() {
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
          width: size.width,
          //size.width * 0.8,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
            ),
          ),
          child: Column(children: <Widget>[
            SizedBox(
              height: 370,
              child: ListView(children: <Widget>[cardView]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_startDate),
              ],
            ),
            ElevatedButton(
              child: const Text('Search'),
              onPressed: () => {
                if (_startDate == tr("Minimal reservation time is one night") ||
                    _startDate ==
                        tr("Sorry these dates are already taken. Choose different dates."))
                  {null}
                else
                  {
                    widget.onChooseDate(
                      start,
                      end,
                    ),
                    Navigator.pop(context),
                  }
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
      if (widget.bookedDates.isNotEmpty) {
        for (int i = 0; i < widget.bookedDates.length; i++) {
          DateTime date = widget.bookedDates[i].date!;
          if (date.isAfter(args.value.startDate) &&
              date.isBefore(args.value.endDate ?? args.value.startDate)) {
            _startDate =
                tr("Sorry these dates are already taken. Choose different dates.");
            break;
          } else if (args.value.startDate == args.value.endDate) {
            _startDate = tr("Minimal reservation time is one night");
            break;
          } else {
            _startDate =
                DateFormat.yMMMMd('en_US').format(args.value.startDate);
            _endDate = DateFormat.yMMMMd('en_US')
                .format(args.value.endDate ?? args.value.startDate)
                .toString();
          }
          start = args.value.startDate;

          end = args.value.endDate ?? args.value.startDate;
        }
      }
    });
  }

  List<DateTime> toListOfDates(List<BookDate> bookedDates) {
    List<DateTime> x = [];
    bookedDates.forEach((element) {
      x.add(element.date!);
    });
    return x;
  }
}
