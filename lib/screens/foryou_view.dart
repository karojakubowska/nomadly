
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class ForYouCard extends StatelessWidget {
  final String locationsvg = 'assets/images/location-pin-svgrepo-com.svg';

  ForYouCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Container(
      width: size.width * 0.4,
      height: 190,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      margin: const EdgeInsets.only(top: 0, right: 4),
      decoration: BoxDecoration(
        color: Styles.backgroundColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: 130,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                    image: AssetImage(
                        "assets/images/beautiful-view-of-a-blue-lake-captured-from-the-inside-of-a-villa 1.png"))),
          ),
          const Gap(3),
          Container(
            color: Styles.backgroundColor,
            margin: const EdgeInsets.only(left: 20),
            child: Text("Little House", style: Styles.houseNameStyle),
          ),
          Container(
            padding: const EdgeInsets.only(left:20,top:3),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: SvgPicture.asset(locationsvg,
                        color: Styles.pinColor, height: 15, width: 15),
                  ),
                  const TextSpan(
                    text: "Ottawa",
                    style: TextStyle(color: Colors.blue),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
