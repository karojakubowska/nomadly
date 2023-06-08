import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_styles.dart';
import 'checkout_confirmed.dart';

class ConfirmationScreen extends StatefulWidget {
  const ConfirmationScreen({super.key});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
   @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 10)).then((value) {
        Navigator.push(context,
            MaterialPageRoute(builder: ((context) => CheckoutConfirmedScreen())));
      
    });
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        // appBar: AppBar(

        //   backgroundColor: Styles.backgroundColor,
        //   title: Text('Secure payment', style: Styles.headLineStyle4),
        //   elevation: 0,
        //   centerTitle: true,
        // ),
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
