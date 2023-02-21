import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/details_view.dart';
import 'package:nomadly_app/services/accommodation_provider.dart';
import 'package:provider/provider.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class ForYouCard extends StatefulWidget {
  Acommodation accomodation;
  String accommodationName = '';
  String accommodationCity = '';
  String accommodationPhoto = '';
  int index;

  ForYouCard(
      {required this.accomodation,
      required this.accommodationCity,
      required this.accommodationName,
      required this.accommodationPhoto,
      required this.index});

  @override
  State<ForYouCard> createState() => _ForYouCardState();
}

class _ForYouCardState extends State<ForYouCard> {
  final String locationsvg = 'assets/images/location-pin-svgrepo-com.svg';
  late Future<String> photoPath;
  
  navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => DetailScreen(
                  acommodation: accommodation,
                ))));
  }

// @override
//   void initState() {
//     photoPath = fetchPhotoPath();
//     super.initState();
//   }
//   Future<String> fetchPhotoPath() async {
//     var value =
//          FirebaseStorage.instance
//                   .refFromURL(widget.accommodationPhoto)
//                   .getDownloadURL();
//     return value;
//   }
  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    Future<String> photoPath;
    //var _imageLocation = Provider.of<String>(context);
    return InkWell(
      child: Container(
        width: size.width * 0.35,
        height: 170,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        margin: const EdgeInsets.only(top: 0, right: 4),
        decoration: BoxDecoration(
          color: Styles.backgroundColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: FirebaseStorage.instance
                  .refFromURL(widget.accommodationPhoto)
                  .getDownloadURL(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 120,
                    width: 110,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          //  image: AssetImage(
                          // "assets/images/beautiful-view-of-a-blue-lake-captured-from-the-inside-of-a-villa 1.png")
                          image: NetworkImage(snapshot.data.toString()),
                         fit: BoxFit.cover,
                        )),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
            const Gap(8),
            Container(
              color: Styles.backgroundColor,
              margin: const EdgeInsets.only(left: 15),
              child:
                  Text(widget.accommodationName, style: Styles.houseNameStyle),
            ),
            // Container(
            //   color: Styles.backgroundColor,
            //   margin: const EdgeInsets.only(left: 20),
            //   child:
            //       Text(widget.index.toString(), style: Styles.houseNameStyle),
            // ),
            Container(
              padding: const EdgeInsets.only(left: 20, top: 3),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      child: SvgPicture.asset(locationsvg,
                          color: Styles.pinColor, height: 15, width: 15),
                    ),
                    TextSpan(
                      text: widget.accommodationCity,
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
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
