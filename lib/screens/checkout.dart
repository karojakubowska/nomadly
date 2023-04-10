import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/app_styles.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        //leading: BackButton(color: Colors.black),
        backgroundColor: Styles.backgroundColor,
        title: Text('Secure payment', style: Styles.headLineStyle4),
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}