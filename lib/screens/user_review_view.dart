import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_styles.dart';

class UserReviewScreen extends StatefulWidget {
  const UserReviewScreen({super.key});

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final descriptionController = TextEditingController();
  var userRating;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          backgroundColor: Styles.backgroundColor,
          title: Text('Review', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Gap(30),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
                userRating = rating;
              },
            ),
            Gap(30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: descriptionController,
                cursorColor: Colors.white,
                maxLines: 10,
                textInputAction: TextInputAction.next,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  labelText: 'Tell us about your experience with your guests',
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
            Gap(30),
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
                    textStyle: TextStyle(
                        fontSize: 16.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ));
  }

  Future<void> addOpinion(BuildContext context) async {
    if (descriptionController.text.isEmpty || userRating == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    CollectionReference opinion=
        FirebaseFirestore.instance.collection('Opinion');

    return opinion.add({
      'description': descriptionController.text,
      'rating': userRating,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    }).then((value) {
      print("DocumentSnapshot successfully updated!");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('New opinion added')),
      
    }, onError: (e) {
      print("Error updating document $e");
    });
  }
}
