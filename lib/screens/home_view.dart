import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/all_accommodations.dart';
import 'package:nomadly_app/screens/accommodation_details_view.dart';
import 'package:provider/provider.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'filter_screen.dart';
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
                  accommodation: accommodation,
                ))));
  }

  Query query = FirebaseFirestore.instance.collection("Accommodations");
  List<String> filters = [];
  String city = "";
  RangeValues priceRange = const RangeValues(0, 2000);
  List<Acommodation> results = [];
  int guestNumber = 0;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  //String searchText="";
  TextEditingController searchText = TextEditingController();

  void getFilter(
      List<String> currentfilters,
      RangeValues priceRangeFilter,
      String currentCity,
      List<Acommodation> resultList,
      int guests,
      DateTime start,
      DateTime end) {
    setState(() {
      filters = currentfilters;
      priceRange = priceRangeFilter;
      city = currentCity;
      results = resultList;
      guestNumber = guests;
      startDate = start;
      endDate = end;
    });
  }

  void updateQuery(Query newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    const String locationsvg = 'assets/images/location-pin-svgrepo-com.svg';
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    List<Acommodation> highestRatedAccommodations =
        getHighestRatedAccommodations(accommodationList);
    List<Acommodation> popularAccommodations =
        getPopularAccommodations(accommodationList);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      body: ListView(
        children: [
          Column(
            children: [
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Text('Hello!', style: Styles.headLineStyle),
                    SizedBox(height: 10),
                    Text('What are you looking for?', style: Styles.headLineStyle2),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: ((context) => AllAccommodationsScreen())));
                  showModalBottomSheet<dynamic>(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext bc) {
                        return FiltersScreen(
                            onApplyFilters: getFilter,
                            onQueryChanged: updateQuery,
                            currentFilters: filters,
                            currentPriceRange: priceRange,
                            currentCity: city,
                            resultList: results,
                            start: startDate,
                            end: endDate,
                            guests: guestNumber);
                      });
                },
                child: Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 28, left: 28, right: 28),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      const Gap(10),
                      const Icon(Icons.search_outlined),
                      const Gap(10),
                      Center(
                        child: Text(
                          'Search places',
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                            color: Styles.greyColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 25, left: 30, right: 28),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Highest Rated', style: Styles.headLineStyle3),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AllAccommodationsScreen()),
                          );
                        },
                        child: Text('See more', style: Styles.viewAllStyle),
                      ),
                    ]),
              )
            ],
          ),
         // const Gap(10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 10),
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
                              itemCount: highestRatedAccommodations.length,
                              itemBuilder: (context, index) {
                                Acommodation model =
                                    highestRatedAccommodations[index];
                                return ForYouCard(
                                  accomodation: model,
                                  index: index,
                                );
                              } // }),
                              ),
                    )
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
                    child: Text('See more', style: Styles.viewAllStyle),
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
                    itemCount: popularAccommodations.length,
                    itemBuilder: (context, index) {
                      Acommodation model = popularAccommodations[index];
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

  List<Acommodation> getPopularAccommodations(
      List<Acommodation> allAccommodations) {
    List<Acommodation> result = [];
    if (allAccommodations.isNotEmpty) {
      allAccommodations
          .sort((a, b) => b.reservationsCount!.compareTo(a.reservationsCount!));
      for (int i = 0; i < allAccommodations.length && i < 3; i++) {
        result.add(allAccommodations[i]);
      }
    } else {
     // print("List is empty. Cannot find maximum objects.");
    }
    return result;
  }

  List<Acommodation> getHighestRatedAccommodations(
      List<Acommodation> allAccommodations) {
    List<Acommodation> result = [];
    result = allAccommodations
        .where((accommodation) => accommodation.rate! >= 4.7)
        .toList();
    return result;
  }
}
