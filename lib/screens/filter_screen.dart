
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:nomadly_app/models/Booking.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:intl/src/intl/date_format.dart';
import 'package:provider/provider.dart';

import '../models/Accomodation.dart';

typedef void QueryCallback(Query query);

enum AccommodationTypeFilter {
  All,
  Apartment,
  Villa,
  Hotel,
  Hostel,
  Cabin,
  Bungalow,
  Room
}

enum AmenitiesFilter { wifi, tv, airconditioning, kitchen }

class FiltersScreen extends StatefulWidget {
  List<String> currentFilters = [];
  int guests = 0;
  RangeValues currentPriceRange = const RangeValues(0, 2000);
  String currentCity = "";
  List<Acommodation> resultList;
  DateTime start;
  DateTime end;
  final QueryCallback onQueryChanged;
  final void Function(List<String>, RangeValues, String, List<Acommodation>,
      int, DateTime, DateTime) onApplyFilters;
  FiltersScreen(
      {super.key, required this.onApplyFilters,
      required this.onQueryChanged,
      required this.currentFilters,
      required this.currentPriceRange,
      required this.currentCity,
      required this.resultList,
      required this.start,
      required this.end,
      required this.guests});
  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues _priceRange = const RangeValues(0, 2000);

  late DateTime currentstartDate;
  late DateTime currentendDate;
  late int guest_number;
  int? _value = 1;
  //List<String> accommodationType=["All","Apartment","Hotel","Hostel","Cabin","Bungalow","Private room"];
  List<String> _filters = <String>[];

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentstartDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != currentstartDate) {
      setState(() {
        currentstartDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentendDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != currentendDate) {
      setState(() {
        currentendDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    currentstartDate = DateTime.now();
    currentendDate = DateTime.now();
    _filters = widget.currentFilters;
    _priceRange = widget.currentPriceRange;
    searchCity.text = widget.currentCity;
    guest_number = widget.guests;
  }

  TextEditingController searchCity = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    List<Booking> bookingsList = Provider.of<List<Booking>>(context);

    return Container(
      height: size.height, //size.height * 0.8,
      width: size.width, //size.width * 0.8,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      child: Column(
        children: [
          const Gap(80),
          const Text("When",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          TextField(
            controller: searchCity,
            onChanged: (val) => setState(() {
              // query = query.where(
              //   'city',
              //   isEqualTo: searchText.text,
              // );
            }),
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
          Divider(
            color: Styles.greyColor,
            height: 30,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          
          ),
          const Text("When",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          const Gap(20),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                    ),
                    filled: true,
                    fillColor: Color.fromARGB(255, 249, 250, 250),
                    labelText: 'Check In',
                    hintText: 'Please select a start date',
                  ),
                  readOnly: true,
                  onTap: () => _selectStartDate(context),
                  controller: TextEditingController(
                    text: currentstartDate == null
                        ? ''
                        : DateFormat('dd-MM-yyyy').format(currentstartDate),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Container(
                  child: TextField(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                      labelText: 'Check Out',
                      hintText: 'Please select an end date',
                    ),
                    readOnly: true,
                    onTap: () => _selectEndDate(context),
                    controller: TextEditingController(
                      text: currentendDate == null
                          ? ''
                          : DateFormat('dd-MM-yyyy').format(currentendDate),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Divider(
            color: Styles.greyColor,
            height: 30,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
          Container(
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () => setState(() {
                          widget.guests == 0
                              ? print('guests at 0')
                              : widget.guests--;
                        }),
                    child: const Icon(Icons.remove)),
                Text('${widget.guests}'),
                GestureDetector(
                    onTap: () {
                      setState(() {
                        print('set');
                        widget.guests++;
                      });
                    },
                    child: const Icon(Icons.add)),
              ],
            ),
          ),
          Divider(
            color: Styles.greyColor,
            height: 30,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
          const Gap(10),
          const Text("Price",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          RangeSlider(
            activeColor: const Color.fromARGB(255, 135, 135, 135),
            values: _priceRange,
            max: 2000,
            divisions: 2000,
            labels: RangeLabels(
              _priceRange.start.round().toString(),
              _priceRange.end.round().toString(),
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _priceRange = values;
              });
            },
          ),
          Divider(
            color: Styles.greyColor,
            height: 30,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
          const Gap(10),
          const Text("Type",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          Wrap(
            spacing: 5.0,
            children: AccommodationTypeFilter.values
                .map((AccommodationTypeFilter exercise) {
              return FilterChip(
                label: Text(exercise.name),
                selected: _filters.contains(exercise.name),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      if (!_filters.contains(exercise.name)) {
                        _filters.add(exercise.name);
                      }
                    } else {
                      _filters.removeWhere((String name) {
                        return name == exercise.name;
                      });
                    }
                  });
                },
              );
            }).toList(),
          ),
          //  Wrap(
          //     spacing: 5.0,
          //     children: List<Widget>.generate(
          //       7,
          //       (int index) {
          //         return ChoiceChip(
          //           label: Text(accommodationType[index]),
          //           selected: _value == index,
          //           onSelected: (bool selected) {
          //             setState(() {
          //               _value = selected ? index : null;
          //             });
          //           },
          //         );
          //       },
          //     ).toList(),
          //   ),
          Divider(
            color: Styles.greyColor,
            height: 30,
            thickness: 1,
            indent: 25,
            endIndent: 25,
          ),
          const Gap(20),
          const Text("Amenities",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 24, 24, 24),
                fontWeight: FontWeight.w500,
              )),
          Wrap(
            spacing: 5.0,
            children: AmenitiesFilter.values.map((AmenitiesFilter exercise) {
              return FilterChip(
                label: Text(exercise.name),
                selected: _filters.contains(exercise.name),
                // selected: _filters.contains(exercise.name),
                onSelected: (bool value) {
                  setState(() {
                    if (value) {
                      // if (!_filters.contains(exercise.name)) {
                      //  // ||!widget.currentFilters.contains(exercise.name)
                      //   _filters.add(exercise.name);
                      // }
                      if (!_filters.contains(exercise.name)) {
                        // ||!widget.currentFilters.contains(exercise.name)
                        _filters.add(exercise.name);
                      }
                    } else {
                      _filters.removeWhere((String name) {
                        return name == exercise.name;
                      });
                    }
                  });
                },
              );
            }).toList(),
          ),
          const Gap(20),

          // ElevatedButton(
          //   child: const Text('Search'),
          //   onPressed: () => {
          //     widget.onApplyFilters(_filters, _priceRange,searchCity.text),
          //     widget.onQueryChanged(buildFilterQuery()),
          //     Navigator.pop(context)
          //   },
          // )
          ElevatedButton(
            child: const Text('Search'),
            onPressed: () => {
              widget.onApplyFilters(
                  _filters,
                  _priceRange,
                  searchCity.text,
                  getFilteredList(accommodationList, bookingsList),
                  widget.guests,
                  currentstartDate,
                  currentendDate,),
              Navigator.pop(context)
            },
          )
        ],
      ),
    );
  }

  Query buildFilterQuery() {
    Query query = FirebaseFirestore.instance.collection('Accommodations');

    if (searchCity.text.isNotEmpty) {
      query = query.where("city", isEqualTo: searchCity.text);
    }

    if (_priceRange.start >= 0 && _priceRange.end <= 2000) {
      query = query
          .where("price_per_night", isGreaterThanOrEqualTo: _priceRange.start)
          .where("price_per_night", isLessThanOrEqualTo: _priceRange.end);
    }
    if (_filters == AccommodationTypeFilter.All) {}
    if (_filters.contains(AmenitiesFilter.wifi.name)) {
      query = query.where("wifi", isEqualTo: true);
    }
    if (_filters.contains(AmenitiesFilter.tv.name)) {
      query = query.where("tv", isEqualTo: true);
    }
    if (_filters.contains(AmenitiesFilter.airconditioning.name)) {
      query = query.where("air_conditioning", isEqualTo: true);
    }
    if (_filters.contains(AmenitiesFilter.kitchen.name)) {
      query = query.where("kitchen", isEqualTo: true);
    }

    return query;
  }

  // List<Booking> checkForAvailability(List<Booking> bookingsList) {
  //   var bookingResults = bookingsList;
  //   bookingResults = bookingResults
  //       .where((i) =>
  //           DateTime.fromMillisecondsSinceEpoch(i.startDate!.seconds * 1000) !=
  //               currentstartDate &&
  //           DateTime.fromMillisecondsSinceEpoch(i.endDate!.seconds * 1000) !=
  //               currentendDate)
  //       .toList();
  //   return bookingResults;
  // }

  List<Acommodation> getFilteredList(
      List<Acommodation> accommodationList, List<Booking> bookingsList) {
    List<Acommodation> list = [];
    var bookingResults = bookingsList;
    if (searchCity.text.isEmpty) {
      bookingResults = bookingResults
          .where((i) =>
              DateTime.fromMillisecondsSinceEpoch(
                      i.startDate!.seconds * 1000) !=
                  currentstartDate &&
              DateTime.fromMillisecondsSinceEpoch(i.endDate!.seconds * 1000) !=
                  currentendDate)
          .toList();
    } else {
      bookingResults = bookingResults
          .where((i) =>(DateTime.fromMillisecondsSinceEpoch(
                          i.startDate!.seconds * 1000) !=
                      currentstartDate &&
                  DateTime.fromMillisecondsSinceEpoch(
                          i.endDate!.seconds * 1000) !=
                      currentendDate)||
              (DateTime.fromMillisecondsSinceEpoch(
                          i.startDate!.seconds * 1000) !=
                      currentstartDate &&
                  DateTime.fromMillisecondsSinceEpoch(
                          i.endDate!.seconds * 1000) !=
                      currentendDate) &&
              (i.city == searchCity.text || i.country == searchCity.text))
          .toList();
    }

    for (Booking booking in bookingResults) {
      for (Acommodation accommodation in accommodationList) {
        if (booking.accommodationId == accommodation.id &&
            accommodation.max_guests! >= widget.guests) {
          list.add(accommodation);
        }
      }
    }
    if (_priceRange.start >= 0 && _priceRange.end <= 2000) {
      list = list
          .where((i) =>
              i.price_per_night! >= _priceRange.start &&
              i.price_per_night! <= _priceRange.end)
          .toList();
    }
    if (_filters == AccommodationTypeFilter.All) {}
    if (_filters.contains(AmenitiesFilter.wifi.name)) {
      list = list.where((i) => i.wifi == true).toList();
    }
    if (_filters.contains(AmenitiesFilter.tv.name)) {
      list = list.where((i) => i.tv == true).toList();
    }
    if (_filters.contains(AmenitiesFilter.airconditioning.name)) {
      list = list.where((i) => i.air_conditioning == true).toList();
    }
    if (_filters.contains(AmenitiesFilter.kitchen.name)) {
      list = list.where((i) => i.kitchen == true).toList();
    }
    return list;
  }
}
