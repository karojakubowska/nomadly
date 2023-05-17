import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';
import 'package:intl/intl.dart';

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
              final List<QueryDocumentSnapshot> latestMessagesList =
                  latestMessages.values.toList();
              if (latestMessagesList.isEmpty) {
                return Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                            color: Color.fromARGB(255, 24, 24, 24),
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
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
                    final bool is_read = document.get('isRead');
                    DateTime timestamp = document.get('timestamp').toDate();
                    String formattedDate = DateFormat('dd/MM/yyyy').format(timestamp);
                    final String otherUserId =
                    senderId == _userId ? document.get('recipientId') : senderId;
                    final bool isLastMessage =
                        index == latestMessagesList.length - 1 && !is_read;
                    final FontWeight fontWeight =
                    isLastMessage ? FontWeight.w400 : FontWeight.w700;
                    return FutureBuilder<DocumentSnapshot>(
                        future: _firestore.collection('Users').doc(otherUserId).get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container();
                          } else {
                            final String otherUserName = snapshot.data!.get('Name').toString();
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
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StreamBuilder<DocumentSnapshot>(
                                          stream: userStream,
                                          builder: (context, snapshot) {
                                            if (snapshot.connectionState ==
                                                ConnectionState.waiting) {
                                              return Center(
                                                  child:
                                                      CircularProgressIndicator());
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
                                                      backgroundImage:
                                                          NetworkImage(snapshot!
                                                              .data
                                                              .toString()));
                                                } else {
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
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
                                              Text(otherUserName,
                                                  style: GoogleFonts.roboto(
                                                      color: Color.fromARGB(
                                                          255, 24, 24, 24),
                                                      fontSize: 16,
                                                      fontWeight: fontWeight)),
                                              SizedBox(height: 7),
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
                                              SizedBox(height: 7),
                                              Text(formattedDate,
                                                  style: GoogleFonts.roboto(
                                                      color: Color.fromARGB(
                                                          130, 30, 30, 30),
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w300)),
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
                                                child: Text("Report"),
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
