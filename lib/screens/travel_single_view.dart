import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/screens/todo_view.dart';

class SingleTravelPage extends StatefulWidget {
  final DocumentSnapshot? travel;

  SingleTravelPage({this.travel});

  @override
  State<SingleTravelPage> createState() => _SingleTravelPageState();
}

class _SingleTravelPageState extends State<SingleTravelPage> {
  final nameController = TextEditingController();
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  final number_of_peopleController = TextEditingController();
  final noteController = TextEditingController();

  CollectionReference travel = FirebaseFirestore.instance.collection('Travel');
  late String imageOld = " ";
  late DateTime startDate;
  late DateTime endDate;

  void initState() {
    super.initState();
    nameController.text = (widget.travel!.get("name"));
    destinationController.text = (widget.travel!.get("destination"));
    noteController.text = (widget.travel!.get("note"));
    budgetController.text = (widget.travel!.get("budget").toString());
    number_of_peopleController.text =
    (widget.travel!.get("number_of_people").toString());
    startDate = (widget.travel!.get("start_date") as Timestamp).toDate();
    endDate = (widget.travel!.get("end_date") as Timestamp).toDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
              Stack(
                children: [
                  FutureBuilder(
                    future: FirebaseStorage.instance
                        .refFromURL(widget.travel!.get("photo"))
                        .getDownloadURL(),
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        return Image(
                          height: 400,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data.toString()),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                  Container(
                    height: 400,
                    color: Colors.black12,
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24, right: 24),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              topRight: Radius.circular(40),
                            ),
                          ),
                          height: 40,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    tr("Travel Details"),
                    style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 16.0,
                            height: 1.2,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: nameController,
                  enabled: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: tr('Name'),
                    prefixIcon: const Icon(Icons.near_me, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: destinationController,
                  enabled: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: tr('Destination'),
                    prefixIcon: const Icon(Icons.place, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: budgetController,
                  enabled: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: tr('Budget'),
                    prefixIcon: const Icon(Icons.monetization_on, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              prefixIcon: const Icon(Icons.calendar_month_outlined,
                                  color: Colors.grey),
                              labelText: tr('Start Date'),
                              enabled: false,
                              hintText: tr('Please select a start date'),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                              text: startDate == null
                                  ? ''
                                  : DateFormat('dd-MM-yyyy').format(startDate),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.transparent,
                              labelText: tr('End Date'),
                              prefixIcon: const Icon(Icons.calendar_month_outlined,
                                  color: Colors.grey),
                              enabled: false,
                              hintText: tr('Please select an end date'),
                            ),
                            readOnly: true,
                            controller: TextEditingController(
                              text: endDate == null
                                  ? ''
                                  : DateFormat('dd-MM-yyyy').format(endDate),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: number_of_peopleController,
                  enabled: false,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: tr('Number of People'),
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: noteController,
                  enabled: false,
                  maxLines: 5,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: tr('Note'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                        width: 1,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.transparent,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
                  onPressed: () async {
                    final todoList = await Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context)
                    =>
                        ToDoListScreen(
                          travelDocumentId: widget.travel!.id,
                        )
                    )
                    );
                  },
                  icon: const Icon(Icons.lock_open, size: 0),
                  label:
                  Text(tr('To do list'), style: TextStyle(fontSize: 20)),
                ),
              )
            ])));
  }
}
