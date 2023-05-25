import 'package:cloud_firestore/cloud_firestore.dart';
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
 int guest_number=0;
   DateTime  startDate=DateTime.now();
   DateTime endDate=DateTime.now();
  //String searchText="";
  TextEditingController searchText = TextEditingController();

  void getFilter(List<String> currentfilters, RangeValues priceRangeFilter,
      String currentCity, List<Acommodation> resultList,int guests,DateTime start,DateTime end) {
    setState(() {
      filters = currentfilters;
      priceRange = priceRangeFilter;
      city = currentCity;
      results = resultList;
      guest_number=guests;
       startDate=start;
      endDate=end;
    });
  }

  void updateQuery(Query newQuery) {
    setState(() {
      query = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> searchStream = FirebaseFirestore.instance
        .collection('Accommodations')
        .where(
          'city',
          isEqualTo: searchText.text,
        )
        .snapshots();
    List<Stream<QuerySnapshot>> combineList = [searchStream, query.snapshots()];
    var totalRef = CombineLatestStream.list(combineList);

    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: const BackButton(color: Colors.black),
          backgroundColor: Styles.backgroundColor,
          title: Text('Hotels', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const Gap(20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Container(
                    //   height: 50,
                    //   width: size.width * 0.7,
                    //   decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10)),
                    //   child: TextField(
                    //     controller: searchText,
                    //     onChanged: (val) => setState(() {
                    //       // query = query.where(
                    //       //   'city',
                    //       //   isEqualTo: searchText.text,
                    //      // );
                    //     }),
                    //     decoration: const InputDecoration(
                    //       border: InputBorder.none,
                    //       errorBorder: InputBorder.none,
                    //       enabledBorder: InputBorder.none,
                    //       focusedBorder: InputBorder.none,
                    //       contentPadding: EdgeInsets.all(15),
                    //       prefixIcon: Icon(Icons.search_outlined),
                    //       hintText: 'Search places',
                    //     ),
                    //   ),
                    // ),
                    //  GestureDetector(
                    //     onTap: () {
                    //       showModalBottomSheet<dynamic>(
                    //           backgroundColor: Colors.transparent,
                    //           isScrollControlled: true,
                    //           context: context,
                    //           builder: (BuildContext bc) {
                    //             return SearchBarScreen(
                    //               onQueryChanged: updateQuery,
                    //             );
                    //           });
                    //     },
                    //      child: Container(
                    //       height: 50.0,
                    //       width: 50.0,
                    //       decoration: BoxDecoration(
                    //           color: Styles.pinColor,
                    //           borderRadius: BorderRadius.circular(10)),
                    //       child: Center(
                    //         child: SvgPicture.asset(
                    //           "assets/images/sliders.svg",
                    //           color: Colors.white,
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     )),
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
                                    start: startDate ,
                                    end:endDate ,
                                    guests:guest_number);
                              });
                        },
                        child: Container(
                          height: 50.0,
                          width: 50.0,
                          decoration: BoxDecoration(
                              color: Styles.pinColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/images/sliders.svg",
                              color: Colors.white,
                              width: 20,
                              height: 20,
                            ),
                          ),
                        ))
                  ],
                ),
                const Gap(30),
                // SingleChildScrollView(
                //     scrollDirection: Axis.vertical,
                //     child: Column(children: <Widget>[
                //         SizedBox(
                //           height: size.height * 0.78,
                //           width: size.width * 0.9,
                //           child: StreamBuilder<QuerySnapshot>(
                //               stream: query.snapshots(),
                //               builder: (context, snapshot) {
                //                 if (snapshot.connectionState ==
                //                     ConnectionState.waiting) {
                //                   return Center(
                //                       child: CircularProgressIndicator());
                //                 }
                //                 if (snapshot.hasError) {
                //                   return Center(
                //                       child: Text("Error: ${snapshot.error}"));
                //                 }
                //                 return ListView.builder(
                //                     itemCount: snapshot.data!.docs.length,
                //                     itemBuilder: (context, index) {
                //                       Acommodation model = Acommodation.fromJson(
                //                           snapshot.data!.docs[index].data()!
                //                               as Map<String, dynamic>);
                //                       model.id = snapshot.data!.docs[index].id;
                //                       return AccommodationCard(
                //                           accomodation: model, index: index);
                //                     });
                //               }),
                //         )
//alternatywna wersja XD
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      if (results.isEmpty)
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
                      else
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
                                    start_date:  startDate,
                                    end_date: endDate,
                                    guest_number: guest_number ,
                                  );
                                }))

                      // SizedBox(
                      //   height: size.height * 0.78,
                      //   width: size.width * 0.9,
                      //   child: StreamBuilder<List<QuerySnapshot>>(
                      //       stream: totalRef,
                      //       // stream: query.snapshots(),
                      //       builder: (context,
                      //           AsyncSnapshot<List<QuerySnapshot>>
                      //               snapshotList) {
                      //         List<QuerySnapshot<Object?>>? querySnapshot =
                      //             snapshotList.data;
                      //         if (snapshotList.connectionState ==
                      //             ConnectionState.waiting) {
                      //           return Center(
                      //               child: CircularProgressIndicator());
                      //         }
                      //         if (snapshotList.hasError) {
                      //           return Center(
                      //               child:
                      //                   Text("Error: ${snapshotList.error}"));
                      //         }
                      //         List<DocumentSnapshot> listOfDocumentSnapshot =
                      //             [];

                      //         querySnapshot!.forEach((queries) {
                      //           listOfDocumentSnapshot.addAll(queries.docs);
                      //         });
                      //         return ListView.builder(
                      //             itemCount: listOfDocumentSnapshot.length,
                      //             itemBuilder: (context, index) {
                      //               Acommodation model = Acommodation.fromJson(
                      //                   listOfDocumentSnapshot[index].data()!
                      //                       as Map<String, dynamic>);
                      //               model.id = listOfDocumentSnapshot[index].id;
                      //               return AccommodationCard(
                      //                   accomodation: model, index: index);
                      //             });
                      //       }),
                      // )
                    ])),
              ],
            ),
          ],
        ));
  }
}
