import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/all_accommodations.dart';
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
  RangeValues currentPriceRange = RangeValues(0, 2000);
  final QueryCallback onQueryChanged;
  final void Function(List<String>, RangeValues) onApplyFilters;
  FiltersScreen(
      {required this.onApplyFilters,
      required this.onQueryChanged,
      required this.currentFilters,
      required this.currentPriceRange});
  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  RangeValues _priceRange = const RangeValues(0, 2000);

  late DateTime startDate;
  late DateTime endDate;
  int? _value = 1;
  //List<String> accommodationType=["All","Apartment","Hotel","Hostel","Cabin","Bungalow","Private room"];
  List<String> _filters = <String>[];

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
    _filters = widget.currentFilters;
    _priceRange = widget.currentPriceRange;
  }

  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);

    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
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
          Gap(20),
          Text("Date",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          Gap(20),
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
                    text: startDate == null
                        ? ''
                        : DateFormat('dd-MM-yyyy').format(startDate),
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
                      labelText: 'Out',
                      hintText: 'Please select an end date',
                    ),
                    readOnly: true,
                    onTap: () => _selectEndDate(context),
                    controller: TextEditingController(
                      text: endDate == null
                          ? ''
                          : DateFormat('dd-MM-yyyy').format(endDate),
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
          Gap(10),
          Text("Price",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          RangeSlider(
            activeColor: Color.fromARGB(255, 135, 135, 135),
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
          Gap(10),
          Text("Type",
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
          Gap(20),
          Text("Amenities",
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
          Gap(20),

          ElevatedButton(
            child: const Text('Search'),
            onPressed: () => {
              widget.onApplyFilters(_filters, _priceRange),
              widget.onQueryChanged(buildFilterQuery()),
              Navigator.pop(context)
            },
          )
        ],
      ),
    );
  }

  Query buildFilterQuery() {
    Query query = FirebaseFirestore.instance.collection('Accommodations');
    if (_priceRange.start >= 0 && _priceRange.end <= 2000) {
      query = query
          .where("price_per_night", isGreaterThanOrEqualTo: _priceRange.start)
          .where("price_per_night", isLessThanOrEqualTo: _priceRange.end);
    }
    // if(startDate!=null&&endDate!=null){
    //   query=query.where(field)
    // }
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
}
