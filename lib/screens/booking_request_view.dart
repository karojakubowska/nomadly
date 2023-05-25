import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import '../utils/app_styles.dart';

class BookingRequestScreen extends StatefulWidget {
  Acommodation accommodation;
  DateTime startDate;
  DateTime endDate;
  int guestNumber;
  BookingRequestScreen(
      {super.key,
      required this.accommodation,
      required this.startDate,
      required this.guestNumber,
      required this.endDate});

  @override
  State<BookingRequestScreen> createState() => _BookingRequestScreenState();
}

class _BookingRequestScreenState extends State<BookingRequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Styles.backgroundColor,
        title: Text('Booking details', style: Styles.headLineStyle4),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
        child: Column(
          children: [
            //AccommodationCard(accomodation: accomodation, index: index),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Accommodation", style: Styles.bookingDetailsStyle),
                Text(widget.accommodation.title!,
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontWeight: FontWeight.w700))),
              ],
            ),
            Styles.divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check-in", style: Styles.bookingDetailsStyle),
                Text(
                    DateFormat.yMMMMd('en_US')
                        .format(widget.startDate),
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontWeight: FontWeight.w700)))
              ],
            ),
            Styles.divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Check-out", style: Styles.bookingDetailsStyle),
                Text(
                    DateFormat.yMMMMd('en_US')
                        .format(widget.endDate),
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontWeight: FontWeight.w700)))
              ],
            ),
            Styles.divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("For", style: Styles.bookingDetailsStyle),
                Text(widget.guestNumber.toString(),
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontWeight: FontWeight.w700)))
              ],
            ),
            Styles.divider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 135, 135, 135),
                          fontWeight: FontWeight.w700)),
                ),
                Text(
                    CountTotalPrice(
                            widget.guestNumber,
                            (widget.accommodation.price_per_night!),
                            // DateTime.fromMillisecondsSinceEpoch(
                            //     widget.startDate.seconds * 1000),
                            // DateTime.fromMillisecondsSinceEpoch(
                            //     widget.endDate.seconds * 1000)
                            widget.startDate,
                            widget.endDate,
                            )
                        .toString(),
                    style: const TextStyle(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 49, 134, 252),
                        fontWeight: FontWeight.w600))
              ],
            ),
            Container(
              height: 300,
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          side: const BorderSide(
                              color: Color.fromARGB(255, 50, 134, 252),
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10))),
                      minimumSize:
                          MaterialStateProperty.all(const Size(320, 50)),
                    ),
                    child: Text(
                      'Request a booking',
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 16.0,
                              color: Color.fromARGB(255, 50, 134, 252),
                              fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  int CountDaysBetweenDates(DateTime startDate, DateTime endDate) {
    var count;

    if(startDate==DateTime.now()){
      count+=1;//musi byc +1,bo nie liczy dzisiejszego dnia???
    }
    Duration diff = startDate.difference(endDate);
    count = diff.inDays;
    return (count).abs();
  }

  double CountTotalPrice(
      int guestNumber, int price, DateTime start, DateTime end) {
    var days = CountDaysBetweenDates(start, end);
    var total;
    total = (guestNumber * price * days).toDouble();
    return total;
  }

}
