import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/home_view.dart';
import 'package:nomadly_app/utils/app_layout.dart';

import '../utils/app_styles.dart';

class DetailScreen extends StatefulWidget {
  final Acommodation? acommodation;
  DetailScreen({this.acommodation});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('     Book now     ',
            style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        backgroundColor: Color.fromARGB(255, 50, 134, 252),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                FutureBuilder(
                  future: FirebaseStorage.instance
                      .refFromURL((widget.acommodation!.photo!))
                      .getDownloadURL(),
                  builder: (BuildContext context,
                      AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Image(
                        height: 400,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.cover,
                        image: NetworkImage(snapshot.data.toString()),
                      );
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Container(
                  height: 400,
                  color: Colors.black12,
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
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
                                child: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40))),
                        height: 40,
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.acommodation!.title!,
                    style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 24, 24, 24),
                        fontSize: 22,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.acommodation!.city!},",
                        style: GoogleFonts.roboto(
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        widget.acommodation!.country!,
                        style: GoogleFonts.roboto(
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  Gap(20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          height: 40,
                          width: 70,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 50, 134, 252),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 25,
                              ),
                              Text(
                                widget.acommodation!.rate!.toString(),
                                style: GoogleFonts.roboto(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                      Text(
                        "\$${widget.acommodation!.price_per_night!}/night",
                        style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      )
                    ],
                  ),
                  Gap(20),
                  Text(
                    "Description",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color.fromARGB(255, 135, 135, 135)),
                  ),
                  Text(
                    widget.acommodation!.description!,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 135, 135, 135),
                        height: 1.6,
                        letterSpacing: .5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
