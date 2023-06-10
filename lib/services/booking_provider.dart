import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nomadly_app/models/Booking.dart';

class BookingProvider{
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> get allBookings {

    var list= _firestore.collection("Bookings").snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Booking(
                id:documentSnapshot.id,
                accommodationId: documentSnapshot["accommodation_id"],
                hostId: documentSnapshot["host_id"],
                userId: documentSnapshot["user_id"],
                startDate: documentSnapshot["start_date"].toDate(),
                endDate: documentSnapshot["end_date"].toDate(),
                guestNumber: documentSnapshot["guest_number"],
                totalPrice: documentSnapshot["total_price"],
                status: documentSnapshot["status"],
                username: documentSnapshot["username"],
                isAccommodationRated:  documentSnapshot["isAccommodationRated"],
                isUserRated: documentSnapshot["isUserRated"],
                city:documentSnapshot["city"],
                country:documentSnapshot["country"]))
            .toList());
    return list;
  }
  Stream<List<Booking>> getallBookings() {

    var list= _firestore.collection("Bookings").snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Booking(
                id:documentSnapshot.id,
                accommodationId: documentSnapshot["accommodation_id"],
                hostId: documentSnapshot["host_id"],
                userId: documentSnapshot["user_id"],
                startDate: documentSnapshot["start_date"].toDate(),
                endDate: documentSnapshot["end_date"].toDate(),
                guestNumber: documentSnapshot["guest_number"],
                totalPrice: documentSnapshot["total_price"],
                status: documentSnapshot["status"],
                username: documentSnapshot["username"],
                isAccommodationRated:  documentSnapshot["isAccommodationRated"],
                isUserRated: documentSnapshot["isUserRated"],
                city:documentSnapshot["city"],
                country:documentSnapshot["country"]))
            .toList());
    return list;
  }
  Future<List<Booking>> getBookingsByHostId(String id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Bookings')
        .where('user_id', isEqualTo: id)
        .where('status', isEqualTo: 'Paid')
        .get();

    List<Booking> bookings = [];

    querySnapshot.docs.forEach((doc) {
      Booking booking = Booking(
        id: doc.id,
        accommodationId: doc['accommodation_id'],
        hostId: doc['host_id'],
        userId: doc['user_id'],
        startDate: doc['start_date'].toDate(),
        endDate: doc['end_date'].toDate(),
        guestNumber: doc['guest_number'],
        totalPrice: (doc['total_price']).toDouble(),
        status: doc['status'],
        username: doc['username'],
        isAccommodationRated: doc['isAccommodationRated'],
        isUserRated: doc['isUserRated'],
        city: doc['city'],
        country: doc['country'],
      );
      bookings.add(booking);
    });

    return bookings;
  }
  Future<List<Booking>> getBookingsByUserId(String id) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('Bookings')
        .where('user_id', isEqualTo: id)
        .where('status', isEqualTo: 'Paid')
        .get();

    List<Booking> bookings = [];

    querySnapshot.docs.forEach((doc) {
      Booking booking = Booking(
        id: doc.id,
        accommodationId: doc['accommodation_id'],
        hostId: doc['host_id'],
        userId: doc['user_id'],
        startDate: doc['start_date'].toDate(),
        endDate: doc['end_date'].toDate(),
        guestNumber: doc['guest_number'],
        totalPrice: (doc['total_price']).toDouble(),
        status: doc['status'],
        username: doc['username'],
        isAccommodationRated: doc['isAccommodationRated'],
        isUserRated: doc['isUserRated'],
        city: doc['city'],
        country: doc['country'],
      );
      bookings.add(booking);
    });

    return bookings;
  }
}