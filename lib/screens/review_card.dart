import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';

import 'package:intl/intl.dart';
import '../models/Review.dart';
import '../models/User.dart';

class ReviewCard extends StatelessWidget {
  UserModel user;
  Review review;

  ReviewCard({
    Key? key,
    required this.user,
    required this.review,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                FutureBuilder(
                  future: FirebaseStorage.instance
                      .refFromURL(user.accountImage!)
                      .getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic>? snapshot) {
                    if (snapshot?.hasData == true) {
                      return CircleAvatar(
                          radius: 20.0,
                          backgroundImage:
                              NetworkImage(snapshot!.data.toString()));
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.ideographic,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            user.name!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                          const Gap(10),
                          RatingBarIndicator(
                            rating:review.rate!.toDouble(),//rating: user.rate!.toDouble(),
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            itemCount: 5,
                            itemSize: 10.0,
                            direction: Axis.horizontal,
                          ),
                          const Gap(10),
                        ],
                      ),
                    ],
                  ),
                ),
                // SizedBox(width: 8),
                Text(
                  DateFormat.yMMMMd('en_US').format(review.date!.toDate()),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const Gap(10),
            Text(
              review.reviewText!,
              style: const TextStyle(
                fontSize: 10,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
