

import 'package:firebase_storage/firebase_storage.dart';

class Acommodation {
  String? id;
  String? title;
  String? type;
  int? number_of_rooms;
  int? number_of_beds;
  int? number_of_bathrooms;
  int? number_max_people;
  int? price_per_night;
  String? street;
  String? city;
  String? post_code;
  String? country;
  String? check_in;
  String? check_out;
  String? description;
  bool? wifi;
  bool? tv;
  bool? air_conditioning;
  bool? kitchen;
  String? host_id;
  num? rate;
  String? photo;

  Acommodation({
    this.id,
    this.title,
    this.city,
    this.photo,
    this.country,
    this.rate,
    this.price_per_night,
    this.description,
    this.host_id
  });

  Future<String> convertPathToURL(String path){
     return FirebaseStorage.instance
        .refFromURL(path)
        .getDownloadURL();
  }

   Map<String,dynamic> toJson()=>{
    'title': title,
    'type': type,
    'number_of_rooms': number_of_rooms,
    'number_of_beds': number_of_beds,
    'number_of_bathrooms': number_of_bathrooms,
    'number_max_people': number_max_people,
    'price_per_night': price_per_night,
    'street': street,
    'city': city,
    'post_code': post_code,
    'country': country,
    'check_in': check_in,
    'check_out': check_out,
    'description': description,
    'wifi': wifi,
    'tv': tv,
    'air_conditioning': air_conditioning,
    'kitchen': kitchen,
    'host_id': host_id,
    'rate': rate,
    'photo': photo,
  };

  Acommodation.fromJson(Map<String,dynamic> json)
  {
    title=json['title'];
    type=json['type'];
    number_of_rooms=json['number_of_rooms'];
    number_of_beds=json['number_of_beds'];
    number_of_bathrooms=json['number_of_bathrooms'];
    number_max_people=json['number_max_people'];
    price_per_night=json['price_per_night'];
    street=json['street'];
    city=json['city'];
    post_code=json['post_code'];
    country=json['country'];
    check_in=json['check_in'];
    check_out=json['check_out'];
    description=json['description'];
    wifi=json['wifi'];
    tv=json['tv'];
    air_conditioning=json['air_conditioning'];
    kitchen=json['kitchen'];
    host_id=json['host_id'];
    rate=json['rate'];
    photo=json['photo'];
  }

  Acommodation.fromSnapshot(snapshot)
  : title=snapshot.data()['title'],
  city=snapshot.data()['city'],
  //street=snapshot.data()['street'],
  price_per_night=snapshot.data()['price_per_night'],
  //rate=snapshot.data()['rate'],
  photo=snapshot.data()['photo'],
  host_id=snapshot.data()['host_id']
  ;
}
