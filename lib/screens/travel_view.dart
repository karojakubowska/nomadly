import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/screens/add_travel_view.dart';
import 'package:nomadly_app/screens/travel_single_view.dart';
import 'package:nomadly_app/screens/update_travel_view.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class TravelView extends StatefulWidget {
  const TravelView({Key? key}) : super(key: key);

  @override
  State<TravelView> createState() => _TravelViewState();
}

class _TravelViewState extends State<TravelView> {
  Future<QuerySnapshot>? allTravelDocumentList =
      FirebaseFirestore.instance.collectionGroup("Travel").get();
  Future<QuerySnapshot>? travelDocumentList;

  var img = "";

  navigateToDetail(DocumentSnapshot travel) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => SingleTravelPage(
                  travel: travel,
                ))));
  }

  navigateToUpdate(DocumentSnapshot travel, String id) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: ((context) => UpdateTravelView(travel: travel, id: id))));
  }

  late Stream<QuerySnapshot> travelStream;

  void initState() {
    super.initState();
    travelStream = FirebaseFirestore.instance.collection("Travel").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Travels',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30.0, right: 10.0),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => AddTravelView())));
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Travel")
            .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData) {
            return const Text("Loading...");
          }
          if (snapshot.data!.docs.isEmpty)
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Click on the plus - blue button and add a new travel!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        color: Color.fromARGB(255, 24, 24, 24),
                        fontSize: 16,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ],
              ),
            );
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Travel model = Travel.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>);
              return InkWell(
                  onTap: () => navigateToDetail(snapshot.data!.docs[index]),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              FutureBuilder(
                                future: FirebaseStorage.instance
                                    .refFromURL(model.photo as String)
                                    .getDownloadURL(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.hasData) {
                                    return CircleAvatar(
                                      radius: 50,
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                        snapshot.data.toString(),
                                      ),
                                    );
                                  } else {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                },
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.name as String,
                                    style: GoogleFonts.roboto(
                                        color: Color.fromARGB(255, 24, 24, 24),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    model.destination as String,
                                    style: GoogleFonts.roboto(
                                        color: Color.fromARGB(255, 24, 24, 24),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ],
                              ),
                              Expanded(
                                child: Container(),
                              ),
                              PopupMenuButton(
                                icon:
                                    Icon(Icons.more_vert, color: Colors.black),
                                itemBuilder: (BuildContext context) => [
                                  PopupMenuItem(
                                    child: Text("Edit"),
                                    value: "edit",
                                  ),
                                  PopupMenuItem(
                                    child: Text("Delete"),
                                    value: "delete",
                                  ),
                                ],
                                onSelected: (value) {
                                  if (value == "edit") {
                                    navigateToUpdate(snapshot.data!.docs[index],
                                        snapshot.data!.docs[index].id);
                                  } else if (value == "delete") {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("Confirm Delete"),
                                          content: Text(
                                              "Are you sure you want to delete this item?"),
                                          actions: [
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteTravel(
                                                  snapshot.data!.docs[index].id,
                                                  snapshot.data!.docs[index]
                                                      ["photo"] as String,
                                                );
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          );
        },
      ),
    );
  }

  void deleteTravel(String id, String imageId) {
    FirebaseFirestore.instance
        .collection("Travel")
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        FirebaseStorage.instance
            .refFromURL(imageId)
            .delete()
            .then((_) {})
            .catchError((error) {
          print("Error deleting image: $error");
        });
        documentSnapshot.reference.delete();
      }
    });
  }
}
