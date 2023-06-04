import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          tr('Privacy Policy'),
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.all(20.0),
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Text(
'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut lacus eros, egestas vel enim eget, tincidunt cursus elit. Praesent non augue a justo mattis mollis vitae et erat. Maecenas leo mi, efficitur quis tempus sed, tempus cursus enim. Phasellus venenatis sed odio sit amet posuere. Phasellus vel luctus nisl. Praesent convallis at mi ut tincidunt. Cras molestie, lacus eget iaculis rutrum, dolor velit posuere mauris, tempor vulputate nunc leo at mauris. In ornare nunc nunc, a gravida tellus dapibus a. Nullam fermentum vestibulum dolor, in convallis urna vehicula eu. Curabitur tortor leo, convallis vel ullamcorper id, mattis in eros. Curabitur mauris lorem, porttitor id ipsum nec, feugiat pulvinar lectus. Aliquam erat volutpat. Donec ultrices hendrerit purus, quis iaculis nibh vehicula eget. Donec sit amet orci iaculis, egestas lectus sed, rhoncus nisl. Duis sagittis mi vel dui viverra, tristique laoreet tortor tempus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut lacus eros, egestas vel enim eget, tincidunt cursus elit. Praesent non augue a justo mattis mollis vitae et erat.',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 18.0,
                  height: 1.5,
                  color: Colors.black,
                  fontWeight: FontWeight.w400)),
        ),
      ),
    );
  }
}
