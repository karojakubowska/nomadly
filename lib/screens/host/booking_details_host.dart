import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/models/Booking.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/models/User.dart';
import 'package:nomadly_app/screens/user_opinions_view.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import '../../utils/app_styles.dart';
import '../chat_single_view.dart';
import '../report_form_view.dart';
import '../add_user_opinion_view.dart';

class BookingDetailsHostScreen extends StatefulWidget {
  Acommodation accommodation;
  Booking booking;

  BookingDetailsHostScreen(
      {required this.accommodation, required this.booking});

  @override
  State<BookingDetailsHostScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsHostScreen> {
  late UserModel userModel;
  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        backgroundColor: Styles.backgroundColor,
        title: Text(tr('Booking details'), style: Styles.headLineStyle4),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          padding: const EdgeInsets.only(left: 30, right: 30, top: 50),
          child: Column(
            children: [
          Expanded(
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
                    DateFormat.yMMMMd(tr('en_US'))
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
                Text(tr("Check-out"), style: Styles.bookingDetailsStyle),
                Text(DateFormat.yMMMMd(tr('en_US')).format(widget.booking.endDate!),
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
              padding: const EdgeInsets.only(
                top: 60,
              ),
              child: Column(
                children: [
                  Container(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('Users')
                              .where(FieldPath.documentId,
                                  isEqualTo: widget.booking.userId)
                              .snapshots(),
                          builder: (context, snap) {
                            if (!snap.hasData) return Text(tr("Loading..."));
                            userModel = UserModel.fromJson(snap.data!.docs[0]
                                .data() as Map<String, dynamic>);
                            return statusButtonSwitch(userModel);
                          })),
                  Container(
                    padding: const EdgeInsets.only(
                      top: 30,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatSingleView(
                              userId: widget.booking.hostId!,
                              otherUserId: widget.booking.userId!,
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
                      ),
                      child: Text(
                        tr('Contact with user'),
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromARGB(255, 50, 134, 252),
                                fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ]))));
  }

  Widget statusButtonSwitch(UserModel user) {
    //print('Document data: ${documentSnapshot.data()}');
    if (widget.booking.status == "Finished" &&
        widget.booking.isUserRated == false) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => UserReviewScreen(
                          booking: widget.booking, user: userModel))));
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
              tr('Rate the user'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          const Gap(30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportFormView(
                    otherUserId: widget.booking.userId!,
                  ),
                ),
              );
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 255, 58, 65)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(320, 50)),
            ),
            child: Text(
              tr('Report the user'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      );
    }
    if (widget.booking.status == "Waiting for confirmation") {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('Bookings')
                  .doc(widget.booking.id)
                  .update({'status': 'Confirmed'});
              Navigator.pop(context);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 50, 134, 252)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(320, 50)),
            ),
            child: Text(
              tr('Confirm'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          Gap(30),
           ElevatedButton(
            onPressed: () {
              FirebaseFirestore.instance
                  .collection('Bookings')
                  .doc(widget.booking.id)
                  .update({'status': 'Canceled'});
              Navigator.pop(context);
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  Color.fromARGB(255, 217, 32, 32)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(320, 50)),
            ),
            child: Text(
              tr('Cancel'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          ),
          Gap(30),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => UserOpinionsScreen(
                          booking: widget.booking,
                          userId: widget.booking.userId!,
                          user: user))));
            },
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 50, 134, 252)),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
              minimumSize: MaterialStateProperty.all(const Size(320, 50)),
            ),
            child: Text(
              tr('Check user opinions'),
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w700)),
            ),
          )
        ],
      );
    }
    return Container();
  }
}
