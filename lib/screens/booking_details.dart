import 'package:easy_localization/easy_localization.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/accommodation_review_view.dart';
<<<<<<< Updated upstream
import 'package:nomadly_app/screens/chat_single_view.dart';
=======
import 'package:nomadly_app/screens/payment.dart';
>>>>>>> Stashed changes

import '../models/Accomodation.dart';
import '../models/Booking.dart';
import '../utils/app_styles.dart';

class BookingDetails extends StatefulWidget {
  Acommodation accommodation;
  Booking booking;
  BookingDetails(
      {super.key, required this.accommodation, required this.booking});

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Styles.backgroundColor,
        title: Text(tr('Booking details'), style: Styles.headLineStyle4),
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
                Text(tr("Accommodation"), style: Styles.bookingDetailsStyle),
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
                Text(tr("Check-in"), style: Styles.bookingDetailsStyle),
                Text(
                    DateFormat.yMMMMd('en_US')
                        .format(widget.booking.startDate!),
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
                Text(DateFormat.yMMMMd('en_US').format(widget.booking.endDate!),
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
                Text(tr("For"), style: Styles.bookingDetailsStyle),
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
                Text(tr("Status"), style: Styles.bookingDetailsStyle),
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
                  tr("Total"),
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
                      padding: const EdgeInsets.only(top: 30, bottom: 30),
                      child: statusButtonSwitch()),
<<<<<<< Updated upstream
                      if( widget.booking.isAccommodationRated==false)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatSingleView(
                            userId: widget.booking.userId!,
                            otherUserId: widget.booking.hostId!,
                          ),
                        ),
                      );
                    },
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
=======
                  if (widget.booking.isAccommodationRated == false)
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
                        tr('Contact with host'),
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 50, 134, 252),
                                fontWeight: FontWeight.w700)),
                      ),
>>>>>>> Stashed changes
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statusButtonSwitch() {
    if (widget.booking.status == "Finished" &&
        widget.booking.isAccommodationRated == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => AccommodationReviewScreen(
                          accommodation: widget.accommodation,
                          booking: widget.booking))));
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 50, 134, 252)),
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(320, 50)),
            ),
            child: Text(
              tr('Rate the accommodation'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const Gap(30),
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 255, 58, 65)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(320, 50)),
            ),
            child: Text(
              tr('Report the host'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      );
    } else if (widget.booking.status == "Confirmed") {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => PaymentDetailsScreen())));
        },
        style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all<Color>(
              const Color.fromARGB(255, 50, 134, 252)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          minimumSize: MaterialStateProperty.all(const Size(320, 50)),
        ),
        child: Text(
          tr('Go to payment'),
          style: GoogleFonts.roboto(
              fontSize: 16.0,
              textStyle: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700)),
        ),
      );
    } else {
      return Container();
    }
  }
}
