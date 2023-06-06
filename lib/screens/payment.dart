import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/checkout.dart';

import '../utils/app_styles.dart';

class PaymentDetailsScreen extends StatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen> {
  final cardholderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expDateController = TextEditingController();
  final CVVController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: Styles.backgroundColor,
          title: Text('Payment details', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            children: [
              Image.asset('assets/images/credit-card (1) 1.png'),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: cardholderNameController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Cardholder Name',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 249, 250, 250),
                  ),
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: cardNumberController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Card Number',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 249, 250, 250),
                  ),
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: expDateController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Expires',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 249, 250, 250),
                  ),
                ),
              ),
              const Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  validator: (val) {
                    /// check if it is null empty or whitespace
                    if (val == null || val.isEmpty || val.trim().isEmpty) {
                      return "Please input card number";
                    }
                  },
                  controller: CVVController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'CVV',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 249, 250, 250),
                  ),
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const CheckoutScreen())));
                },
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 50, 134, 252)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
                  minimumSize: MaterialStateProperty.all(const Size(350, 50)),
                ),
                child: Text(
                  'Pay now',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ));
  }
}
