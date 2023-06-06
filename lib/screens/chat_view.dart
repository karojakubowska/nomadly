// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nomadly_app/screens/chat_single_view.dart';
// import 'package:intl/intl.dart';
//
// import '../utils/app_styles.dart';
// import 'report_form_view.dart';
//
// class Chat extends StatefulWidget {
//   const Chat({Key? key}) : super(key: key);
//
//   @override
//   State<Chat> createState() => _ChatState();
// }
//
// class _ChatState extends State<Chat> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   late String _userId;
//   late Stream<DocumentSnapshot> userStream;
//   late String accountImage;
//
//   @override
//   void initState() {
//     super.initState();
//     final User? user = _auth.currentUser;
//     if (user != null) {
//       _userId = user.uid;
//     }
//     final currentUser = FirebaseAuth.instance.currentUser;
//     userStream = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUser!.uid)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//       backgroundColor: Styles.backgroundColor,
//       appBar: AppBar(
//         title: Text(tr('Chat'), style: Styles.headLineStyle4),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         toolbarTextStyle: TextTheme(
//           subtitle1: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ).bodyText2,
//         titleTextStyle: TextTheme(
//           subtitle1: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ).headline6,
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//           stream: _firestore
//               .collection('ChatMessage')
//               .orderBy('timestamp', descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (!snapshot.hasData) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else {
//               final Map<String, QueryDocumentSnapshot> latestMessages = {};
//               for (final doc in snapshot.data!.docs) {
//                 final String senderId = doc.get('senderId');
//                 final String recipientId = doc.get('recipientId');
//                 final bool is_read = doc.get('isRead');
//                 final String messageId = doc.id;
//                 if (senderId == _userId || recipientId == _userId) {
//                   final String otherUserId =
//                       senderId == _userId ? recipientId : senderId;
//                   final String key = '$otherUserId:$messageId';
//                   if (!latestMessages.containsKey(otherUserId)) {
//                     latestMessages[otherUserId] = doc;
//                   }
//                 }
//               }
//               final List<QueryDocumentSnapshot> latestMessagesList =
//                   latestMessages.values.toList();
//               if (latestMessagesList.isEmpty) {
//                 return Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset(
//                         'assets/images/empty-box.png',
//                         width: 100,
//                         height: 100,
//                       ),
//                       SizedBox(height: 20),
//                       Text(
//                         tr("No messages yet"),
//                         textAlign: TextAlign.center,
//                         style: GoogleFonts.roboto(
//                           color: Color.fromARGB(255, 24, 24, 24),
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }
//               return ListView.builder(
//                   itemCount: latestMessagesList.length,
//                   itemBuilder: (context, index) {
//                     final QueryDocumentSnapshot document =
//                         latestMessagesList[index];
//                     final String senderId = document.get('senderId');
//                     bool is_read = document.get('isRead');
//                     DateTime timestamp = document.get('timestamp').toDate();
//                     String formattedDate =
//                         DateFormat('dd/MM/yyyy').format(timestamp);
//                     final String otherUserId = senderId == _userId
//                         ? document.get('recipientId')
//                         : senderId;
//                     final bool isLastMessage =
//                         index == latestMessagesList.length - 1 && !is_read;
//                     final FontWeight fontWeight =
//                         isLastMessage ? FontWeight.w700 : FontWeight.w400;
//                     return FutureBuilder<DocumentSnapshot>(
//                         future: _firestore
//                             .collection('Users')
//                             .doc(otherUserId)
//                             .get(),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) {
//                             return Container();
//                           } else {
//                             final String otherUserName =
//                                 snapshot.data!.get('Name').toString();
//                             return InkWell(
//                               onTap: () async {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => ChatSingleView(
//                                       userId: _userId,
//                                       otherUserId: otherUserId,
//                                     ),
//                                   ),
//                                 ).then((_) async {
//                                   if (!is_read) {
//                                     await _firestore
//                                         .collection('ChatMessage')
//                                         .doc(document.id)
//                                         .update({'isRead': true});
//                                     setState(() {
//                                       is_read = true;
//                                     });
//                                   }
//                                 });
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.symmetric(
//                                     vertical: 5, horizontal: 10),
//                                 child: Card(
//                                   color:
//                                       is_read ? Colors.white : Colors.grey[200],
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(15),
//                                     child: Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         StreamBuilder<DocumentSnapshot>(
//                                           stream: userStream,
//                                           builder: (context, snapshot) {
//                                             if (snapshot.connectionState ==
//                                                 ConnectionState.waiting) {
//                                               return Center(
//                                                   child:
//                                                       CircularProgressIndicator());
//                                             }
//                                             final userDoc = snapshot.data!;
//                                             accountImage =
//                                                 userDoc.get('AccountImage');
//                                             return FutureBuilder(
//                                               future: FirebaseStorage.instance
//                                                   .refFromURL(accountImage)
//                                                   .getDownloadURL(),
//                                               builder: (BuildContext context,
//                                                   AsyncSnapshot<dynamic>?
//                                                       snapshot) {
//                                                 if (snapshot?.hasData == true) {
//                                                   return CircleAvatar(
//                                                       radius: 30.0,
//                                                       backgroundImage:
//                                                           NetworkImage(snapshot!
//                                                               .data
//                                                               .toString()));
//                                                 } else {
//                                                   return const Center(
//                                                       child:
//                                                           CircularProgressIndicator());
//                                                 }
//                                               },
//                                             );
//                                           },
//                                         ),
//                                         SizedBox(width: 15),
//                                         Expanded(
//                                           child: Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Text(
//                                                 otherUserName,
//                                                 style: GoogleFonts.roboto(
//                                                   color: Color.fromARGB(
//                                                       255, 24, 24, 24),
//                                                   fontSize: 16,
//                                                   fontWeight: fontWeight,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 7),
//                                               Text(
//                                                 document.get('text').length > 30
//                                                     ? '${document.get('text').substring(0, 30)}...'
//                                                     : document.get('text'),
//                                                 style: GoogleFonts.roboto(
//                                                   color: Color.fromARGB(
//                                                       255, 24, 24, 24),
//                                                   fontSize: 12,
//                                                   fontWeight: fontWeight,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 7),
//                                               Text(
//                                                 formattedDate,
//                                                 style: GoogleFonts.roboto(
//                                                   color: Color.fromARGB(
//                                                       130, 30, 30, 30),
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w300,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Positioned(
//                                           right: -30,
//                                           top: 50,
//                                           child: PopupMenuButton(
//                                             itemBuilder:
//                                                 (BuildContext context) =>
//                                                     <PopupMenuEntry>[
//                                               PopupMenuItem(
//                                                 child: Text(tr("Report")),
//                                                 value: 2,
//                                               ),
//                                             ],
//                                             onSelected: (value) {
//                                               if (value == 2) {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         ReportFormView(
//                                                       otherUserId: otherUserId,
//                                                     ),
//                                                   ),
//                                                 );
//                                               }
//                                             },
//                                             icon: Icon(Icons.more_vert),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }
//                         });
//                   });
//             }
//           }));
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';

import '../utils/app_styles.dart';
import 'report_form_view.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userId;
  late Stream<DocumentSnapshot> userStream;
  late String accountImage;

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
    final currentUser = FirebaseAuth.instance.currentUser;
    userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;

    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        title: Text(tr('Chat'), style: Styles.headLineStyle4),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarTextStyle: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).bodyText2,
        titleTextStyle: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).headline6,
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _firestore
              .collection('ChatMessage')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final Map<String, QueryDocumentSnapshot> latestMessages = {};
              for (final doc in snapshot.data!.docs) {
                final String senderId = doc.get('senderId');
                final String recipientId = doc.get('recipientId');
                final bool is_read = doc.get('isRead');
                final String messageId = doc.id;
                if (senderId == _userId || recipientId == _userId) {
                  final String otherUserId =
                      senderId == _userId ? recipientId : senderId;
                  final String key = '$otherUserId:$messageId';
                  if (!latestMessages.containsKey(otherUserId)) {
                    latestMessages[otherUserId] = doc;
                  }
                }
              }
              List<QueryDocumentSnapshot> latestMessagesList =
                  latestMessages.values.toList();

              latestMessagesList.sort((a, b) {
                final bool isReadA = a.get('isRead');
                final bool isReadB = b.get('isRead');
                if (isReadA && !isReadB) {
                  return 1;
                } else if (!isReadA && isReadB) {
                  return -1;
                } else {
                  final DateTime timestampA = a.get('timestamp').toDate();
                  final DateTime timestampB = b.get('timestamp').toDate();
                  return timestampB.compareTo(timestampA);
                }
              });
              if (latestMessagesList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty-box.png',
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(height: 20),
                      Text(
                        tr("No messages yet"),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          color: Color.fromARGB(255, 24, 24, 24),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemCount: latestMessagesList.length,
                itemBuilder: (context, index) {
                  final QueryDocumentSnapshot document = latestMessagesList[index];
                  final String senderId = document.get('senderId');
                  bool isRead = document.get('isRead');
                  final DateTime timestamp = document.get('timestamp').toDate();
                  final String formattedDate = DateFormat('dd/MM/yyyy').format(timestamp);
                  final String otherUserId = senderId == _userId ? document.get('recipientId') : senderId;
                  final bool isLastMessage = index == latestMessagesList.length - 1 && !isRead;
                  final bool isOtherUserMessage = senderId != _userId;

                  return FutureBuilder<DocumentSnapshot>(
                    future: _firestore.collection('Users').doc(otherUserId).get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      } else {
                        final String otherUserName = snapshot.data!.get('Name').toString();
                        final Color? messageColor = isOtherUserMessage && !isRead ? Colors.blue[200] : Colors.white;
                        final FontWeight fontWeight = isOtherUserMessage && !isRead ? FontWeight.w700 : FontWeight.w400;
                        final String otherUserAccountImage = snapshot.data!.get('AccountImage').toString();

                        return InkWell(
                          onTap: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatSingleView(
                                  userId: _userId,
                                  otherUserId: otherUserId,
                                ),
                              ),
                            ).then((_) async {
                              if (!isRead) {
                                await _firestore
                                    .collection('ChatMessage')
                                    .doc(document.id)
                                    .update({'isRead': true});
                                setState(() {
                                  isRead = true;
                                });
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            child: Card(
                              color: messageColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    StreamBuilder<DocumentSnapshot>(
                                      stream: _firestore.collection('Users').doc(otherUserId).snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        final userDoc = snapshot.data!;
                                        accountImage =
                                            userDoc.get('AccountImage');
                                        return FutureBuilder(
                                          future: FirebaseStorage.instance
                                              .refFromURL(accountImage)
                                              .getDownloadURL(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<dynamic>?
                                                  snapshot) {
                                            if (snapshot?.hasData == true) {
                                              return CircleAvatar(
                                                radius: 30.0,
                                                backgroundImage: NetworkImage(
                                                  snapshot!.data.toString(),
                                                ),
                                              );
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                                    SizedBox(width: 15),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            otherUserName,
                                            style: GoogleFonts.roboto(
                                              color:
                                                  isOtherUserMessage && !isRead
                                                      ? Colors.white
                                                      : Color.fromARGB(
                                                          255, 24, 24, 24),
                                              fontSize: 16,
                                              fontWeight: fontWeight,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            document.get('text').length > 30
                                                ? '${document.get('text').substring(0, 30)}...'
                                                : document.get('text'),
                                            style: GoogleFonts.roboto(
                                              color: Color.fromARGB(
                                                  255, 24, 24, 24),
                                              fontSize: 12,
                                              fontWeight: fontWeight,
                                            ),
                                          ),
                                          SizedBox(height: 7),
                                          Text(
                                            formattedDate,
                                            style: GoogleFonts.roboto(
                                              color: Color.fromARGB(
                                                  130, 30, 30, 30),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      right: -30,
                                      top: 50,
                                      child: PopupMenuButton(
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            child: Text(tr("Report")),
                                            value: 2,
                                          ),
                                        ],
                                        onSelected: (value) {
                                          if (value == 2) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ReportFormView(
                                                  otherUserId: otherUserId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(Icons.more_vert),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
            ;
          }),
    );
  }
}
