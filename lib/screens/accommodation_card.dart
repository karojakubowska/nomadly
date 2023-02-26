import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'details_view.dart';

class AccommodationCard extends StatefulWidget {
  Acommodation accomodation;
  // String accommodationName = '';
  // String accommodationCity = '';
  // String accommodationPhoto = '';
  int index;
  AccommodationCard(
      {super.key,
      required this.accomodation,
      // required this.accommodationCity,
      // required this.accommodationName,
      // required this.accommodationPhoto,
      required this.index});

  @override
  State<AccommodationCard> createState() => _AccommodationCardState();
}

class _AccommodationCardState extends State<AccommodationCard> {
  navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => DetailScreen(
                  acommodation: accommodation,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        width: size.width,
        height: size.height * 0.3,
        decoration: BoxDecoration(
          color: Styles.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseStorage.instance
                  .refFromURL(widget.accomodation.photo!)
                  .getDownloadURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      height: 180,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data.toString()),
                            fit: BoxFit.fill,
                          )));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            Gap(10),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.accomodation.title!,
                    style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 24, 24, 24),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "\$${widget.accomodation.price_per_night}",
                    style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 24, 24, 24),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            Gap(10),
            Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 30,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 50, 134, 252),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 16,
                          ),
                          Text(
                            widget.accomodation.rate!.toString(),
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ],
                      )),
                ],
              ),
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
