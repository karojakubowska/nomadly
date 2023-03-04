class Favorites {
  String? accommodationId;

  Map<String, dynamic> toJson() => {'accommodationId': accommodationId};
  Favorites({this.accommodationId});
}
