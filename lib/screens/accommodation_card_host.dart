import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/shimmers/shimmer_load_photos.dart';
import 'package:nomadly_app/screens/update_accommodation_view.dart';
import '../models/Accomodation.dart';
import '../utils/app_layout.dart';
import '../utils/app_styles.dart';
import 'accommodation_details_view.dart';
import 'host/accommodations_details_view_host.dart';

class AccommodationCardHost extends StatefulWidget {
  final Acommodation accomodation;
  final int index;
  final String? host_id;

  const AccommodationCardHost(
      {super.key,
      required this.accomodation,
      required this.index,
      required this.host_id});

  @override
  State<AccommodationCardHost> createState() => _AccommodationCardHostState();
}

class _AccommodationCardHostState extends State<AccommodationCardHost> {
  Future<QuerySnapshot>? allAccommodationDocumentList =
  FirebaseFirestore.instance.collectionGroup("Accommodations").get();
  Future<QuerySnapshot>? accommodationDocumentList;

  navigateToDetail(Acommodation accommodation) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                DetailsHostScreen(
                  accommodation: accommodation,
                ))));
  }

  navigateToUpdate(Acommodation accommodation, String id) async {
    DocumentSnapshot<Object?> snapshot = await FirebaseFirestore.instance
        .collection('Accommodations')
        .doc(id)
        .get();
    navigateToUpdateScreen(snapshot, id);
  }

  navigateToUpdateScreen(DocumentSnapshot<Object?> accommodation, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) =>
                UpdateAccommodationScreen(
                    accommodation: accommodation, id: id))));
  }

  CollectionReference accommodation = FirebaseFirestore.instance.collection(
      'Accommodations');

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return InkWell(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10, right: 10, left: 10),
            width: size.width,
            height: size.height * 0.31,
            decoration: BoxDecoration(
              color: Styles.whiteColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                FutureBuilder(
                  future: FirebaseStorage.instance
                      .refFromURL(widget.accomodation.photo!)
                      .getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          height: 180,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data.toString()),
                                fit: BoxFit.fill,
                              )));
                    } else {
                      return Center(
                          child: ShimmerLoadCardPhotos(
                              height: 180, width: size.width));
                    }
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.accomodation.title!,
                        style: GoogleFonts.roboto(
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "\$${widget.accomodation.price_per_night}",
                        style: GoogleFonts.roboto(
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 5,
            right: 15,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: PopupMenuButton(
                  icon: Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (BuildContext context) =>
                  [
                    PopupMenuItem(
                      child: Text(tr("Edit")),
                      value: "edit",
                    ),
                    PopupMenuItem(
                      child: Text(tr("Delete")),
                      value: "delete",
                    ),
                  ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      navigateToUpdate(
                          widget.accomodation, widget.accomodation.id!);
                    } else if (value == 'delete') {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(tr('Delete Accommodation')),
                            content: Text(
                                tr('Are you sure you want to delete this item?')),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(tr('No')),
                              ),
                              TextButton(
                                onPressed: () {
                                  deleteAccommodation(widget.accomodation.id!,
                                      widget.accomodation.photo!,
                                      widget.accomodation.photoUrl!);
                                  Navigator.pop(context);
                                },
                                child: Text(tr('Yes')),
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        navigateToDetail(widget.accomodation);
      },
    );
  }

  void deleteAccommodation(String documentId, String imageId,
      List<String> photoUrls) async {
    try {
      // Delete the main photo
      await FirebaseStorage.instance.refFromURL(imageId).delete();
      print('Main photo successfully deleted!');

      // Delete other photos
      for (String photoUrl in photoUrls) {
        await FirebaseStorage.instance.refFromURL(photoUrl).delete();
        print('Photo successfully deleted!');
      }

      // Delete the accommodation document
      await FirebaseFirestore.instance
          .collection('Accommodations')
          .doc(documentId)
          .delete();
      print('Accommodation document successfully deleted!');
    } catch (e) {
      print('Error deleting accommodation: $e');
    }
  }
}