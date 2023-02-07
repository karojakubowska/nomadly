import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AllAccommodationsScreen extends StatefulWidget {
  const AllAccommodationsScreen({super.key});

  @override
  State<AllAccommodationsScreen> createState() => _AllAccommodationsScreenState();
}

class _AllAccommodationsScreenState extends State<AllAccommodationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('lista wszystkich noclegów'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}