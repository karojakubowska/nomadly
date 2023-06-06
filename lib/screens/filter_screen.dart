import 'package:basics/basics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
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

enum AmenitiesFilter { wifi, TV, AC, Kitchen }

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
      {super.key,
      required this.onApplyFilters,
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
  TextEditingController searchCity = TextEditingController();
  RangeValues _priceRange = const RangeValues(0, 2000);
  late DateTime currentstartDate;
  late DateTime currentendDate;
  late int guest_number;
  List<String> _filters = <String>[];
  List<String> accommodations_id = <String>[];
  List<Booking> sortedBookings = [];

  Future<void> getBookings(DateTime startDate, DateTime endDate) async {
    var x;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Bookings")
          .where("start_date", isGreaterThan: Timestamp.fromDate(startDate))
          .where("start_date", isLessThan: Timestamp.fromDate(endDate))
          .get();
      List<dynamic> snapshots = snapshot.docs.map((doc) => doc.data()).toList();
      List<Booking> bookings = [];
      snapshots.forEach((element) {
        bookings.add(Booking(
            accommodationId: element['accommodation_id'],
            startDate: element['start_date'].toDate(),
            endDate: element['end_date'].toDate()));
      });
      bookings.sort((a, b) {
        //sortowanie po accommodation_id i start_date
        //komparator po accommodation_id
        int accommComp = a.accommodationId!.compareTo(b.accommodationId!);
        if (accommComp == 0) {
          //jeśli accommodation_id są takie same
          return a.startDate!
              .compareTo(b.startDate!); // to sortuj po dacie startowej
        }
        return accommComp;
      });
      sortedBookings = bookings;
    } catch (error) {
      print(error);

      return x;
    }
  }

  Future<void> getAccommodations(String city,
      [String? country]) async {
    var x;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Accommodations")
          .where("city", isEqualTo: city)
          .get();
      List<Acommodation> snapshots = snapshot.docs.map((doc) =>  Acommodation.fromSnapshot(doc)).toList();
      List<String> a = [];
      snapshots.forEach((element) {
        a.add(element.id!);
      });
      print(a);
      a.sort((a, b) {
        //sortowanie po accommodation_id i start_date
        //komparator po accommodation_id
        int accommComp = a.compareTo(b);

        return accommComp;
      });
      accommodations_id=a;
    } catch (error) {
      print(error);

      return x;
    }
  }

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
          const Gap(20),
          ElevatedButton(
            child: const Text('Search'),
            onPressed: () async => {
              await getBookings(currentstartDate.add(Duration(days: -90)),
                  currentendDate.add(Duration(days: 365))),
               await getAccommodations(searchCity.text),
              widget.onApplyFilters(
                _filters,
                _priceRange,
                searchCity.text,
                getFilteredList(accommodationList, sortedBookings),
                widget.guests,
                currentstartDate,
                currentendDate,
              ),
              Navigator.pop(context),
            },
          )
        ],
      ),
    );
  }


  List<Acommodation> getFilteredList(
      List<Acommodation> accommodationList, List<Booking> bookingsList) {
    List<Acommodation> list = getAccommodationsFreeTimeSlots(
        //pobieram liste z obiektami wolnymi w zadanych datach
        bookingsList,
        accommodationList,
        currentstartDate,
        currentendDate);

    // var bookingResults = bookingsList;
    if (searchCity.text.isEmpty) {
    } else {
      list = list
          .where((i) =>
              ((i.city == searchCity.text || i.country == searchCity.text)))
          .toList();
    }
    if (_priceRange.start >= 0 && _priceRange.end <= 2000) {
      list = list
          .where((i) =>
              i.price_per_night! >= _priceRange.start &&
              i.price_per_night! <= _priceRange.end)
          .toList();
    }

    if (_filters == AccommodationTypeFilter.All) {
      list = list;
    }
    if (_filters.contains(AccommodationTypeFilter.Apartment.name)) {
      list = list.where((i) => i.type == "Apartment").toList();
    }
    if (_filters.contains(AccommodationTypeFilter.Villa.name)) {
      list = list.where((i) => i.type == "Villa").toList();
    }
    if (_filters.contains(AccommodationTypeFilter.Hotel.name)) {
      list = list.where((i) => i.type == "Hotel").toList();
    }
    if (_filters.contains(AccommodationTypeFilter.Hostel.name)) {
      list = list.where((i) => i.type == "Hostel").toList();
    }
    if (_filters.contains(AccommodationTypeFilter.Cabin.name)) {
      list = list.where((i) => i.type == "Cabin").toList();
    }
    if (_filters.contains(AccommodationTypeFilter.Bungalow.name)) {
      list = list.where((i) => i.type == "Bungalow").toList();
    }
    if (_filters.contains(AccommodationTypeFilter.Room.name)) {
      list = list.where((i) => i.type == "Room").toList();
    }
    if (_filters.contains(AmenitiesFilter.wifi.name)) {
      list = list.where((i) => i.wifi == true).toList();
    }
    if (_filters.contains(AmenitiesFilter.TV.name)) {
      list = list.where((i) => i.tv == true).toList();
    }
    if (_filters.contains(AmenitiesFilter.AC.name)) {
      list = list.where((i) => i.air_conditioning == true).toList();
    }
    if (_filters.contains(AmenitiesFilter.Kitchen.name)) {
      list = list.where((i) => i.kitchen == true).toList();
    }

    return list;
    // bookingResults = unifyList(bookingResults);

    // for (Booking booking in bookingResults) {
    //   for (Acommodation accommodation in accommodationList) {
    //     if (booking.accommodationId == accommodation.id &&
    //         accommodation.max_guests! >= widget.guests) {
    //       list.add(accommodation);
    //     }
    //   }
    // }

    // return list;
  }

  List<Booking> unifyList(List<Booking> list) {
    if (list.isEmpty) {
      return list;
    }
    if (list.length <= 1) {
      return list;
    }
    List<Booking> results = [];
    list.sort((a, b) => a.accommodationId!.compareTo(b.accommodationId!));

    var x = list[0];
    results.add(x);
    for (int i = 1; i < list.length; i++) {
      if (x.accommodationId != list[i].accommodationId) {
        x = list[i];
        results.add(x);
      }
    }

    return results;
  }

  DateTime toDateTime(Timestamp date) {
    return DateTime.fromMillisecondsSinceEpoch(date.seconds * 1000);
  }

  bool isBetween(DateTime checkDate, DateTime dateStart, DateTime dateEnd) {
    return checkDate >= dateStart && checkDate <= dateEnd;
  }

  List<Acommodation> getAccommodationsFreeTimeSlots(List<Booking> bookings,
      List<Acommodation> accommodations, DateTime dtStart, DateTime dtEnd) {
    List<Acommodation> result = [];
    if (bookings.isEmpty) {
      return result;
    }
    String accommId = bookings[0].accommodationId!;
    for (int i = 0; i < bookings.length - 1; i++) {
      Booking b1 = bookings[i];
      if (b1.accommodationId != accommId) //punkt zmiany accommodation_id
      {
        accommId = b1.accommodationId!;
      }
      Booking b2 = bookings[i + 1];
      if (b1.accommodationId !=
          b2.accommodationId) //punkt zmiany accommodation_id
      {
        //przypadek,gdy jest tylko jedna rezerwacja (b1), a po niej nie ma zadnej innej rezerwacji z tym samym accommodation_id
        bool match = isBetween(dtStart, b1.startDate!, b1.endDate!) ||
            isBetween(dtEnd, b1.startDate!, b1.endDate!);
        if (!match) {
          Acommodation x =
              getAccommodationById(accommodations, b1.accommodationId!);
          if (x.id != "") {
            result.add(x);
          }
        }
        continue;
      }
      bool match = isBetween(dtStart, b1.endDate!, b2.startDate!) &&
          isBetween(dtEnd, b1.endDate!, b2.startDate!);
      if (match) {
        Acommodation x =
            getAccommodationById(accommodations, b1.accommodationId!);
        if (x.id != "") {
          result.add(x);
        }
      }
    }
    return result;
  }

  Acommodation getAccommodationById(
      List<Acommodation> accommodations, String id) {
    if (accommodations.isEmpty) return new Acommodation();
    for (Acommodation accommodation in accommodations) {
      if (accommodation.id == id) {
        return accommodation;
      }
    }
    return new Acommodation();
  }
}
