import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/models/Booking.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/screens/add_travel_view.dart';
import 'package:nomadly_app/screens/change_password_view.dart';
import 'package:nomadly_app/screens/checkout_confirmed.dart';
import 'package:nomadly_app/screens/home_host_view.dart';
import '../../utils/app_styles.dart';

class BookingDetailsScreen extends StatefulWidget {
  Acommodation accommodation;
  Booking booking;
  BookingDetailsScreen({required this.accommodation, required this.booking});
  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
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
                        .format(widget.booking.startDate!.toDate()),
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
                        .format(widget.booking.endDate!.toDate()),
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
                Text(widget.booking.guestNumber!.toString(),
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
                Text("Status", style: Styles.bookingDetailsStyle),
                Text(widget.booking.status!,
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
                Text("\$${widget.booking.totalPrice!.toStringAsFixed(2)}",
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
                  
                  Container(
                      height: 190,
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: widget.booking.status != 'Finished'
                          ? Container()
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color.fromARGB(
                                                255, 50, 134, 252)),
                                    elevation: MaterialStateProperty.all(0),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(320, 50)),
                                  ),
                                  child: Text(
                                    'Rate the user',
                                    style: GoogleFonts.roboto(
                                        textStyle: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ButtonStyle(
                                    elevation: MaterialStateProperty.all(0),
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        const Color.fromARGB(255, 255, 58, 65)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(320, 50)),
                                  ),
                                  child: Text(
                                    'Report the user',
                                    style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700)),
                                  ),
                                ),
                              ],
                            )),
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
                      'Contact with user',
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

  Color statusButtonSwitch() {
    if (widget.booking.status == "Finished") {
      return Colors.grey.shade600;
    } else if (widget.booking.status == "In progress") {
      return Styles.pinColor;
    } else if (widget.booking.status == "Waiting for confirmation") {
      return Colors.yellow.shade700;
    } else {
      return Colors.green.shade600;
    }
  }
}
