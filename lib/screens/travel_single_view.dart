import 'package:nomadly_app/models/Travel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SingleTravelPage extends StatefulWidget {
  final DocumentSnapshot? travel;
  SingleTravelPage({this.travel});

  @override
  State<SingleTravelPage> createState() => _SingleTravelPageState();
}

class _SingleTravelPageState extends State<SingleTravelPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Card(
          child: ListTile(
            title: Text(widget.travel!.get("name")),
          ),
        )
    );
  }
}
