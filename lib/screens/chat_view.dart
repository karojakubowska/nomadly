// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nomadly_app/screens/chat_single_view.dart';
//
// class Chat extends StatefulWidget {
//   const Chat({Key? key}) : super(key: key);
//
//   @override
//   State<Chat> createState() => _ChatState();
// }
//
// class _ChatState extends State<Chat> {
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(
//       title: Text(
//         'Chat',
//         textAlign: TextAlign.center,
//         style: GoogleFonts.roboto(
//             textStyle: TextStyle(
//                 fontSize: 20.0,
//                 height: 1.2,
//                 color: Colors.black,
//                 fontWeight: FontWeight.w700)),
//       ),
//       centerTitle: true,
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       textTheme: TextTheme(
//         subtitle1: TextStyle(
//           color: Colors.black,
//           fontSize: 20,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     ),
//     body: ListView.builder(
//       itemCount: 3,
//       itemBuilder: (context, index) {
//         return InkWell(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) =>
//                     SingleChatPage(name: '', avatarUrl: ''),
//               ),
//             );
//           },
//           child: Container(
//             margin: EdgeInsets.symmetric(vertical: 10),
//             child: Card(
//               child: Padding(
//                 padding: EdgeInsets.all(15),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CircleAvatar(
//                       radius: 30,
//                       backgroundImage: NetworkImage(
//                         'https://pbs.twimg.com/profile_images/1132273809079554048/CNV5-_GG_400x400.jpg',
//                       ),
//                     ),
//                     SizedBox(width: 15),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Imię Nazwisko'),
//                           SizedBox(height: 5),
//                           Text(
//                             'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'.substring(0,50) + '...',
//                             style: Theme.of(context).textTheme.bodyText2,
//                           ),
//                         ],
//                       ),
//                     ),
//                     Text('10:15 AM'),
//                     Positioned(
//                       right: -30,
//                       top: 50,
//                       child: PopupMenuButton(
//                         itemBuilder: (BuildContext context) => <PopupMenuEntry>[
//                           PopupMenuItem(
//                             child: Text("Delete"),
//                             value: 1,
//                           ),
//                           PopupMenuItem(
//                             child: Text("Report"),
//                             value: 2,
//                           ),
//                         ],
//                         onSelected: (value) {
//                           // Do something
//                         },
//                         icon: Icon(Icons.more_vert),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     ),
//   );
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late String _userId;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        centerTitle: true,
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
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('Messages')
              .where('recipient_id', isEqualTo: _userId)
              //.orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            } else {
              final List<DocumentSnapshot> documents = snapshot.data!.docs;
              return ListView.builder(
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot document = documents[index];
                  final bool is_read = document.get('is_read');
                  final FontWeight fontWeight =
                      is_read ? FontWeight.w400 : FontWeight.w700;
                  //to nie działa
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SingleChatPage(name: '', avatarUrl: ''),
                        ),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  'https://pbs.twimg.com/profile_images/1132273809079554048/CNV5-_GG_400x400.jpg',
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(document.get('sender_id')),
                                    SizedBox(height: 5),
                                    Text(
                                      document.get('message')
                                              .substring(0,10) +
                                          '...',
                                      //substring co zrobic jesli wiadomosc bedzie bardzo krótka?
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                              Text(document.get('send_date').toString()),
                              Positioned(
                                right: -30,
                                top: 50,
                                child: PopupMenuButton(
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: Text("Delete"),
                                      value: 1,
                                    ),
                                    PopupMenuItem(
                                      child: Text("Report"),
                                      value: 2,
                                    ),
                                  ],
                                  onSelected: (value) {
                                    // Do something
                                  },
                                  icon: Icon(Icons.more_vert),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }));
}
