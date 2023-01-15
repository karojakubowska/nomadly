import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../utils/app_layout.dart';
import '../utils/app_styles.dart';

class PopularCard extends StatelessWidget {
  const PopularCard({super.key});

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Container(
      width: size.width * 0.8,
      height: 90,
      //padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      //margin: const EdgeInsets.only(top: 0, right: 4),
      decoration: BoxDecoration(
        color: Styles.whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(left: 5, right: 10),
            height: 65,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: const DecorationImage(
                    image: AssetImage(
                        "assets/images/eiffel-tower-in-paris-with-gorgeous-colors 1.png"))),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Paris",
                style: Styles.popularNameStyle,
              ),
              Text("01.01.2023-08.01.2023", style: Styles.popularDateStyle)
            ],
          ),
        ],
      ),
    );
    // final size = AppLayout.getSize(context);
    // return SizedBox(
    //   width: size.width,
    //   height: 80,
    //   child: Container(
    //       padding: const EdgeInsets.all(16),
    //       child: Row(
    //         children: [
    //           Container(
    //             decoration: BoxDecoration(
    //                 borderRadius: BorderRadius.circular(12),
    //                 image: const DecorationImage(
    //                     image: AssetImage(
    //                         "assets/images/eiffel-tower-in-paris-with-gorgeous-colors 1.png"))),
    //           ),
    //           const Gap(60),
    //         ],
    //       )),
    // );
  }
}
