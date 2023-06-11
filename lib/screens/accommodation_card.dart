import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/shimmers/shimmer_load_photos.dart';
import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'accommodation_details_view.dart';

class AccommodationCard extends StatefulWidget {
  final Acommodation accomodation;
  final int index;
  DateTime? start_date;
  DateTime? end_date;
  int? guest_number;

  AccommodationCard(
      {super.key,
      required this.accomodation,
      required this.index,
      this.start_date,
      this.guest_number,
      this.end_date});

  @override
  State<AccommodationCard> createState() => _AccommodationCardState();
}

class _AccommodationCardState extends State<AccommodationCard> {
  navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => DetailScreen(
                  accommodation: accommodation,
                  start_date: widget.start_date,
                  end_date: widget.end_date,
                  guest_number: widget.guest_number,
                ))));
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return InkWell(
      child: Container(
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
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      height: 180,
                      width: size.width,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          image: DecorationImage(
                            image: NetworkImage(snapshot.data.toString()),
                            fit: BoxFit.fill,
                          )));
                } else {
                  return Center(
                      child: ShimmerLoadCardPhotos(
                          height: 180, width: size.width));
                }
              },
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.accomodation.title!,
                    style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 24, 24, 24),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "\$${widget.accomodation.price_per_night?.toStringAsFixed(2)}",
                    style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 24, 24, 24),
                        fontSize: 18,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 30,
                      width: 50,
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 50, 134, 252),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(
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
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Wishlists")
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection("favs")
                          .where("accommodationId",
                              isEqualTo: widget.accomodation.id)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.data == null) return Text(tr("No data"));
                        return IconButton(
                            onPressed: () async {
                              snapshot.data!.docs.length == 0
                                  ? await addToFavorites(
                                      widget.accomodation.id!)
                                  : deleteFromFavorites(
                                      widget.accomodation.id!);
                            },
                            icon: snapshot.data!.docs.length == 0
                                ? const Icon(Icons.favorite_border_outlined)
                                : const Icon(Icons.favorite));
                      })
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

  Future addToFavorites(String accommodationId) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    CollectionReference wishlist =
        FirebaseFirestore.instance.collection("Wishlists");
    return wishlist
        .doc(userId)
        .collection("favs")
        .doc()
        .set({'accommodationId': accommodationId})
        .then((value) => print("liked"))
        .catchError((error) => print("Something went wrong when liking"));
  }

  Future deleteFromFavorites(String accommodationId) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    var wishlist = FirebaseFirestore.instance
        .collection("Wishlists")
        .doc(userId)
        .collection("favs")
        .where('accommodationId', isEqualTo: widget.accomodation.id)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        FirebaseFirestore.instance
            .collection("Wishlists")
            .doc(userId)
            .collection("favs")
            .doc(element.id)
            .delete()
            .then((value) {
          print("unliked");
        });
      });
    });
    return wishlist;
  }
}
