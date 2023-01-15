import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/app_layout.dart';

class WishlistCard extends StatefulWidget {
  const WishlistCard({super.key});

  @override
  State<WishlistCard> createState() => _WishlistCardState();
}

class _WishlistCardState extends State<WishlistCard> {
  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return SizedBox(
        width: size.width,
        height: 200,
        child: Container(
            child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Image.asset(
                          "assets/images/a-modern-living-room-style 2.png"),
                    ],
                  )
                ],
              ),
            ),
          ],
        )));
  }
}
