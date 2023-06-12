import 'package:basics/basics.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
  int guests = 1;
  RangeValues currentPriceRange = const RangeValues(0, 2000);
  String currentCity = "";
  List<Acommodation> resultList;
  DateTime start;
  DateTime end;
  String infoMessage="";
  final QueryCallback onQueryChanged;
  final void Function(List<String>, RangeValues, String, List<Acommodation>,
      int, DateTime, DateTime,String) onApplyFilters;
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
      required this.guests,
      required this.infoMessage});
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
  String info="";

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

  Future<void> getAccommodations(String city, [String? country]) async {
    var x;
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("Accommodations")
          .where("city", isEqualTo: city)
          .get();
      List<Acommodation> snapshots =
          snapshot.docs.map((doc) => Acommodation.fromSnapshot(doc)).toList();
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
      accommodations_id = a;
    } catch (error) {
      print(error);

      return x;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: currentstartDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
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
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(Duration(days: 365)));
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
    info=widget.infoMessage;
  }

  @override
  Widget build(BuildContext context) {
    var size = AppLayout.getSize(context);
    List<Acommodation> accommodationList =
        Provider.of<List<Acommodation>>(context);
    List<Booking> bookingsList = Provider.of<List<Booking>>(context);

    return Container(
      height: size.height, 
      width: size.width, 
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
          const Text("Where",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          const Gap(20),
          TextField(
            controller: searchCity,
            onChanged: (val) => setState(() {
              // query = query.where(
              //   'city',
              //   isEqualTo: searchText.text,
              // );
            }),
            decoration: const InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 249, 250, 250),
              contentPadding: EdgeInsets.all(10),
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
          const Gap(10),
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
          const Text("People",
              style: TextStyle(
                  fontSize: 20,
                  color: Color.fromARGB(255, 24, 24, 24),
                  fontWeight: FontWeight.w500)),
          Gap(10),
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
                          widget.guests == 1
                              ? print('guests at 1')
                              : widget.guests--;
                        }),
                    child: const Icon(Icons.remove)),
                Text('${widget.guests}'),
                GestureDetector(
                    onTap: () {
                      setState(() {
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
          const Gap(10),
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
          const Gap(10),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor:
                  const Color.fromARGB(255, 50, 134, 252)),
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
                  info
                ),
                Navigator.pop(context),
              },
              icon: const Icon(Icons.lock_open, size: 0),
              label: Text(tr('Search'),
                  style: TextStyle(fontSize: 20)),
            ),
          ),
        ],
      ),
    );
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
    String sds = dateStart.toString().substring(0, 10);
    String eds = dateEnd.toString().substring(0, 10);
    DateTime sdt = DateTime.parse(sds);
    DateTime edt = DateTime.parse(eds);

    if (sdt > edt) {
      print("isBetween: bad timespan start:$dateStart end:$dateEnd");
      return false;
    }

    bool result = checkDate > sdt;
    result = result && (checkDate < edt);
    return result;
  }

  bool isOverlapped(DateTime checkStartDate, DateTime checkEndDate,
      DateTime dateStart, DateTime dateEnd) {
    String cksds = checkStartDate.toString().substring(0, 10);
    String ckeds = checkEndDate.toString().substring(0, 10);
    String sds = dateStart.toString().substring(0, 10);
    String eds = dateEnd.toString().substring(0, 10);
    DateTime cksdt = DateTime.parse(cksds);
    DateTime ckedt = DateTime.parse(ckeds);
    DateTime sdt = DateTime.parse(sds);
    DateTime edt = DateTime.parse(eds);

    if (sdt > edt) {
      print("isOverlapped: bad timespan start:$sdt end:$edt");
      return false;
    }
    if (cksdt > ckedt) {
      print("isOverlapped: bad check timespan start:$cksdt end:$ckedt");
      return false;
    }
    if (isBetween(
        cksdt, sdt, edt)) //początek zawiera się w istniejącym zakresie
      return true;
    if (isBetween(ckedt, sdt, edt)) //koniec zawiera się w istniejącym zakresie
      return true;
    if (isBetween(sdt, cksdt, ckedt)) //rezerwacja juz istniejaca jest w "środku" zadanych dat
      return true;
    if (isBetween(edt, cksdt,ckedt)) //rezerwacja juz istniejaca jest w "środku" zadanych dat
      return true;
    if (cksdt == sdt &&
        ckedt == edt) //koniec i początek obu zakresów są sobie równe
      return true;

    return false;
  }

  
  List<Acommodation> getFilteredList(
      List<Acommodation> accommodationList, List<Booking> bookingsList) {
    List<Acommodation> result = getFilteredAccommodationList(accommodationList,
        searchCity.text, _priceRange, _filters, widget.guests);
    if (result.isEmpty) {
      return result;
    }
    result = getAccommodationsFreeTimeSlots(
        bookingsList, result, currentstartDate, currentendDate);
    return result;
  }

  List<Acommodation> getFilteredAccommodationList(
      List<Acommodation> allAccommodations,
      String city,
      RangeValues priceRange,
      List<String> filters,
      int guests) {
    List<Acommodation> filteredAccommodations = []; // = allAccommodations;

    if (guests > 0) {
      for (Acommodation accommodation in allAccommodations) {
        if (accommodation.max_guests! >= widget.guests) {
          filteredAccommodations.add(accommodation);
        }
      }
    } else {
      filteredAccommodations = allAccommodations;
    }

    if (city.isEmpty) {
    } else {
      filteredAccommodations = filteredAccommodations
          .where((i) => ((i.city == city || i.country == city||i.cityLower==city||i.countryLower==city)))
          .toList();
    }
    if (priceRange.start >= 0 && priceRange.end <= 2000) {
      filteredAccommodations = filteredAccommodations
          .where((i) =>
              i.price_per_night! >= priceRange.start &&
              i.price_per_night! <= priceRange.end)
          .toList();
    }

    if (filters == AccommodationTypeFilter.All) {
      filteredAccommodations = filteredAccommodations;
    }
    if (filters.contains(AccommodationTypeFilter.Apartment.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Apartment").toList();
    }
    if (filters.contains(AccommodationTypeFilter.Villa.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Villa").toList();
    }
    if (filters.contains(AccommodationTypeFilter.Hotel.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Hotel").toList();
    }
    if (filters.contains(AccommodationTypeFilter.Hostel.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Hostel").toList();
    }
    if (filters.contains(AccommodationTypeFilter.Cabin.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Cabin").toList();
    }
    if (filters.contains(AccommodationTypeFilter.Bungalow.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Bungalow").toList();
    }
    if (filters.contains(AccommodationTypeFilter.Room.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.type == "Room").toList();
    }
    if (filters.contains(AmenitiesFilter.wifi.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.wifi == true).toList();
    }
    if (filters.contains(AmenitiesFilter.TV.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.tv == true).toList();
    }
    if (filters.contains(AmenitiesFilter.AC.name)) {
      filteredAccommodations = filteredAccommodations
          .where((i) => i.air_conditioning == true)
          .toList();
    }
    if (filters.contains(AmenitiesFilter.Kitchen.name)) {
      filteredAccommodations =
          filteredAccommodations.where((i) => i.kitchen == true).toList();
    }
    return filteredAccommodations;
  }

  List<Acommodation> getAccommodationsFreeTimeSlots(List<Booking> bookings,
      List<Acommodation> accommodations, DateTime dtStart, DateTime dtEnd) {
    List<Acommodation> result = [];

    for (int j = 0; j < accommodations.length; j++) {
      Acommodation currentAccommodation = accommodations[j];
      String accommId = currentAccommodation.id!;
      List<Booking> accommodationBookings = bookings
          .where((element) => element.accommodationId == accommId)
          .toList();
      if (accommodationBookings.isEmpty) {
        result.add(currentAccommodation);
        continue;
      }
      accommodationBookings
          .sort((a, b) => a.startDate!.compareTo(b.startDate!));

      if (bookingPossibleInTimeSlot(accommodationBookings, dtStart, dtEnd)) {
        result.add(currentAccommodation);
      }
    }
     if(result.isEmpty){
      info="No result found";}
    return result;
  }

  bool bookingPossibleInTimeSlot(
      List<Booking> bookings, DateTime dtStart, DateTime dtEnd) {
    bool timeSlotFound = false;
    Booking currentBooking;
    Booking nextBooking;
    if (bookings.length == 1) {
      currentBooking = bookings[0];
      if (isOverlapped(
          dtStart, dtEnd, currentBooking.startDate!, currentBooking.endDate!)) {
        return false;
      }
      bool match = isBetween(
          dtStart, currentBooking.startDate!, currentBooking.endDate!);
      match = match &&
          isBetween(dtEnd, currentBooking.startDate!, currentBooking.endDate!);
      if (!match) {
        timeSlotFound = true;
        return timeSlotFound;
      }
    }
    for (int i = 0; i < bookings.length; i++) {
      currentBooking = bookings[i];
      if (isOverlapped(
          dtStart, dtEnd, currentBooking.startDate!, currentBooking.endDate!)) {
        return false;
      }
      if (i == bookings.length - 1) {
        bool match = isBetween(
            dtStart, currentBooking.startDate!, currentBooking.endDate!);
        match = match &&
            isBetween(
                dtEnd, currentBooking.startDate!, currentBooking.endDate!);
        if (!match) {
          timeSlotFound = true;
          return timeSlotFound;
        }
      } else {
        nextBooking = bookings[i + 1];
        bool match =
            isBetween(dtStart, currentBooking.endDate!, nextBooking.startDate!);

        match = match &&
            isBetween(dtEnd, currentBooking.endDate!, nextBooking.startDate!);
        if (!match) {
          continue;
        } else {
          timeSlotFound = true;
          return timeSlotFound;
        }
      }
    }
    return timeSlotFound;
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
