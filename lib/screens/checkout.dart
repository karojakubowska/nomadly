import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_styles.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
        
          backgroundColor: Styles.backgroundColor,
          title: Text('Secure payment', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/images/credit-card 1.png'),
              SizedBox(
                height: 65,
                width: 260,
                child: Text(
                  "We are confirming your booking...",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 24, 24, 24),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ));
  }
}
