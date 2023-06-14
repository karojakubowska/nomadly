import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/booking_request_view.dart';
import 'package:nomadly_app/screens/calendar.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';
import 'package:nomadly_app/screens/reviews_view.dart';

class DetailScreen extends StatefulWidget {
  final Acommodation? accommodation;
  DateTime? start_date;
  DateTime? end_date;
  int? guest_number;

  DetailScreen(
      {this.accommodation, this.start_date, this.guest_number, this.end_date});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  int guestNumber = 2;
  List<String> photoUrls = [];
  String id = "";

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    id = FirebaseAuth.instance.currentUser!.uid.toString();
  }

  void getDates(DateTime start, DateTime end, int guests) {
    setState(() {
      widget.start_date = start;
      widget.end_date = end;
      widget.guest_number = guests;
    });
  }

  navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => ReviewScreen(
                accommodationId: accommodation.id!,
                rate: accommodation.rate!.toDouble()))));
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
        .where('accommodationId', isEqualTo: widget.accommodation?.id)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                FutureBuilder(
                  future: FirebaseStorage.instance
                      .refFromURL((widget.accommodation!.photo!))
                      .getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Image(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        image: NetworkImage(snapshot.data.toString()),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Container(
                  height: 400,
                  color: Colors.black12,
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(
                          left: 24,
                          right: 24,
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                child: const Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30))),
                        height: 30,
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.accommodation!.title!,
                          style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 24, 24, 24),
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("Wishlists")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection("favs")
                            .where("accommodationId",
                                isEqualTo: widget.accommodation?.id)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.data == null) return Text(tr("No data"));
                          return IconButton(
                            onPressed: () async {
                              snapshot.data!.docs.length == 0
                                  ? await addToFavorites(
                                      widget.accommodation!.id.toString())
                                  : deleteFromFavorites(
                                      widget.accommodation!.id.toString());
                            },
                            icon: snapshot.data!.docs.length == 0
                                ? Icon(Icons.favorite_border_outlined,
                                    size: 30) // Increase the size to 30
                                : Icon(Icons.favorite,
                                    size: 30), // Increase the size to 30
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        "${widget.accommodation!.city!},",
                        style: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 24, 24, 24),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(width: 1),
                      Text(
                        widget.accommodation!.country!,
                        style: GoogleFonts.roboto(
                          color: const Color.fromARGB(255, 24, 24, 24),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const Gap(10),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 7, left: 7, top: 4, bottom: 4),
                            child: Text(
                              " ${widget.accommodation?.bedroom?.toString() ?? '0'} " +
                                  tr("bedroom"),
                              textAlign: TextAlign.start,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 1.6,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 7, left: 7, top: 4, bottom: 4),
                            child: Text(
                              " ${widget.accommodation?.bed?.toString() ?? '0'} " +
                                  tr("bed"),
                              textAlign: TextAlign.start,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 1.6,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                right: 7, left: 7, top: 4, bottom: 4),
                            child: Text(
                              " ${widget.accommodation?.bathroom?.toString() ?? '0'} " +
                                  tr("bathroom"),
                              textAlign: TextAlign.start,
                              style: GoogleFonts.roboto(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                                height: 1.6,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Gap(15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          navigateToDetail(widget.accommodation!);
                        },
                        child: Row(
                          children: [
                            Container(
                              height: 40,
                              width: 70,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 50, 134, 252),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  Text(
                                    widget.accommodation!.rate!.toString(),
                                    style: GoogleFonts.roboto(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(10),
                            Text(
                              "(${widget.accommodation!.reviews.toString()} " +
                                  tr("reviews") +
                                  ")",
                              style: GoogleFonts.roboto(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${widget.accommodation!.price_per_night!}/" +
                            tr("night"),
                        style: GoogleFonts.roboto(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const Gap(20),
                  Text(
                    tr("Description"),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  Text(
                    widget.accommodation!.description!,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 135, 135, 135),
                      height: 1.6,
                      letterSpacing: .5,
                    ),
                  ),
                  const Gap(20),
                  Text(
                    tr("Additional Information"),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "- " +
                        tr("Kitchen") +
                        ": ${widget.accommodation?.kitchen == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "- " +
                        tr("TV") +
                        ": ${widget.accommodation?.tv == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "- " +
                        tr("Wifi") +
                        ": ${widget.accommodation?.wifi == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  const Gap(10),
                  Text(
                    "- " +
                        tr("Air Conditioning") +
                        ": ${widget.accommodation?.air_conditioning == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  const Gap(20),
                  Text(
                    tr("Images"),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ),
                  ),
                  const Gap(10),
                ],
              ),
            ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              child: FutureBuilder<List<dynamic>>(
                future: Future.wait(
                  widget.accommodation!.photoUrl!.map((photo) => FirebaseStorage
                      .instance
                      .refFromURL(photo)
                      .getDownloadURL()),
                ),
                builder: (BuildContext context,
                    AsyncSnapshot<List<dynamic>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    List<String> photoUrls =
                        snapshot.data?.cast<String>() ?? [];
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 120,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children:
                                    List.generate(photoUrls.length, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Dialog(
                                            child: InteractiveViewer(
                                              panEnabled: true,
                                              minScale: 0.5,
                                              maxScale: 4.0,
                                              child: Image.network(
                                                  photoUrls[index]),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          right: 10, bottom: 10),
                                      width: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(photoUrls[index]),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text(tr('No data available'));
                  }
                },
              ),
            ),
            const Gap(10),
            if (widget.start_date != null && widget.end_date != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr("Selected date:"),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(200, 32, 32, 32),
                    ),
                  ),
                  Gap(10),
                  Text(
                      DateFormat.yMMMMd(tr('en_US'))
                          .format(widget.start_date!)
                          .toString(),
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(200, 32, 32, 32),
                      )),
                  const SizedBox(width: 10),
                  Text("-"),
                  const SizedBox(width: 10),
                  Text(
                    DateFormat.yMMMMd(tr('en_US'))
                        .format(widget.end_date!)
                        .toString(),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(200, 32, 32, 32),
                    ),
                  ),
                ],
              ),
              const Gap(10),
            ] else ...[
              Container()
            ],
            const Gap(5),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(tr('Number of people') + ": ", style: GoogleFonts.roboto(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color.fromARGB(200, 32, 32, 32),
                  ),),
                  if (widget.guest_number == null)
                    ...[
                      Text('1', style: GoogleFonts.roboto(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(200, 32, 32, 32))),
                    ]
                  else
                    ...[
                      Text('${widget.guest_number}', style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(200, 32, 32, 32)))
                    ]
                ],
              ),
            ),
            const Gap(10),
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return CalendarScreen(
                          bookedDates: widget.accommodation!.bookedDates!,
                          onChooseDate: getDates,
                          startDate: widget.start_date,
                          endDate: widget.end_date,
                        );
                      });
                },
                child: Container(
                  padding: const EdgeInsets.only(
                      left: 110, right: 110, top: 15, bottom: 15),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color.fromARGB(200, 32, 32, 32),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tr("Choose dates"),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(200, 32, 32, 32),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(
                  left: 50, right: 50, top: 15, bottom: 15),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
                onPressed: () {
                  if (widget.start_date == null && widget.end_date == null) {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              title: Text(tr('Error')),
                              content: Text(tr('No dates selected.')),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);

                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CalendarScreen(
                                            bookedDates: widget
                                                .accommodation!.bookedDates!,
                                            onChooseDate: getDates,
                                            startDate: widget.start_date,
                                            endDate: widget.end_date,
                                          );
                                        });
                                  },
                                  child: const Text('OK'),
                                ),
                              ]);
                        });
                  } else {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => BookingRequestScreen(
                                  startDate: widget.start_date!,
                                  endDate: widget.end_date!,
                                  guestNumber: widget.guest_number!,
                                  accommodation: widget.accommodation!,
                                ))));
                  }
                },
                icon: const Icon(Icons.lock_open, size: 0),
                label: Text(tr('Book now'), style: TextStyle(fontSize: 18)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatSingleView(
                      userId: id,
                      otherUserId: widget.accommodation!.host_id!,
                    ),
                  ),
                );
              },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor:
                MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    side: const BorderSide(
                        color: Color.fromARGB(255, 50, 134, 252),
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10))),
                minimumSize:
                MaterialStateProperty.all(const Size(320, 50)),
              ),
              child: Text(
                tr('Contact with host'),
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 50, 134, 252),
                        fontWeight: FontWeight.w700)),
              ),
            ),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
