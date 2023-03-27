import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';

import '../utils/app_styles.dart';

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
      backgroundColor: Styles.backgroundColor,
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
      // body: StreamBuilder<QuerySnapshot>(
      //     stream: _firestore
      //         .collection('ChatMessage')
      //         //.where('recipientId', isEqualTo: _userId)
      //         //.orderBy('timestamp', descending: true)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       } else {
      //         final List<QueryDocumentSnapshot> documents = snapshot.data!.docs
      //             .where((doc) =>
      //                 doc.get('recipientId') == _userId ||
      //                 doc.get('senderId') == _userId)
      //             .toList();
      //         // final Map<String, QueryDocumentSnapshot> lastMessages = {};
      //         // for (final document in documents) {
      //         //   final senderId = document.get('senderId');
      //         //   if (!lastMessages.containsKey(senderId)) {
      //         //     lastMessages[senderId] = document;
      //         //   }
      //         // }
      //         // final List<QueryDocumentSnapshot> lastMessagesList =
      //         //     lastMessages.values.toList();
      //         // lastMessagesList.sort(
      //         //       (a, b) => b.get('timestamp').compareTo(a.get('timestamp')),
      //         // );
      //         QueryDocumentSnapshot? lastDocument;
      //         for (final document in documents) {
      //           if (lastDocument == null) {
      //             lastDocument = document;
      //           } else {
      //             final lastTimestamp = lastDocument.get('timestamp');
      //             final currentTimestamp = document.get('timestamp');
      //             if (currentTimestamp.compareTo(lastTimestamp) > 0) {
      //               lastDocument = document;
      //             }
      //           }
      //         }
      //         if (lastDocument == null) {
      //           return Container();
      //         }
      //         return ListView.builder(
      //             itemCount: 1,
      //             itemBuilder: (context, index) {
      //               final QueryDocumentSnapshot document =
      //                   lastDocument!;
      //               final bool is_read = document.get('isRead');
      //               final FontWeight fontWeight =
      //                   is_read ? FontWeight.w400 : FontWeight.w700;
      //
      //               final senderId = document.get('senderId');
      //               final otherUserId = senderId == _userId
      //                   ? document.get('recipientId')
      //                   : document.get('senderId');
      //               return FutureBuilder<DocumentSnapshot>(
      //                   future: _firestore
      //                       .collection('Users')
      //                       .doc(otherUserId)
      //                       .get(),
      //                   builder: (context, snapshot) {
      //                     if (!snapshot.hasData) {
      //                       return Container();
      //                     } else {
      //                       final String otherUserName =
      //                           snapshot.data!.get('Name').toString();
      //                       return InkWell(
      //                         onTap: () {
      //                           Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                               builder: (context) => ChatSingleView(
      //                                   userId: _userId,
      //                                   otherUserId: otherUserId),
      //                               // tu trzeba poprawić
      //                             ),
      //                           );
      //                         },
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('ChatMessage')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final List<QueryDocumentSnapshot> documents = snapshot.data!.docs
                  .where((doc) =>
              doc.get('recipientId') == _userId ||
                  doc.get('senderId') == _userId)
                  .toList();
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final QueryDocumentSnapshot document = documents[index];
                    final bool is_read = document.get('isRead');
                    final FontWeight fontWeight =
                    is_read ? FontWeight.w400 : FontWeight.w700;

                    final senderId = document.get('senderId');
                    final otherUserId = senderId == _userId
                        ? document.get('recipientId')
                        : document.get('senderId');
                    return FutureBuilder<DocumentSnapshot>(
                        future: _firestore
                            .collection('Users')
                            .doc(otherUserId)
                            .get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            final String otherUserName =
                            snapshot.data!.get('Name').toString();
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatSingleView(
                                      userId: _userId,
                                      otherUserId: otherUserId,
                                    ),
                                  ),
                                );
                              },
      // body: StreamBuilder<QuerySnapshot>(
      //     stream: _firestore
      //         .collection('ChatMessage')
      //     //.where('recipientId', isEqualTo: _userId)
      //     //.orderBy('timestamp', descending: true)
      //         .snapshots(),
      //     builder: (context, snapshot) {
      //       if (!snapshot.hasData) {
      //         return const Center(
      //           child: CircularProgressIndicator(),
      //         );
      //       } else {
      //         final List<QueryDocumentSnapshot> documents = snapshot.data!.docs.where((doc) =>
      //         doc.get('recipientId') == _userId ||
      //             doc.get('senderId') == _userId).toList();
      //         final Map<String, QueryDocumentSnapshot> lastMessages = {};
      //         for (final document in documents) {
      //           final senderId = document.get('senderId');
      //           if (!lastMessages.containsKey(senderId)) {
      //             lastMessages[senderId] = document;
      //           }
      //         }
      //         final List<QueryDocumentSnapshot> lastMessagesList =
      //         lastMessages.values.toList();
      //         // lastMessagesList.sort(
      //         //       (a, b) => b.get('timestamp').compareTo(a.get('timestamp')),
      //         // );
      //         return ListView.builder(
      //             itemCount: 1,
      //             itemBuilder: (context, index) {
      //               final QueryDocumentSnapshot document = lastMessagesList.first;
      //               final bool is_read = document.get('isRead');
      //               final FontWeight fontWeight =
      //               is_read ? FontWeight.w400 : FontWeight.w700;
      //
      //               final senderId = document.get('senderId');
      //               final otherUserId =  senderId == _userId ? document.get('recipientId') : document.get('senderId');
      //               return FutureBuilder<DocumentSnapshot>(
      //                   future: _firestore.collection('Users').doc(otherUserId).get(),
      //                   builder: (context, snapshot) {
      //                     if (!snapshot.hasData) {
      //                       return Container();
      //                     } else {
      //                       final String otherUserName = snapshot.data!.get('Name').toString();
      //                       return InkWell(
      //                         onTap: () {
      //                           Navigator.push(
      //                             context,
      //                             MaterialPageRoute(
      //                               builder: (context) =>
      //                                   ChatSingleView(userId: _userId, otherUserId: otherUserId),
      //                               // tu trzeba poprawić
      //                             ),
      //                           );
      //                         },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(otherUserName,
                                                  style: GoogleFonts.roboto(
                                                      color: Color.fromARGB(
                                                          255, 24, 24, 24),
                                                      fontSize: 16,
                                                      fontWeight: fontWeight)),
                                              SizedBox(height: 5),
                                              Text(
                                                document.get('text').length > 30
                                                    ? '${document.get('text').substring(0, 30)}...'
                                                    : document.get('text'),
                                                style: GoogleFonts.roboto(
                                                    color: Color.fromARGB(
                                                        255, 24, 24, 24),
                                                    fontSize: 12,
                                                    fontWeight: fontWeight),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Text(document.get('send_date').toString()),
                                        Positioned(
                                          right: -30,
                                          top: 50,
                                          child: PopupMenuButton(
                                            itemBuilder:
                                                (BuildContext context) =>
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
                          }
                          ;
                        });
                  });
            }
          }));
}
