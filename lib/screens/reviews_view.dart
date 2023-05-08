import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Review.dart';
import 'package:nomadly_app/models/User.dart';
import 'package:nomadly_app/screens/review_card.dart';

import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class ReviewScreen extends StatefulWidget {
  String accommodationId;
  double rate;

  ReviewScreen({super.key, required this.accommodationId, required this.rate});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Styles.backgroundColor,
        title: Text('Reviews', style: Styles.headLineStyle4),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
       padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  widget.rate.toString(),
                  style: GoogleFonts.roboto(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                RatingBarIndicator(
                  rating: widget.rate,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 40.0,
                  direction: Axis.horizontal,
                ),
              ],
            ),
            SizedBox(
              height: size.height*0.8,
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Reviews')
                    .where("accommodationId", isEqualTo: widget.accommodationId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Text("Loading...");
                  if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No reviews yet.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                color: Color.fromARGB(255, 24, 24, 24),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('Users')
                                .where(FieldPath.documentId,
                                    isEqualTo: snapshot.data!.docs[index]
                                        ['userId'])
                                .snapshots(),
                            builder: (context, snap) {
                              if (!snap.hasData)
                                return const Text("Loading...");
                              UserModel user = UserModel.fromJson(
                                  snap.data!.docs[0].data()
                                      as Map<String, dynamic>);
                              Review review = Review.fromJson(
                                  snapshot.data!.docs[index].data()
                                      as Map<String, dynamic>);

                              return ReviewCard(
                                user: user,
                                review: review,
                              );
                            });
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
