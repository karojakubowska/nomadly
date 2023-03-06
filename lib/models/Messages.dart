import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String? message_id;
  String? sender_id;
  String? receiver_id;
  String? message;
  bool? is_read;
  Timestamp? send_date;

  Messages({
    required this.message_id,
    required this.sender_id,
    required this.receiver_id,
    required this.message,
    required this.is_read,
    required this.send_date,
  });

  factory Messages.fromMap(Map<String, dynamic> data) {
    return Messages(
      message_id: data['message_id'],
      sender_id: data['sender_id'],
      receiver_id: data['receiver_id'],
      message: data['message'],
      is_read: data['is_read'],
      send_date: data['send_date'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'message_id': message_id,
      'sender_id': sender_id,
      'receiver_id': receiver_id,
      'message': message,
      'is_read': is_read,
      'send_date': send_date,
    };
  }
}
