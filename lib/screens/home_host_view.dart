import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/accommodation_card_host.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import 'package:provider/provider.dart';

import '../utils/app_styles.dart';

class HomeHostScreen extends StatefulWidget {
  const HomeHostScreen({super.key});

  @override
  State<HomeHostScreen> createState() => _HomeHostScreenState();
}

class _HomeHostScreenState extends State<HomeHostScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    var size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        backgroundColor: Styles.backgroundColor,
        title: Text(tr('My Places'), style: Styles.headLineStyle4),
        elevation: 0,
        centerTitle: true,
      ),
      body: accommodationList.every((model) => model.host_id != currentUser)
          ? Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty-box.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(height: 20),
                    Text(
                      tr("Add your new places and rent it!"),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: const Color.fromARGB(255, 24, 24, 24),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              children: [
                Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: size.height,
                            width: size.width * 0.9,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: accommodationList.length,
                              itemBuilder: (context, index) {
                                Acommodation model = accommodationList[index];
                                if (model.host_id == currentUser) {
                                  return AccommodationCardHost(
                                    accomodation: model,
                                    index: index,
                                    host_id: currentUser,
                                  );
                                } else {
                                  return const SizedBox.shrink();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
