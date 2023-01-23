import 'package:cloud_firestore/cloud_firestore.dart';

class Travel{
  String? name;
  int? budget;
  String? destination;
  Timestamp? start_date;
  Timestamp? end_date;
  String? notes;
  String? photo;
  int? number_of_people;
  List<dynamic>? to_do_list;

//funkcja mapująca dane na json
  Map<String,dynamic> toJson()=>{
    'budget': budget,
    'name': name,
    'destination': destination,
    'start_date': start_date,
    'end_date': end_date,
    'notes': notes,
    'photo': photo,
    'number_of_people': number_of_people,
    'to_do_list': to_do_list,
  };

  Travel.fromJson(Map<String,dynamic> json)
  {
    budget=json['budget'];
    name=json['name'];
    destination=json['destination'];
    start_date=json['start_date'];
    end_date=json['end_date'];
    notes=json['notes'];
    photo=json['photo'];
    number_of_people=json['number_of_people'];
    to_do_list=json['to_do_list'];
  }
}
