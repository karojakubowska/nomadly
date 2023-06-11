import 'package:rxdart/rxdart.dart';

class BookDate {
  DateTime? date;
  String? hour;

  BookDate({
    this.date,
    this.hour,
  });

  static bool equalBookdates(BookDate bookDate1, BookDate bookDate2) {
   // bool retVal=false;
    String dt1=bookDate1.toString().substring(1,11);
    String dt2=bookDate1.toString().substring(1,11);
    return dt1==dt2;
    //return retVal;
  }

  bool isMyDateEqualTo(DateTime date){
    int cmpVal= this.date!.compareTo(date);
    return cmpVal==0;
  }
  Map<String, dynamic> toJson() => {
        'date':date,
        'hour':hour };
}
