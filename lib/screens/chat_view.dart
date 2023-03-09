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
              .collection('ChatMessage')
              .where('recipientId', isEqualTo: _userId)
              .orderBy('timestamp', descending: true)
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
                  final bool is_read = document.get('isRead');
                  final FontWeight fontWeight =
                      is_read ? FontWeight.w400 : FontWeight.w700;
                  //to nie działa
                  return InkWell(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) =>
                      //         SingleChatPage(name: '', avatarUrl: ''),
                      //   ),
                      // );
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
                                    Text(document.get('senderId')),
                                    SizedBox(height: 5),
                                    Text(
                                      document.get('text')
                                              .substring(0,10) +
                                          '...',
                                      //substring co zrobic jesli wiadomosc bedzie bardzo krótka?
                                      style:
                                          Theme.of(context).textTheme.bodyText2,
                                    ),
                                  ],
                                ),
                              ),
                             // Text(document.get('send_date').toString()),
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

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:nomadly_app/screens/chat_single_view.dart';
//
// class Chat extends StatefulWidget {
//   const Chat({Key? key}) : super(key: key);
//
//   @override
//   _ChatState createState() => _ChatState();
// }
//
// class _ChatState extends State<Chat> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final User? _user = FirebaseAuth.instance.currentUser;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Chats'),
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: _firestore.collection('ChatMessage').where('Users', arrayContains: _user!.uid).snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           final List<QueryDocumentSnapshot> chats = snapshot.data!.docs;
//
//           return ListView.builder(
//             itemCount: chats.length,
//             itemBuilder: (BuildContext context, int index) {
//               final Map<String, dynamic> data = chats[index].data() as Map<String, dynamic>;
//               final String chatId = chats[index].id;
//
//               String recipientName = '';
//
//               if (_user!.uid == data['Users'][0]) {
//                 recipientName = data['Name'][1];
//               } else {
//                 recipientName = data['Name'][0];
//               }
//
//               return ListTile(
//                 title: Text(recipientName),
//                 subtitle: Text(data['Name']),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => SingleChatPage(
//                         //name: chatId,
//                         //avatarUrl: recipientName,
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
//
//
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/ChatMessage.dart';
//
// class ChatPage extends StatefulWidget {
//   const ChatPage({Key? key}) : super(key: key);
//
//   @override
//   _ChatPageState createState() => _ChatPageState();
// }
//
// class _ChatPageState extends State<ChatPage> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late final String _currentUserId;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentUserId = _auth.currentUser!.uid;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Chat'),
//       ),
//       body: StreamBuilder<QuerySnapshot<ChatMessage>>(
//         stream: _firestore
//             .collection('messages')
//             .orderBy('timestamp', descending: true)
//             .snapshots()
//
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return const Center(
//               child: Text('Something went wrong'),
//             );
//           }
//
//           if (!snapshot.hasData) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           final messages = snapshot.data!;
//
//           return ListView.builder(
//             itemCount: messages.length,
//             itemBuilder: (context, index) {
//               final message = messages[index];
//
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: message.senderId == _currentUserId
//                       ? CrossAxisAlignment.end
//                       : CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       message.senderName,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     Text(
//                       message.timestamp.toDate().toString(),
//                       style: const TextStyle(
//                         fontStyle: FontStyle.italic,
//                       ),
//                     ),
//                     Container(
//                       decoration: BoxDecoration(
//                         color: message.senderId == _currentUserId
//                             ? Colors.blue
//                             : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       padding: const EdgeInsets.all(8.0),
//                       margin: const EdgeInsets.only(top: 4.0),
//                       child: Text(
//                         message.text,
//                         style: const TextStyle(
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
