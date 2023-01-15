import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';

import '../main.dart';
import '../utils/app_styles.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    //   return Scaffold(
    //     backgroundColor: Styles.backgroundColor,
    //     appBar: AppBar(
    //       leading: BackButton(color: Colors.black),
    //       backgroundColor: Styles.backgroundColor,
    //       title: Text('Wishlist', style: Styles.headLineStyle4),
    //       elevation: 0,
    //       centerTitle: true,
    //     ),
    //     body: Column(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         const Gap(70),
    //         SingleChildScrollView(
    //             scrollDirection: Axis.vertical,
    //             child: Column(
    //               children: [],
    //             ))
    //       ],
    //     ),
    //   );
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
          onPressed: _signOut,
          icon: const Icon(Icons.lock_open, size: 0),
          label: const Text('Log out', style: TextStyle(fontSize: 24)),
        )
      ],
    );
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }
}
