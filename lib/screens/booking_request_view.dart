import 'package:easy_localization/easy_localization.dart';
import 'package:basics/basics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/models/Date.dart';
import 'package:nomadly_app/screens/checkout.dart';
import 'package:nomadly_app/screens/confirmation.dart';
import 'package:nomadly_app/screens/error_when_book.dart';
import 'package:provider/provider.dart';
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
  late double totalPrice;
  var username;
  Future<void> getUsername() async {
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((event) {
      setState(() {
        username = event.get("Name");
      });
    });
  }

  @override
  void initState() {
    totalPrice = CountTotalPrice(
      widget.guestNumber,
      (widget.accommodation.price_per_night!),
      widget.startDate,
      widget.endDate,
    );
    getUsername();
    super.initState();
  }

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
                Text(DateFormat.yMMMMd(tr('en_US')).format(widget.startDate),
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
                Text(DateFormat.yMMMMd(tr('en_US')).format(widget.endDate),
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
                  tr("Total"),
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
                    ).toString(),
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
                    onPressed: () {
                      BookingTransaction(widget.startDate, widget.endDate);
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
                      tr('Request a booking'),
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

    if (startDate == DateTime.now()) {
      count += 1; //musi byc +1,bo nie liczy dzisiejszego dnia???
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

  void BookingTransaction(DateTime startDate, DateTime endDate) {
    List<BookDate> listOfDates = listAllDates(startDate, endDate);
    if (listOfDates.isEmpty) {
      throw ProviderNullException;
    }
    var db = FirebaseFirestore.instance;
    final sfDocRef =
        db.collection("Accommodations").doc(widget.accommodation.id);
    var bookingRef = db.collection("Bookings").doc();

    db.runTransaction((transaction) async {
      final snapshot = await transaction.get(sfDocRef);
      if (!x(snapshot, listOfDates)) {
        throw FirebaseException(
            plugin: 'cloud_firestore', code: 'predefined-condition-failed');
      }

      for (int i = 0; i < listOfDates.length; i++) {
        transaction.update(sfDocRef, {
          "booked_dates": FieldValue.arrayUnion([
            {'date': listOfDates[i].date, 'hour': listOfDates[i].hour},
          ]),
        });
      }
      transaction
          .update(sfDocRef, {"reservations_count": FieldValue.increment(1)});

      transaction.set(bookingRef, {
        'accommodation_id': widget.accommodation.id,
        'host_id': widget.accommodation.host_id,
        'user_id': FirebaseAuth.instance.currentUser!.uid,
        'start_date': widget.startDate,
        'end_date': widget.endDate,
        'guest_number': widget.guestNumber,
        'total_price': totalPrice,
        'status': "Waiting for confirmation",
        'username': username,
        'isAccommodationRated': false,
        'isUserRated': false,
        'city': widget.accommodation.city,
        'country': widget.accommodation.country,
      });
    }).then(
      (value) => {
        print("DocumentSnapshot successfully updated!"),
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => ConfirmationScreen())))
      },
      onError: (e) => {
        print(e),
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => ErrorWhileBooking())))
      },
    );
  }

  bool x(DocumentSnapshot snapshot, List<BookDate> datesToBook) {
    var startd = datesToBook.first;
    var endd = datesToBook.last;
    List<dynamic> test = List<dynamic>.from(snapshot["booked_dates"]);
    List<BookDate> dates = [];
    test.forEach((element) {
      dates
          .add(BookDate(date: element['date'].toDate(), hour: element['hour']));
    });
    var filteredDates = dates
        .where((element) =>
            element.date! >= startd.date! && element.date! <= endd.date!)
        .toList();
    filteredDates.forEach((element) {
      print(element.date);
    });
    if (filteredDates.isNotEmpty) {
      int posStartDate = -1; //filteredDates.indexOf(startd);
      int posEndDate = -1; //filteredDates.indexOf(startd);
      for (int i = 0; i < filteredDates.length; i++) {
        var x = filteredDates[i];

        if (x.isMyDateEqualTo(startd.date!)) {
          if (x.hour == startd.hour) {
            //została znaleziona rezerwacja o tej samej dacie rozpoczęcia
            posStartDate = i;
            break;
          }

          if (x.hour == "11") {
            posStartDate =
                -1; //przypadek gdy daty są równe, ale w bazie jest data z wymeldowaniem w tym dniu, a my chcemy się w tym dniu zameldować
            break;
          }
          if (x.hour == "12") {
            posStartDate = i;
            break;
          }
        }
      }
      for (int i = 0; i < filteredDates.length; i++) {
        var x = filteredDates[i];

        if (x.isMyDateEqualTo(endd.date!)) {
          if (x.hour == endd.hour) {
            //została znaleziona rezerwacja o tej samej dacie zakończenia
            posEndDate = i;
            break;
          }

          if (x.hour == "14") {
            posEndDate =
                -1; //przypadek gdy daty są równe, ale w bazie jest data z zameldowaniem w tym dniu, a my chcemy się w tym dniu wymeldować
            break;
          }
          if (x.hour == "12") {
            posEndDate = i;
            break;
          }
        }
      }
      if (posEndDate == -1 && posStartDate == -1 && filteredDates.isNotEmpty) {
        return true;
      }

      return false;
    }
    return true;
  }

  List<BookDate> toBookDate(List<DateTime> datesToBook) {
    List<BookDate> x = [];

    for (int i = 0; i < datesToBook.length; i++) {
      if (i == 0) {
        x.add(BookDate(date: datesToBook[i], hour: "14"));
      }
      if (i == datesToBook.length - 1) {
        x.add(BookDate(date: datesToBook[i], hour: "11"));
      }
      x.add(BookDate(date: datesToBook[i], hour: "12"));
    }
    return x;
  }

  List<BookDate> listAllDates(DateTime startDate, DateTime endDate) {
    List<BookDate> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
      if (i == 0) {
        widget.startDate = widget.startDate.toLocal();
        widget.startDate = DateTime(widget.startDate.year,
            widget.startDate.month, widget.startDate.day);
        days.add(BookDate(date: widget.startDate, hour: "14"));
      } else if (i == endDate.difference(startDate).inDays) {
        widget.endDate = widget.endDate.toLocal();
        widget.endDate = DateTime(
            widget.endDate.year, widget.endDate.month, widget.endDate.day);
        days.add(BookDate(date: widget.endDate, hour: "11"));
      } else {
        days.add(BookDate(date: startDate.add(Duration(days: i)), hour: "12"));
      }
    }
    return days;
  }
}
