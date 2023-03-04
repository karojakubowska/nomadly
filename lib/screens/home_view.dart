import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/all_accommodations.dart';
import 'package:nomadly_app/screens/details_view.dart';
import 'package:provider/provider.dart';
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
  late Future<QuerySnapshot<Object>> accommodations;
  navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => DetailScreen(
                  acommodation: accommodation,
                ))));
  }

  @override
  void initState() {
    accommodations = fetchAccommodations();
    super.initState();
  }

  Future<QuerySnapshot<Object>> fetchAccommodations() async {
    var value =
        FirebaseFirestore.instance.collectionGroup('Accommodations').get();
    return value;
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    final String locationsvg = 'assets/images/location-pin-svgrepo-com.svg';
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
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
                        child:
                            //  FutureBuilder<QuerySnapshot>(
                            //     future: accommodations,
                            //     builder: (context, snapshot) {
                            //       if (snapshot.data == null) {
                            //         return const Center(
                            //           child: Text('Loading'),
                            //         );
                            //       }

                            // return
                            ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: accommodationList.length,
                          itemBuilder: (context, index) {
                            Acommodation model = accommodationList[index];
                            return ForYouCard(
                                accomodation: model, index: index);
                          },
                        )
                        // }),
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
              child: Column(children: <Widget>[
                SizedBox(
                  height: 210,
                  width: size.width * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: accommodationList.length,
                    itemBuilder: (context, index) {
                      Acommodation model = accommodationList[index];
                      return PopularCard(
                        accomodation: model,
                        accommodationCity: model.city!,
                        accommodationName: model.title!,
                        index: index,
                        accommodationPhoto: model.photo!,
                      );
                    },
                    //);
                  ),
                ),
              ])),
        ],
      ),
    );
  }
}
