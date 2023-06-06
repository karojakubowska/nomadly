import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorWhileBooking extends StatelessWidget {
  const ErrorWhileBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/credit-card 1.png'),
              SizedBox(
                height: 40
              ),
              SizedBox(
                height: 70,
                width: 260,
                child: Text(
                  "Something went wrong.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 24, 24, 24),
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        )
    );
  }
}