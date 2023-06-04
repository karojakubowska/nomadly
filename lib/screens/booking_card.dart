import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../models/Accomodation.dart';
import '../models/Booking.dart';
import '../models/User.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import '../utils/shimmers/shimmer_load_photos.dart';
import 'booking_details.dart';

class BookingCard extends StatefulWidget {
  Booking booking;
  int index;
  Acommodation accommodation;

  //const BookingCardHost({super.key});
  BookingCard(
      {super.key,
      required this.booking,
      required this.index,
      required this.accommodation});

  @override
  State<BookingCard> createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  var user;

  navigateToDetail(Acommodation accommodation, Booking booking) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => BookingDetails(
                  accommodation: accommodation,
                  booking: booking,
                ))));
  }

  void initState() {
    setState(() {
      user = getUser(widget.booking.userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    initState();
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
        width: size.width,
        height: size.height * 0.35,
        decoration: BoxDecoration(
          color: Styles.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            FutureBuilder(
              future: FirebaseStorage.instance
                  .refFromURL(widget.accommodation.photo!)
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        widget.accommodation.title!,
                        style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 24, 24, 24),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Gap(10),
            Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    tr('Date')+": ${DateFormat("dd.MM.yyyy").format(widget.booking.startDate!.toDate())}-${DateFormat("dd.MM.yyyy").format(widget.booking.endDate!.toDate())}",
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
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                      height: 40,
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                          color: statusColorSwitch(),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tr('Status')+": ${widget.booking.status!}",
                            style: GoogleFonts.roboto(
                                fontSize: 16,
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
        navigateToDetail(widget.accommodation, widget.booking);
      },
    );
  }

  Future<String> getUser(String userId) async {
    var documentReference =
        FirebaseFirestore.instance.collection("Users").doc(userId);
    String username = "";
    await documentReference.get().then((snapshot) {
      username = UserModel.fromSnapshot(snapshot).name!;
    });
    return username;
  }

  Color statusColorSwitch() {
    if (widget.booking.status == "Finished") {
      return Colors.grey.shade600;
    } else if (widget.booking.status == "In progress") {
      return Styles.pinColor;
    } else if (widget.booking.status == "Waiting for confirmation") {
      return Colors.yellow.shade700;
    } else {
      return Colors.green.shade600;
    }
  }
}
