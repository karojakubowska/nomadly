import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/booking_request_view.dart';
import 'package:nomadly_app/screens/calendar.dart';
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
  //  DateTime startDate = DateTime.now();
  // DateTime endDate = DateTime.now();
  int guestNumber = 2;
  List<String> photoUrls = []; // Lista URL-ów zdjęć
  void getDates(DateTime start, DateTime end) {
    setState(() {
      widget.start_date = start;
      widget.end_date = end;
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
                  Text(
                    widget.accommodation!.title!,
                    style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 24, 24, 24),
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.accommodation!.city!},",
                        style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 24, 24, 24),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        width: 1,
                      ),
                      Text(
                        widget.accommodation!.country!,
                        style: GoogleFonts.roboto(
                            color: const Color.fromARGB(255, 24, 24, 24),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
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
                              " ${widget.accommodation?.bedroom?.toString() ?? '0'} "+tr("bedroom"),
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
                              " ${widget.accommodation?.bed?.toString() ?? '0'} "+tr("bed"),
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
                              " ${widget.accommodation?.bathroom?.toString() ?? '0'} "+tr("bathroom"),
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
                                        BorderRadius.all(Radius.circular(8))),
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
                                          color: Colors.white),
                                    ),
                                  ],
                                )),
                            const Gap(10),
                            Text(
                              "(${widget.accommodation!.reviews.toString()} "+tr("reviews")+")",
                              style: GoogleFonts.roboto(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "\$${widget.accommodation!.price_per_night!}/"+tr("night"),
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
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
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  Text(
                    widget.accommodation!.description!,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 135, 135, 135),
                        height: 1.6,
                        letterSpacing: .5),
                  ),
                  const Gap(20),
                  Text(
                    tr("Additional Information"),
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  const Gap(10),
                  Text(
                    "- "+ tr("Kitchen") +": ${widget.accommodation?.kitchen == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  const Gap(10),
                  Text(
                    "- "+ tr("TV") +": ${widget.accommodation?.tv == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  const Gap(10),
                  Text(
                    "- "+ tr("Wifi") +": ${widget.accommodation?.wifi == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  const Gap(10),
                  Text(
                    "- "+ tr("Air Conditioning") +": ${widget.accommodation?.air_conditioning == true ? tr('Yes') : tr('No')}",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: const Color.fromARGB(255, 135, 135, 135)),
                  ),
                  const Gap(20),
                ],
              ),
            ),
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
                    // Dodajemy URL-e do listy photoUrls
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //height: 100,
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
                                              // Wyłącz możliwość przesuwania obrazu
                                              minScale: 0.5,
                                              // Minimalne przybliżenie
                                              maxScale: 4.0,
                                              // Maksymalne przybliżenie
                                              child: Image.network(
                                                  photoUrls[index]),
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 10),
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
            GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext context) {
                        return CalendarScreen(
                          bookedDates: widget.accommodation!.bookedDates!,
                          onChooseDate: getDates,
                        );
                      });
                },
                child: Text("Choose dates",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color.fromARGB(255, 135, 135, 135),
                    ))),
            if (widget.start_date != null && widget.end_date != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      DateFormat.yMMMMd('en_US')
                          .format(widget.start_date!)
                          .toString(),
                      textAlign: TextAlign.start,
                      style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(255, 135, 135, 135),
                      )),
                       const SizedBox(
                width: 10,
              ),
              Text(
                DateFormat.yMMMMd('en_US').format(widget.end_date!).toString(),
                textAlign: TextAlign.start,
                style: GoogleFonts.roboto(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 135, 135, 135),
                ),
              ),
                ],
              ),
             
            ] else ...[
              Container()
            ],
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
                onPressed: () {
                  if (widget.guest_number == null) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => BookingRequestScreen(
                                  startDate: widget.start_date!,
                                  endDate: widget.end_date!,
                                  guestNumber: guestNumber,
                                  accommodation: widget.accommodation!,
                                ))));
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
                label: Text( tr('Book now'), style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
