import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/models/Date.dart';

class AccommodationProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Acommodation>> get allAccommodations {
    var list = _firestore.collection("Accommodations").snapshots().map(
        (QuerySnapshot querySnapshot) =>
            querySnapshot.docs.map((DocumentSnapshot documentSnapshot) {
              List<String> photoUrls =
                  List<String>.from(documentSnapshot["photoUrl"]);
              List<dynamic> bookedDates =
                  List<dynamic>.from(documentSnapshot["booked_dates"]);
              List<BookDate> dates = [];
              bookedDates.forEach((element) {
                dates.add(BookDate(
                    date: element['date'].toDate(), hour: element['hour']));
              });
              dates.sort((a, b) => a.date!.compareTo(b.date!));
              // var x =
              //     List<Timestamp>.from(documentSnapshot["booked"]);
              // x.sort();
              // List<DateTime> list = [];
              // for (var date in x) {
              //   list.add(date.toDate());
              // }
              return Acommodation(
                id: documentSnapshot.id,
                title: documentSnapshot["title"],
                city: documentSnapshot["city"],
                photo: documentSnapshot["photo"],
                country: documentSnapshot["country"],
                rate: documentSnapshot["rate"],
                price_per_night: documentSnapshot["price_per_night"],
                host_id: documentSnapshot['host_id'],
                description: documentSnapshot["description"],
                wifi: documentSnapshot["wifi"],
                tv: documentSnapshot["tv"],
                bedroom: documentSnapshot["bedroom"],
                bathroom: documentSnapshot["bathroom"],
                bed: documentSnapshot["bed"],
                address: documentSnapshot["address"],
                max_guests: documentSnapshot["number_max_people"],
                reviews: documentSnapshot["reviews"],
                photoUrl: photoUrls,
                bookedDates: dates,
              );
            }).toList());
    return list;
  }


}
