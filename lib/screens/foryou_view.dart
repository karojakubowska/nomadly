import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/accommodation_details_view.dart';
import '../utils/shimmers/shimmer_load.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class ForYouCard extends StatefulWidget {
  final Acommodation accomodation;
  final int index;

  const ForYouCard({super.key, required this.accomodation, required this.index});

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
                  accommodation: accommodation,
                ))));
  }

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
                  .refFromURL(widget.accomodation.photo!)
                  .getDownloadURL(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    height: 120,
                    width: 110,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(snapshot.data.toString()),
                          fit: BoxFit.cover,
                        )),
                  );
                } else {
                  return const Center(
                      child: ShimmerLoad(height: 120, width: 110));
                }
              },
            ),
            const Gap(8),
            Container(
              color: Styles.backgroundColor,
              margin: const EdgeInsets.only(left: 15),
              child: Text(widget.accomodation.title!,
                  style: Styles.houseNameStyle),
            ),
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
                      text: widget.accomodation.city,
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
