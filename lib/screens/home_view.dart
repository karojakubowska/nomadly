import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/all_accommodations.dart';
import 'package:nomadly_app/screens/details_view.dart';

import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'foryou_view.dart';
import 'popular_view.dart';

class HomeTest extends StatefulWidget {
  const HomeTest({super.key});

  @override
  State<HomeTest> createState() => _HomeTestState();
}

class _HomeTestState extends State<HomeTest> {
  String svg = 'assets/images/notification-svgrepo-com.svg';
  List<ForYouCard> all_accommodations = <ForYouCard>[];

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: ListView(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Gap(5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(20),
                      Text('Hello!', style: Styles.headLineStyle),
                      const Gap(20),
                      Text('What are you looking for?',
                          style: Styles.headLineStyle2),
                    ],
                  ),
                  SizedBox(
                    height: 40,
                    child: SvgPicture.asset(svg,
                        color: Colors.black, height: 40, width: 40),
                  ),
                  const Gap(10),
                ],
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 28, left: 28, right: 28),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  onChanged: (val) => (val),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    errorBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(15),
                    prefixIcon: Icon(Icons.search_outlined),
                    hintText: 'Search places',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 30, right: 28),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('For You', style: Styles.headLineStyle3),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllAccommodationsScreen()),
                          );
                        },
                        child: Text('See all', style: Styles.viewAllStyle),
                      ),
                    ]),
              )
            ],
          ),
          Gap(20),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 210,
                      width: size.width,
                      child: FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collectionGroup('Accommodations')
                              .get(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                child: Text('Loading'),
                              );
                            }
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                Acommodation model = Acommodation.fromJson(
                                    snapshot.data!.docs[index].data()
                                        as Map<String, dynamic>);
                                return ForYouCard(
                                  accomodation: model,
                                  accommodationCity: model.city!,
                                  accommodationName: model.title!,
                                  index: index,
                                );
                              },
                            );
                          }),
                    ),
                  ])),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 28),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Popular', style: Styles.headLineStyle3),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const AllAccommodationsScreen()),
                      );
                    },
                    child: Text('See all', style: Styles.viewAllStyle),
                  ),
                ]),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  PopularCard(),
                  Gap(12),
                  PopularCard(),
                ],
              )),
        ],
      ),
    );
  }

  // Future<List<Acommodation>> geta() async {
  //   List<Acommodation> a = <Acommodation>[];
  //   final QuerySnapshot result =
  //       await FirebaseFirestore.instance.collection('Accommodations').get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   documents.forEach((doc) => a.add(Acommodation.fromSnapshot(doc)));
  //   return a;
  // }

  // Future getAccomodationsList() async {
  //   var data =
  //       await FirebaseFirestore.instance.collection('Accommodations').get();
  //   all_accommodations =
  //       List.from(data.docs.map((doc) => Acommodation.fromSnapshot(doc).));
  //   return all_accommodations;
  // }

  // Future<List<ForYouCard>> getForYouCards()
  //  async {
  //   List<ForYouCard> x = <ForYouCard>[];
  //   List<Acommodation> a = <Acommodation>[];
  //   final QuerySnapshot result =
  //       await FirebaseFirestore.instance.collection('Accommodations').get();
  //   final List<DocumentSnapshot> documents = result.docs;
  //   documents.forEach((doc) => (Acommodation.fromSnapshot(doc)));

  // var _db=FirebaseFirestore.instance;
  // final result2 = await _db
  //       .collection("collectionName")
  //       .get();

  //   List<Object> toReturn = [];
  //   for (int i = 0; i < result2.docs.length; i++) {
  //    // add data to list you want to return.
  //     toReturn.add(ForYouCard(accommodationCity: result2.docs., accommodationName: accommodationName));
  //       }
  // ForYouCard fyc = ForYouCard(
  //   accommodationCity: 'Melbourne',
  //   accommodationName: 'Cottage House',
  // );
  // x.add(fyc);
  // ForYouCard fyc1 = ForYouCard(
  //   accommodationCity: 'Warsaw',
  //   accommodationName: 'Apartment',
  // );
  // x.add(fyc1);
  // ForYouCard fyc2 = ForYouCard(
  //   accommodationCity: 'Paris',
  //   accommodationName: 'House',
  // );
  // x.add(fyc2);
  //   List<ForYouCard>fyc=<ForYouCard>[];
  //   return fyc;
  // }
}
