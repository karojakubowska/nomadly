import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
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
    final locale = context.locale;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Gap(30),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Text(tr('Hello!'), style: Styles.headLineStyle),
                        SizedBox(height: 10),
                        Text(tr('What are you looking for?'), style: Styles.headLineStyle2),
                      ],
                    ),
                  ),
                ],
              ),
             
                Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 20.0, 25.0, 10.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        // side: BorderSide(
                        //   color: Colors.grey,
                        //   width: 0.5,
                        // ),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => AllAccommodationsScreen()),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: Text(
                      tr('Search place'),
                      style: GoogleFonts.roboto(
                        color: Color.fromARGB(220, 30, 30, 30),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              
              Container(
                padding: const EdgeInsets.only(top: 25, left: 30, right: 28, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(tr('Popular'), style: Styles.headLineStyle3),
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
                          ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: popularAccommodations.length,
                              itemBuilder: (context, index) {
                                Acommodation model =
                                    popularAccommodations[index];
                                return ForYouCard(
                                  accomodation: model,
                                  index: index,
                                );
                              } // }),
                              ),
                    )
                  ])),
          Container(
            padding: const EdgeInsets.only(left: 30, right: 28, bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(tr('Highest rated'), style: Styles.headLineStyle3),
                ]),
          ),
          SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: <Widget>[
                SizedBox(
                  height: 400,
                  width: size.width * 0.9,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: highestRatedAccommodations.length,
                    itemBuilder: (context, index) {
                      Acommodation model = highestRatedAccommodations[index];
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
