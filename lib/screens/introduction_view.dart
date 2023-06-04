import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../main.dart';
import '../utils/app_styles.dart';

class IntroPage extends StatelessWidget {
   IntroPage({super.key});

   final TextStyle customTitleTextStyle = TextStyle(
     fontFamily: "Roboto",
     fontSize: 45,
     fontWeight: FontWeight.w400,
   );

   final TextStyle customBodyTextStyle = TextStyle(
     fontFamily: "Roboto",
     fontSize: 25,
     fontWeight: FontWeight.w300,
     color: Colors.grey.shade500,
   );

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    final screenHeight = MediaQuery.of(context).size.height;
    final imageHeight = screenHeight ; // 75% wysokości ekranu

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: tr("Let's Enjoy Your Dream Vacation!"),
          body: tr("Finding new possibilities in excellent traveling"),
          image: Image.asset(
            "assets/images/intro.jpg",
            height: 1000.0,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          decoration: buildDecoration(),
        ),
         PageViewModel(
          title: tr("Book Your Dream Room or Apartment!"),
          body: tr("Find the perfect accommodation and enjoy comfort"),
           image: Image.asset(
             "assets/images/home.jpg",
             height: double.infinity,
             width: double.infinity,
             fit: BoxFit.cover,
           ),
          decoration: buildDecoration(),
        ),
         PageViewModel(
          title: tr("Create Your Unforgettable Journey!"),
          body: tr("Explore the world by planning your own adventures and experiences"),
           image: Image.asset(
             "assets/images/journey.jpg",
             height: double.infinity,
             width: double.infinity,
             fit: BoxFit.cover,
           ),
          decoration: buildDecoration(),
        )
      ],
      next: Icon(Icons.navigate_next, size: 40, color: Styles.greyColor),
      done: Text(tr('Done'), style: Styles.headLineStyle2),
      onDone: () => goToAuthPage(context),
      showSkipButton: true,
      skip: Text(tr('Skip'), style: Styles.headLineStyle2,), //by default, skip goes to the last page
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
    titleTextStyle: customTitleTextStyle,
    bodyTextStyle: customBodyTextStyle,
    pageColor: Colors.grey.shade100,
    imagePadding: const EdgeInsets.all(0),
  );
    Widget buildImage(String path) => Center(
      child: Image.asset(path)
  );

  void goToAuthPage(BuildContext context) => Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()));
}