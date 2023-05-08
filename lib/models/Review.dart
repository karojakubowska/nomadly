import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  String? userId;
  String? accommodationId;
  String? reviewText;
  num? rate;
  Timestamp? date;

  Review({
    required this.userId,
    required this.accommodationId,
    required this.reviewText,
    required this.rate,
    required this.date,
  });

  Review.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    accommodationId = json['accommodationId'];
    reviewText = json['reviewText'];
    rate = json['rate'];
    date = json['pub_date'];
  }
}
