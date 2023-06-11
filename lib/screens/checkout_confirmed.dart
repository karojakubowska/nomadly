import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/all_bookings_view.dart';
import 'package:nomadly_app/screens/home_view.dart';

import '../utils/app_styles.dart';

class CheckoutConfirmedScreen extends StatefulWidget {
  const CheckoutConfirmedScreen({super.key});

  @override
  State<CheckoutConfirmedScreen> createState() => _CheckoutConfirmedScreenState();
}

class _CheckoutConfirmedScreenState extends State<CheckoutConfirmedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                child: Column(
              children: [
                Image.asset('assets/images/check 1.png'),
                const Gap(30),
                Text(
                  tr("Booking confirmed!"),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 24, 24, 24),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )),
            ElevatedButton(
              onPressed: () {   Navigator.popUntil(
          context, (HomeTest) => HomeTest.isFirst);
   
      },
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 50, 134, 252)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
                minimumSize: MaterialStateProperty.all(const Size(180, 50)),
              ),
              child: Text(
                tr('Back to home'),
                style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
