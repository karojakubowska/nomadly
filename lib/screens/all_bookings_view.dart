import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

import '../models/Accomodation.dart';
import '../models/Booking.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'booking_card.dart';
import 'host/booking_card_host.dart';

class AllBookingsScreen extends StatefulWidget {
  const AllBookingsScreen({super.key});

  @override
  State<AllBookingsScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsScreen> {

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userID = user!.uid;
Query query = FirebaseFirestore.instance.collection("Bookings");
    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: Styles.backgroundColor,
          title: Text('Bookings', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                Gap(10),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: size.height * 0.78,
                        width: size.width * 0.9,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Bookings")
                              .where('user_id',
                                  isEqualTo: userID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Text("Loading...");
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
                                          return const Text("Loading...");
                                        Acommodation model =
                                            Acommodation.fromJson(
                                                snap.data!.docs[0].data()
                                                    as Map<String, dynamic>);
                                        Booking booking = Booking.fromJson(
                                            snapshot.data!.docs[0].data()
                                                as Map<String, dynamic>);
                                        return BookingCard(
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