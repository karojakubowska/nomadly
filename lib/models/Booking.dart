import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  String? id;
  String? accommodationId;
  String? hostId;
  String? userId;
  Timestamp? startDate; //czy to będzie ten typ???
  Timestamp? endDate;
  num? guestNumber;
  num? totalPrice;
  String? status;
  String? username;
  bool? isAccommodationRated;
  bool? isUserRated;
  String? city;
  String? country;

  Booking(
      {this.id,
      this.accommodationId,
      this.hostId,
      this.userId,
      this.startDate,
      this.endDate,
      this.guestNumber,
      this.totalPrice,
      this.status,
      this.username,
      this.isAccommodationRated,
      this.isUserRated,
      this.city,
      this.country});

  Booking.fromJson(Map<String, dynamic> json) {
    accommodationId = json['accommodation_id'];
    hostId = json['host_id'];
    userId = json['user_id'];
    status = json['status'];
    username = json['username'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    guestNumber = json['guest_number'];
    totalPrice = (json['total_price']).toDouble();
    isAccommodationRated = json['isAccommodationRated'];
    isUserRated = json['isUserRated'];
  }
}
