import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/host/booking_card_host.dart';

import '../../models/Accomodation.dart';
import '../../models/Booking.dart';
import '../../services/booking_provider.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';

class AllBookingsHostScreen extends StatefulWidget {
  const AllBookingsHostScreen({super.key});

  @override
  State<AllBookingsHostScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsHostScreen> {
  BookingProvider bookingProvider = BookingProvider();
  List<Booking> bookings = [];
  void fetchBookings(String userId) async {
    bookings = await bookingProvider.getBookingsByHostId(userId);
  }
void changeStatus(List<Booking> bookings) {
    DateTime today = DateTime.now();
    for (var booking in bookings) {
      if (booking.status == "Paid") {
        if (booking.endDate!.isAfter(today)) {
          continue;
        } else {
          FirebaseFirestore.instance
              .collection('Bookings')
              .doc(booking.id)
              .update({"status": "Finished"});
        }
      }
    }
  }
  void checkIfStatusChanged() {
    setState(() {
      changeStatus(bookings);
    });
  }
  Query query = FirebaseFirestore.instance.collection("Bookings");
  @override
  Widget build(BuildContext context) {
    fetchBookings(FirebaseAuth.instance.currentUser!.uid);
    final locale = context.locale;

    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userID = user!.uid;

    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: Styles.backgroundColor,
          title: Text(tr('Bookings'), style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const Gap(10),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: size.height * 0.78,
                        width: size.width * 0.9,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Bookings")
                              .where('host_id',
                                  isEqualTo: userID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return Text(tr("Loading..."));
                            if (snapshot.data!.docs.isEmpty) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/empty-box.png',
                                      width: 100,
                                      height: 100,
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                     tr("Find your new bookings!"),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        color: const Color.fromARGB(255, 24, 24, 24),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Accommodations')
                                          .where(FieldPath.documentId,
                                              isEqualTo:
                                                  snapshot.data!.docs[index]
                                                      ['accommodation_id'])
                                          .snapshots(),
                                      builder: (context, snap) {
                                        if (!snap.hasData)
                                          return Text(tr("Loading..."));
                                        Acommodation model =
                                            Acommodation.fromJson(
                                                snap.data!.docs[0].data()
                                                    as Map<String, dynamic>);
                                        Booking booking = Booking.fromJson(
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>);
                                                booking.id=snapshot.data!.docs[index].id;

                                        return BookingCardHost(
                                          booking: booking,
                                          index: index,
                                          accommodation: model,
                                        );
                                      });
                                });
                          },
                        ),
                      )
                    ])),
              ],
            ),
          ],
        ));
  }
}
