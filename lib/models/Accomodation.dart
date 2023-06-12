
import 'package:nomadly_app/models/Date.dart';

class Acommodation {
  String? id;
  String? title;
  String? type;
  int? number_of_rooms;
  int? number_of_beds;
  int? number_of_bathrooms;
  int? max_guests;
  int? price_per_night;
  String? street;
  String? city;
  String? cityLower;
  String? post_code;
  String? country;
  String? countryLower;
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
  num? reviews;
  num? bedroom;
  num? bathroom;
  num? bed;
  num? people;
  String? address;
  List<String>? photoUrl;
  //List<DateTime>? bookedDates;
  List<BookDate>? bookedDates;
  int? reservationsCount;

  Acommodation({
    this.id,
    this.title,
    this.city,
    this.cityLower,
    this.photo,
    this.country,
    this.countryLower,
    this.rate,
    this.price_per_night,
    this.description,
    this.host_id,
    this.reviews,
    this.wifi,
    this.tv,
    this.max_guests,

    this.bedroom,
    this.bathroom,
    this.bed,
    this.address,
    this.photoUrl,
   this.bookedDates,
   this.reservationsCount
  });

  // Future<String> convertPathToURL(String path){
  //    return FirebaseStorage.instance
  //       .refFromURL(path)
  //       .getDownloadURL();
  // }

  Map<String, dynamic> toJson() => {
        'title': title,
        'type': type,
        'number_of_rooms': number_of_rooms,
        'number_of_beds': number_of_beds,
        'number_of_bathrooms': number_of_bathrooms,
        'number_max_people': max_guests,
        'price_per_night': price_per_night,
        'street': street,
        'address': address,
        'city': city,
        'city_lower': cityLower,
        'post_code': post_code,
        'country': country,
        'country_lower': countryLower,
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
        'reviews': reviews,
        'bedroom': bedroom,
        'bed': bed,
        'photoUrl': photoUrl,
        'bathroom': bathroom
      };
  

  Acommodation.fromJson(Map<String,dynamic> json)
  {
    title=json['title'];
    type=json['type'];
    number_of_rooms=json['number_of_rooms'];
    number_of_beds=json['number_of_beds'];
    number_of_bathrooms=json['number_of_bathrooms'];
    max_guests=json['number_max_people'];
    price_per_night=json['price_per_night'];
    street=json['street'];
    city=json['city'];
     cityLower=json['city_lower'];
    post_code=json['post_code'];
    country=json['country'];
    countryLower=json['country_lower'];
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
    reviews=json['reviews'];
    photoUrl = List<String>.from(json['photoUrl']);
     List<dynamic> datesList =
                  List<dynamic>.from(json["booked_dates"]);
               List<BookDate>x = [];
              datesList.forEach((element) {
                x.add(BookDate(
                    date: element['date'].toDate(), hour: element['hour']));
              });
              x.sort((a, b) => a.date!.compareTo(b.date!));
              bookedDates=x;
             
  }

  Acommodation.fromSnapshot(snapshot)

      : id=snapshot.id,
      title = snapshot.data()['title'],
        city = snapshot.data()['city'],
        street=snapshot.data()['street'],
        price_per_night = snapshot.data()['price_per_night'],
        //rate=snapshot.data()['rate'],
        photo = snapshot.data()['photo'],
        host_id = snapshot.data()['host_id'],
        bedroom = snapshot.data()['bedroom'],
        bed = snapshot.data()['bed'],
        bathroom = snapshot.data()['bathroom'],
        max_guests = snapshot.data()['number_max_people'],
        address = snapshot.data()['address'],
        photoUrl = List<String>.from(snapshot.data()['photoUrl']);
}
