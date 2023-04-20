import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SingleTravelPage extends StatefulWidget {
  final DocumentSnapshot? travel;

  SingleTravelPage({this.travel});

  @override
  State<SingleTravelPage> createState() => _SingleTravelPageState();
}

class _SingleTravelPageState extends State<SingleTravelPage> {
//   Widget _buildTravelInfo(String label, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//             ),
//           ),
//           Text(
//             text,
//             style: TextStyle(
//               color: Colors.black,
//               fontWeight: FontWeight.w400,
//               fontSize: 16,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SingleChildScrollView(
//             child: Column(children: [
//       Stack(
//         children: [
//           FutureBuilder(
//             future: FirebaseStorage.instance
//                 .refFromURL(widget.travel!.get("photo"))
//                 .getDownloadURL(),
//             builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//               if (snapshot.hasData) {
//                 return Image(
//                   height: 400,
//                   width: MediaQuery.of(context).size.width,
//                   fit: BoxFit.cover,
//                   image: NetworkImage(snapshot.data.toString()),
//                 );
//               } else {
//                 return Center(child: CircularProgressIndicator());
//               }
//             },
//           ),
//           Container(
//             height: 400,
//             color: Colors.black12,
//             padding: EdgeInsets.only(top: 50),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(left: 24, right: 24),
//                   child: Row(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           Navigator.pop(context);
//                         },
//                         child: Container(
//                           child: Icon(
//                             Icons.arrow_back,
//                             color: Colors.white,
//                             size: 24,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Spacer(),
//                 Container(
//                   width: MediaQuery.of(context).size.width,
//                   decoration: const BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(40),
//                       topRight: Radius.circular(40),
//                     ),
//                   ),
//                   height: 40,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       Container(
//         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//         width: MediaQuery.of(context).size.width,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.travel!.get("name"),
//               style: TextStyle(
//                 color: Color.fromARGB(255, 24, 24, 24),
//                 fontSize: 22,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             Text(
//               widget.travel!.get("destination"),
//               style: TextStyle(
//                 color: Color.fromARGB(255, 24, 24, 24),
//                 fontSize: 22,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//             _buildTravelInfo(
//               "Budget:",
//               widget.travel!.get("budget").toString(),
//             ),
//             _buildTravelInfo(
//               "Number of People:",
//               widget.travel!.get("number_of_people").toString(),
//             ),
//             _buildTravelInfo(
//               "Start Date:",
//               widget.travel!.get("start_date").toDate().toString(),
//             ),
//             _buildTravelInfo(
//               "End Date:",
//               widget.travel!.get("end_date").toDate().toString(),
//             ),
//           ],
//         ),
//       )
//     ])));
//   }
// }

  // Widget _buildTravelInfo(String label, String text, IconData icon) {
  //   return Card(
  //     elevation: 2,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           Row(
  //             children: [
  //               Icon(icon),
  //               SizedBox(width: 8),
  //               Text(
  //                 label,
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.w700,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ],
  //           ),
  //           Text(
  //             text,
  //             style: TextStyle(
  //               color: Colors.black,
  //               fontWeight: FontWeight.w400,
  //               fontSize: 16,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }


  // Widget _buildTravelInfo(String label, String text, IconData icon) {
  //   return Card(
  //     elevation: 1,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //       child: Row(
  //         children: [
  //           Expanded(
  //             child: Row(
  //               children: [
  //                 Icon(icon),
  //                 Text(
  //                   label,
  //                   style: TextStyle(
  //                     color: Colors.black,
  //                     fontWeight: FontWeight.w700,
  //                     fontSize: 10,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Expanded(
  //             child: Text(
  //               text,
  //               style: TextStyle(
  //                 color: Colors.black,
  //                 fontWeight: FontWeight.w400,
  //                 fontSize: 10,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildTravelInfo(
      String label1, String text1, IconData icon1,
      String label2, String text2, IconData icon2) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(icon1),
                        SizedBox(width: 8),
                        Text(
                          label1,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      text1,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[400]!,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(icon2),
                        SizedBox(width: 8),
                        Text(
                          label2,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      text2,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              if (snapshot.hasData) {
                return Image(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  image: NetworkImage(snapshot.data.toString()),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
          Container(
            height: 400,
            color: Colors.black12,
            padding: EdgeInsets.only(top: 50),
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
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: MediaQuery.of(context).size.width,
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
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.travel!.get("name"),
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 25.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w500)),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            _buildTravelInfo(
              "Destination:",
              widget.travel!.get("destination"),
              Icons.pin_drop,
              "Budget:",
              widget.travel!.get("budget").toString(),
              Icons.attach_money,
            ),
            _buildTravelInfo(
              "Number of People:",
              widget.travel!.get("number_of_people").toString(),
              Icons.people,
              "Number of People:",
              widget.travel!.get("number_of_people").toString(),
              Icons.people,
            ),
            _buildTravelInfo(
              "Start Date:",
              DateFormat('dd/MM/yyyy').format(widget.travel!.get("start_date").toDate()),
              Icons.calendar_today,
              "End Date:",
              DateFormat('dd/MM/yyyy').format(widget.travel!.get("end_date").toDate()),
              Icons.calendar_today
            ),
          ],
        ),
      )
    ])));
  }
}
