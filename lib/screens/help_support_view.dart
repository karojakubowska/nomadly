import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

Future launchEmail({required String toEmail}) async {
  final url = "mailto:$toEmail";

  if (await canLaunchUrl(url as Uri)) {
    await launchUrl(url as Uri);
  }
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
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
            'Help',
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
          padding: const EdgeInsets.only(left: 40, right: 40),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/email-2.png',
                height: 200,
                width: 200,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 10),
              Text(
                'Do You have a problem with \n the app or have any questions?',
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    color: const Color.fromARGB(255, 24, 24, 24),
                    fontSize: 20,
                    fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
                  onPressed: () async {
                    String email =
                        Uri.encodeComponent("nomadly@gmail.com");
                    String subject = Uri.encodeComponent("Problem with the app");
                    print(subject); //output: Hello%20Flutter
                    Uri mail =
                        Uri.parse("mailto:$email?subject=$subject");
                    if (await launchUrl(mail)) {
                      //email app opened
                    } else {
                      //email app is not opened
                    }
                  },
                  icon: const Icon(Icons.lock_open, size: 0),
                  label: const Text('Write Us', style: TextStyle(fontSize: 20)),
                ),
              ),
            ],
          ),
        ));
  }
}
