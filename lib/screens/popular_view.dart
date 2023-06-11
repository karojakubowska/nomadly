import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:gap/gap.dart';

import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'accommodation_details_view.dart';

class PopularCard extends StatefulWidget {
  Acommodation accomodation;
  String accommodationName = '';
  String accommodationCity = '';
  String accommodationPhoto = '';
  int index;
  PopularCard(
      {super.key, required this.accomodation,
      required this.accommodationCity,
      required this.accommodationName,
      required this.accommodationPhoto,
      required this.index});

  @override
  State<PopularCard> createState() => _PopularCardState();
}

class _PopularCardState extends State<PopularCard> {
   navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => DetailScreen(
                  accommodation: accommodation,
                ))));
  }
  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        width: size.width ,
        height: 90,
        decoration: BoxDecoration(
          color: Styles.whiteColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            FutureBuilder(
              future: FirebaseStorage.instance
                  .refFromURL(widget.accommodationPhoto)
                  .getDownloadURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  //photo = (widget.accommodationPhoto);
                   return Container(
              margin: const EdgeInsets.only(left: 10, right: 10,),
              height: 65,
              width: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image:  DecorationImage(
                     image: NetworkImage(snapshot.data.toString()),
                         fit: BoxFit.cover,
                  )));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
           
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.accommodationCity,
                  style: Styles.popularNameStyle,
                ),
                Row(
                  children: [Text(widget.accomodation.rate.toString()),
                  Gap(10),
                    RatingBarIndicator(
                                rating:widget.accomodation.rate!.toDouble(),//rating: user.rate!.toDouble(),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemCount: 5,
                                itemSize: 10.0,
                                direction: Axis.horizontal,
                              ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
        onTap: () {
        navigateToDetail(widget.accomodation);
      },
    );
  }
}
