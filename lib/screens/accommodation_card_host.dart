import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/update_accommodation_view.dart';
import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'details_view.dart';

class AccommodationCardHost extends StatefulWidget {
  final Acommodation accomodation;
  final int index;
  final String? host_id;

  const AccommodationCardHost(
      {super.key, required this.accomodation, required this.index, required this.host_id});

  @override
  State<AccommodationCardHost> createState() => _AccommodationCardHostState();
}

class _AccommodationCardHostState extends State<AccommodationCardHost> {
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
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            width: size.width,
            height: size.height * 0.31,
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
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                const SizedBox(height: 10),
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
                      // Text(
                      //   "\$${widget.accomodation.price_per_night}",
                      //   style: GoogleFonts.roboto(
                      //       color: Color.fromARGB(255, 24, 24, 24),
                      //       fontSize: 18,
                      //       fontWeight: FontWeight.w500),
                      // ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                // Container(
                //   margin: EdgeInsets.only(left: 20, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Container(
                //           height: 30,
                //           width: 50,
                //           decoration: BoxDecoration(
                //               color: Color.fromARGB(255, 50, 134, 252),
                //               shape: BoxShape.rectangle,
                //               borderRadius:
                //                   BorderRadius.all(Radius.circular(5))),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //             children: [
                //               Icon(
                //                 Icons.star,
                //                 color: Colors.white,
                //                 size: 16,
                //               ),
                //               // Text(
                //               //   widget.accomodation.rate!.toString(),
                //               //   style: GoogleFonts.roboto(
                //               //       fontSize: 14,
                //               //       fontWeight: FontWeight.w600,
                //               //       color: Colors.white),
                //               // ),
                //             ],
                //           )),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 15,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: ((context) => UpdateAccommodationScreen())));
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        navigateToDetail(widget.accomodation);
      },
    );
  }
}
