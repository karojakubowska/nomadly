import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    final currentUser = FirebaseAuth.instance.currentUser?.uid;
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: Styles.backgroundColor,
          title: Text('My Places', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: size.height * 0.78,
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
                              return const SizedBox.shrink(); // pusta przestrzeń
                            }
                          },
                        ),
                      ),
                    ])),
              ],
            ),
          ],
        ));
  }
}
