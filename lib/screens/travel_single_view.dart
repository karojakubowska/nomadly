import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class SingleTravelPage extends StatefulWidget {
  final DocumentSnapshot? travel;

  SingleTravelPage({this.travel});

  @override
  State<SingleTravelPage> createState() => _SingleTravelPageState();
}

class _SingleTravelPageState extends State<SingleTravelPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          (widget.travel!.get("name")),
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
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              child: Text('Name:' + widget.travel!.get("name")),
            ),
            Container(
                //child: Text('Number of People:' + widget.travel!.get("number_of_people").toString()),
                ),
            Container(
              child: Text('Destination:' + widget.travel!.get("destination")),
            ),
            Container(
              child: Text('Budget:' + widget.travel!.get("budget").toString()),
            ),
            Container(
              child: Text('Number of People:' + widget.travel!.get("number_of_people").toString()),
            ),
            Container(
                //child: Text('Start date:' + widget.travel!.get("start_date").toDate().toString()),
                ),
            Container(
                //child: Text('End date:' + widget.travel!.get("end_date").toDate().toString()),
                ),
            Container(
                //child: Text('To do:' + widget.travel!.get("to_do_list").toString()),
                ),
          ],
        ),
      ),
    );
  }
}
