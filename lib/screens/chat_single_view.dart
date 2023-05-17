import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/app_styles.dart';

class ChatSingleView extends StatefulWidget {
  final String userId;
  final String otherUserId;

  const ChatSingleView({
    Key? key,
    required this.userId,
    required this.otherUserId,
  }) : super(key: key);

  @override
  _ChatSingleViewState createState() => _ChatSingleViewState();
}

class _ChatSingleViewState extends State<ChatSingleView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userId;

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userId = user.uid;
    }

    _firestore
        .collection('ChatMessage')
        .where('senderId', isEqualTo: widget.otherUserId)
        .where('recipientId', isEqualTo: widget.userId)
        .where('isRead', isEqualTo: false)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        _markMessageAsRead(doc.id);
      });
    });
  }

  Future<void> _sendMessage() async {
    await _firestore.collection('ChatMessage').add({
      'senderId': _userId,
      'recipientId': widget.otherUserId,
      'text': _messageController.text,
      'isRead': false,
      'timestamp': Timestamp.now(),
    });

    _messageController.clear();
  }

  Future<void> _markMessageAsRead(String messageId) async {
    await _firestore.collection('ChatMessage').doc(messageId).update({
      'isRead': true,
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .doc(widget.otherUserId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Text(
                widget.otherUserId,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                        fontSize: 20.0,
                        height: 1.2,
                        color: Colors.black,
                        fontWeight: FontWeight.w700)),
              );
            }
            final String otherUserName = snapshot.data!.get('Name').toString();
            return Text(
              otherUserName,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                      fontSize: 20.0,
                      height: 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.w700)),
            );
          },
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
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('ChatMessage')
                  .where('senderId', isEqualTo: widget.userId)
                  .where('recipientId', isEqualTo: widget.otherUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final List<DocumentSnapshot> senderMessages =
                    snapshot.data!.docs;
                return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('ChatMessage')
                      .where('senderId', isEqualTo: widget.otherUserId)
                      .where('recipientId', isEqualTo: widget.userId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final List<DocumentSnapshot> otherUserMessages =
                        snapshot.data!.docs;
                    final List<DocumentSnapshot> allMessages = [
                      ...senderMessages,
                      ...otherUserMessages
                    ];
                    allMessages.sort(
                        (a, b) => a['timestamp'].compareTo(b['timestamp']));
                   return ListView.builder(
                      reverse: false,
                      itemCount: allMessages.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot message = allMessages[index];
                        final bool isMe = message['senderId'] == _userId;
                        final String messageId = message.id; // dodajemy pobranie ID dokumentu
                        DateTime timestamp = message['timestamp'].toDate();
                        String formattedDate = DateFormat('HH:mm\n dd/MM/yyyy').format(timestamp);
                        return GestureDetector(
                            onTap: () {
                          if (!isMe && !message['isRead']) {
                            _markMessageAsRead(messageId);
                          }
                        },
                        child: Align(
                        alignment: isMe
                        ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: SizedBox(
                        width: 250,
                        child: Container(
                    // return ListView.builder(
                    //   reverse: false,
                    //   itemCount: allMessages.length,
                    //   itemBuilder: (context, index) {
                    //     final DocumentSnapshot message = allMessages[index];
                    //     final bool isMe = message['senderId'] == _userId;
                    //     DateTime timestamp = message['timestamp'].toDate();
                    //     String formattedDate =
                    //         DateFormat('HH:mm\n dd/MM/yyyy').format(timestamp);
                    //     return Align(
                    //       alignment: isMe
                    //           ? Alignment.centerRight
                    //           : Alignment.centerLeft,
                    //       child: SizedBox(
                    //         width: 250,
                    //         child: Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 15),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: isMe ? Colors.blue : Colors.grey[300],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message['text'],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: isMe ? Colors.white : Colors.black,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(child: Container()),
                                      Expanded(
                                        child: Text(
                                          formattedDate,
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                      },
                    );
                  },
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: ' Write Something...',
                      contentPadding: EdgeInsets.symmetric(horizontal: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                  color: Theme.of(context).primaryColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
