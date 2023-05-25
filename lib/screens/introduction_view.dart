
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../main.dart';
import '../utils/app_styles.dart';


class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        PageViewModel(
          title:"Instruction 1",
          body:"Finding new possibilities in excellent traveling",
          image: Image.asset("assets/images/intro_photo.png",
          height: 1200,width:1200 ,fit: BoxFit.cover,),
          decoration: buildDecoration(),
          

        ),
         PageViewModel(
          title:"Instruction 2",
          body:"",
          decoration: buildDecoration(),


        ),
         PageViewModel(
          title:"Instruction 3",
          body:"",
          decoration: buildDecoration(),


        )
      ],
      next: Icon(Icons.navigate_next, size: 40, color: Styles.greyColor,),
      done: Text('Done', style: Styles.headLineStyle2),
      onDone: () => goToAuthPage(context),
      showSkipButton: true,
      skip: Text('Skip', style: Styles.headLineStyle2,), //by default, skip goes to the last page
      onSkip: () => goToAuthPage(context),
      dotsDecorator: getDotsDecoration(),
      animationDuration: 1000,
      globalBackgroundColor: Colors.grey.shade100,
    );
  }
    DotsDecorator getDotsDecoration() => DotsDecorator(
      color: Colors.grey,
      size: const Size(10,10),
      activeColor: Colors.grey.shade800,
      activeSize: const Size(22,10),
      activeShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      )

  );
    PageDecoration buildDecoration() => PageDecoration(
    titleTextStyle: Styles.headLineStyle,
    bodyTextStyle: Styles.headLineStyle2,
    pageColor: Colors.grey.shade100,
    imagePadding: const EdgeInsets.all(0),
  );
    Widget buildImage(String path) => Center(
      child: Image.asset(path)
  );

  void goToAuthPage(BuildContext context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()));
}