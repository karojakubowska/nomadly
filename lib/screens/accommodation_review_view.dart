import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/all_bookings_view.dart';

import '../models/Accomodation.dart';
import '../models/Booking.dart';
import '../utils/app_styles.dart';

class AccommodationReviewScreen extends StatelessWidget {
  Acommodation accommodation;
  Booking booking;
  AccommodationReviewScreen(
      {super.key, required this.accommodation, required this.booking});

  final descriptionController = TextEditingController();

  double? accommodationRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Styles.backgroundColor,
          title: Text('Review', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Gap(30),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                accommodationRating = rating;
              },
            ),
            const Gap(30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: descriptionController,
                cursorColor: Colors.white,
                maxLines: 10,
                textInputAction: TextInputAction.next,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Tell us about your experience',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 217, 217, 217),
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 249, 250, 250),
                ),
              ),
            ),
            const Gap(30),
            ElevatedButton(
              onPressed: () {
                addOpinion(context);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 50, 134, 252)),
                elevation: MaterialStateProperty.all(0),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                minimumSize: MaterialStateProperty.all(const Size(120, 50)),
              ),
              child: Text(
                'Send review',
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ));
  }

  Future<void> addOpinion(BuildContext context) async {
    if (descriptionController.text.isEmpty || accommodationRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    CollectionReference review =
        FirebaseFirestore.instance.collection('Reviews');

    return review.add({
      'reviewText': descriptionController.text,
      'rate': accommodationRating,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'pub_date': DateTime.now(),
      'accommodationId': accommodation.id
    }).then((value) {
      //print("DocumentSnapshot successfully updated!");
      accommodation.rate = addToAverage(accommodation.rate!.toDouble(),
          accommodation.reviews!.toInt(), accommodationRating!);
      FirebaseFirestore.instance
          .collection('Accommodations')
          .doc(accommodation.id)
          .update(
              {"reviews": FieldValue.increment(1), "rate": accommodation.rate});
      FirebaseFirestore.instance
          .collection('Bookings')
          .doc(booking.id)
          .update({"rated": true});
      Navigator.popUntil(
          context, (AllBookingsScreen) => AllBookingsScreen.isFirst);
    }, onError: (e) {
      print("Error updating document $e");
    });
  }

  double addToAverage(double average, int size, double value) {
    return roundDouble((size * average + value) / (size + 1), 1);
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
