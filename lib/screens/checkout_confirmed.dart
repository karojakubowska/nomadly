import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_styles.dart';

class CheckoutConfirmedScreen extends StatelessWidget {
  const CheckoutConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        //  leading: BackButton(color: Colors.black),
        backgroundColor: Styles.backgroundColor,
        title: Text('Secure payment', style: Styles.headLineStyle4),
        elevation: 0,
        centerTitle: true,
      ),
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
                  "Booking confirmed!",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      color: const Color.fromARGB(255, 24, 24, 24),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ],
            )),
            ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor: MaterialStateProperty.all<Color>(
                    const Color.fromARGB(255, 50, 134, 252)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
                minimumSize: MaterialStateProperty.all(const Size(180, 50)),
              ),
              child: Text(
                'Go to my bookings',
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
