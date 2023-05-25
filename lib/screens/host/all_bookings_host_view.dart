import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/host/booking_card_host.dart';

import '../../models/Accomodation.dart';
import '../../models/Booking.dart';
import '../../utils/app_layout.dart';
import '../../utils/app_styles.dart';

class AllBookingsHostScreen extends StatefulWidget {
  const AllBookingsHostScreen({super.key});

  @override
  State<AllBookingsHostScreen> createState() => _AllBookingsScreenState();
}

class _AllBookingsScreenState extends State<AllBookingsHostScreen> {
  Query query = FirebaseFirestore.instance.collection("Bookings");
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final String userID = user!.uid;

    var size = AppLayout.getSize(context);
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          backgroundColor: Styles.backgroundColor,
          title: Text('Bookings', style: Styles.headLineStyle4),
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
          children: [
            Column(
              children: [
                const Gap(10),
                SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: size.height * 0.78,
                        width: size.width * 0.9,
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("Bookings")
                              .where('host_id',
                                  isEqualTo: userID)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const Text("Loading...");
                            if (snapshot.data!.docs.isEmpty) {
                              return Container(
                                margin: const EdgeInsets.only(top: 20),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Find your new bookings!",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          color: const Color.fromARGB(255, 24, 24, 24),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  return StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Accommodations')
                                          .where(FieldPath.documentId,
                                              isEqualTo:
                                                  snapshot.data!.docs[index]
                                                      ['accommodation_id'])
                                          .snapshots(),
                                      builder: (context, snap) {
                                        if (!snap.hasData)
                                          return const Text("Loading...");
                                        Acommodation model =
                                            Acommodation.fromJson(
                                                snap.data!.docs[0].data()
                                                    as Map<String, dynamic>);
                                        Booking booking = Booking.fromJson(
                                            snapshot.data!.docs[index].data()
                                                as Map<String, dynamic>);
                                                booking.id=snapshot.data!.docs[index].id;

                                        return BookingCardHost(
                                          booking: booking,
                                          index: index,
                                          accommodation: model,
                                        );
                                      });
                                });
                          },
                        ),
                      )
                    ])),
              ],
            ),
          ],
        ));
  }
}
// import 'package:flutter/material.dart';

// class AllBookingsHostScreen extends StatefulWidget {
//   const AllBookingsHostScreen({
//     Key? key,
//   }) : super(key: key);

//   @override
//   State<AllBookingsHostScreen> createState() => _AllBookingsScreenState();
// }

// class _AllBookingsScreenState extends State<AllBookingsHostScreen> {
//   List<String> images = [
//     "https://fastly.picsum.photos/id/0/5000/3333.jpg?hmac=_j6ghY5fCfSD6tvtcV74zXivkJSPIfR9B8w34XeQmvU",
//     "https://fastly.picsum.photos/id/10/2500/1667.jpg?hmac=J04WWC_ebchx3WwzbM-Z4_KC_LeLBWr5LZMaAkWkF68",
//     "https://fastly.picsum.photos/id/17/2500/1667.jpg?hmac=HD-JrnNUZjFiP2UZQvWcKrgLoC_pc_ouUSWv8kHsJJY"
//   ];
//   int _currentIndex = 0;
//   PageController _pageController = PageController(initialPage: 0);

//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   Container(
//                     height: 400,
//                     child: ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       physics: const PageScrollPhysics(),
//                       itemCount: 5,
//                       itemBuilder: (BuildContext context, int index) {
//                         return Image.network(
//                           'https://picsum.photos/id/$index/200/300',
//                         );
//                       },
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         )
//     );
//   }
// }


