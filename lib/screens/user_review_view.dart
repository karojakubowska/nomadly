import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Booking.dart';

import '../models/User.dart';
import '../utils/app_styles.dart';

class UserReviewScreen extends StatelessWidget {
    Booking booking;
    UserModel user;
  //  DocumentSnapshot doc;
  UserReviewScreen({super.key,required this.booking,required this.user});

  final descriptionController = TextEditingController();

  var userRating;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Styles.backgroundColor,
          title: Text(tr('Review'), style: Styles.headLineStyle4),
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
                userRating = rating;
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
                decoration: InputDecoration(
                  labelText: tr('Tell us about your experience with your guests'),
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
                tr('Send opinion'),
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
    if (descriptionController.text.isEmpty ||userRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('All fields are required')),
      ));
      return;
    }
    /// #TODO
    // if(userRating == null){
    //     ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('First field is required')),
    //   );
    //   return;
    // }
    CollectionReference opinion=
        FirebaseFirestore.instance.collection('UserOpinions');

    return opinion.add({
      'hostId':FirebaseAuth.instance.currentUser!.uid,
      'opinionText': descriptionController.text,
      'rate': userRating,
      'userId': booking.userId,
      'pub_date':DateTime.now(),
    }).then((value) {
       user.rate = addToAverage(user.rate!.toDouble(),
          user.opinionsNumber!.toInt(), userRating!);
      FirebaseFirestore.instance
          .collection('Users')
          .doc(booking.userId)
          .update(
              {"opinionsNumber": FieldValue.increment(1), "rate": user.rate});
      FirebaseFirestore.instance
          .collection('Bookings')
          .doc(booking.id)
          .update({"isUserRated": true});
      Navigator.popUntil(
          context, (AllBookingsHostScreen) => AllBookingsHostScreen.isFirst);
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
