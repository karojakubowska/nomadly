import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/screens/accommodation_card.dart';
import 'package:nomadly_app/screens/filter_screen.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../utils/app_styles.dart';

class AllAccommodationsScreen extends StatefulWidget {
  const AllAccommodationsScreen({super.key});

  @override
  State<AllAccommodationsScreen> createState() =>
      _AllAccommodationsScreenState();
}

class _AllAccommodationsScreenState extends State<AllAccommodationsScreen> {
  Query query = FirebaseFirestore.instance.collection("Accommodations");
  List<String> filters = [];
  String city = "";
  RangeValues priceRange = const RangeValues(0, 2000);
  List<Acommodation> results = [];
  int guest_number = 1;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  String infoMessage = "";
  TextEditingController searchText = TextEditingController();

  void getFilter(
      List<String> currentfilters,
      RangeValues priceRangeFilter,
      String currentCity,
      List<Acommodation> resultList,
      int guests,
      DateTime start,
      DateTime end,
      String info) {
    setState(() {
      filters = currentfilters;
      priceRange = priceRangeFilter;
      city = currentCity;
      results = resultList;
      guest_number = guests;
      startDate = start;
      endDate = end;
      infoMessage = info;
    });
  }

  void updateQuery(Query newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);

    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Styles.backgroundColor,
          title: Text(tr('Accommodations'), style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const Gap(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
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
                                guests: guest_number,
                                infoMessage: infoMessage,
                              );
                            });
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: <Widget>[
                            const Gap(10),
                            const Icon(Icons.search_outlined),
                            Container(
                              width: size.width * 0.7,
                              child: Text(
                                tr('  Search places'),
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w400,
                                  color: Styles.greyColor,
                                ),
                              ),
                            ),
                            const Gap(10),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Gap(30),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      if (results.isEmpty) ...[
                        Text(infoMessage),
                        SizedBox(
                            height: size.height * 0.78,
                            width: size.width * 0.9,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: accommodationList.length,
                                itemBuilder: (context, index) {
                                  Acommodation model = accommodationList[index];
                                  return AccommodationCard(
                                    accomodation: model,
                                    index: index,
                                  );
                                }))
                      ] else
                        SizedBox(
                            height: size.height * 0.78,
                            width: size.width * 0.9,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: results.length,
                                itemBuilder: (context, index) {
                                  Acommodation model = results[index];
                                  return AccommodationCard(
                                    accomodation: model,
                                    index: index,
                                    start_date: startDate,
                                    end_date: endDate,
                                    guest_number: guest_number,
                                  );
                                }))
                    ])),
              ],
            ),
          ],
        ));
  }
}
