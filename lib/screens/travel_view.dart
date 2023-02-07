import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/screens/add_travel_view.dart';
import 'package:nomadly_app/screens/travel_single_view.dart';
import 'package:nomadly_app/screens/update_travel_view.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class TravelView extends StatefulWidget {
  const TravelView({Key? key}) : super(key: key);

  @override
  State<TravelView> createState() => _TravelViewState();
}

class _TravelViewState extends State<TravelView> {
  Future<QuerySnapshot>? allTravelDocumentList =
      FirebaseFirestore.instance.collectionGroup("Travel").get();
  Future<QuerySnapshot>? travelDocumentList;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
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
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 90.0, right: 20.0),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: ((context) => AddTravelView())));
          },
        ),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance.collectionGroup("Travel").get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: Text("Loading..."));
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Travel model = Travel.fromJson(
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>);
              return InkWell(
                  onTap: () => navigateToDetail(snapshot.data!.docs[index]),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                //backgroundImage: NetworkImage(model.photo as String),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(model.name as String),
                                  SizedBox(height: 5),
                                  Text(
                                    model.destination as String,
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
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
                                  } else {
                                    deleteTravel(snapshot.data!.docs[index].id);
                                  }
                                },
                              ),
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

  void deleteTravel(documentId) async {
    var db = FirebaseFirestore.instance;
    db.collection("Travel").doc(documentId).delete().then((_) {
      print("Document successfully deleted!");
    }).catchError((error) {
      print("Error removing document: $error");
    });
  }
}
