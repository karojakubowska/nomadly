import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/screens/add_travel_view.dart';
import 'package:nomadly_app/screens/travel_single_view.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
              color: Colors.black,
              icon: Icon(Icons.delete),
              onPressed: () async {
                //usuwanie
              })
        ],
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //         context,
      //         MaterialPageRoute(
      //             builder: ((context) => AddTravelView())));
      //   },
      //   backgroundColor: Colors.blue,
      //   child: Icon(Icons.add),
      // ),

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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // CircleAvatar(
                            //   radius: 30,
                            //   backgroundImage: NetworkImage(model.photo as String
                            //   ),
                            // ),
                            SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(model.name as String),
                                SizedBox(height: 5),
                                Text(
                                  model.destination as String,
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                              ],
                            ),
                            Padding(
                                padding: const EdgeInsets.only(left: 100.0)),
                            //Text(model.start_date?.toDate().toString( as String),
                          ],
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
}
