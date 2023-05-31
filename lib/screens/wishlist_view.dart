import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'accommodation_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final userID = user!.uid;

    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: Styles.backgroundColor,
          title: Text('Wishlist', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                Container(
                  height: size.height * 0.78,
                  width: size.width * 0.9,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('Wishlists')
                        .doc(userID)
                        .collection('favs')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text("Loading...");
                      if (snapshot.data!.docs.isEmpty) {
                        return Container(
                          margin: const EdgeInsets.only(top: 20),
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
                                "Find your new favourites!",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.roboto(
                                    color:
                                        const Color.fromARGB(255, 24, 24, 24),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          //shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Accommodations')
                                    .where(FieldPath.documentId,
                                        isEqualTo: snapshot.data!.docs[index]
                                            ['accommodationId'])
                                    .snapshots(),
                                builder: (context, snap) {
                                  if (!snap.hasData)
                                    return const Text("Loading...");
                                  Acommodation model = Acommodation.fromJson(
                                      snap.data!.docs[0].data()
                                          as Map<String, dynamic>);
                                  model.id = snap.data!.docs[0].id;
                                  return AccommodationCard(
                                    accomodation: model,
                                    index: index,
                                  );
                                });
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
    //          , ])),
    // );
  }
}
// StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('Wishlists')
//                     .doc(userID)
//                     .collection('favs')
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData) return const Text("Loading...");
//                   return Column(children: [
//                     ListView.builder(
//                         scrollDirection: Axis.vertical,
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.docs.length,
//                         itemBuilder: (context, index) {
//                           //return buildListItem(context, snapshot.data.documents[index]);
//                           return ListView(
//                             scrollDirection: Axis.vertical,
//                             shrinkWrap: true,
//                             children: <Widget>[
//                               StreamBuilder<QuerySnapshot>(
//                                   stream: FirebaseFirestore.instance
//                                       .collection('Accommodations')
//                                       .where(FieldPath.documentId,
//                                           isEqualTo: snapshot.data!.docs[index]
//                                               ['accommodationId'])
//                                       .snapshots(),
//                                   builder: (context, snap) {
//                                     if (!snap.hasData)
//                                       return const Text("Loading...");
//                                     Acommodation model = Acommodation.fromJson(
//                                         snap.data!.docs[0].data()
//                                             as Map<String, dynamic>);
//                                     return AccommodationCard(
//                                       accomodation: model,
//                                       index: index,
//                                     );
//                                   }),
//                             ],
//                           );
//                         }),
//                   ]);
//                 },
//               ),
