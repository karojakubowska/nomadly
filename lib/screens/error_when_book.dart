import 'package:flutter/material.dart';

class ErrorWhileBooking extends StatelessWidget {
  const ErrorWhileBooking({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Nie udało się zarezerwować :(((")),
    );
  }
}