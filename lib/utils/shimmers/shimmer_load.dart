import 'package:flutter/material.dart';

class ShimmerLoad extends StatelessWidget {
  final  double width,height;
  const ShimmerLoad({super.key,required this.height,required this.width});
  

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color:Colors.black.withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(12))
        ),
    );
  }
}