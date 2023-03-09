// // import 'package:flutter/material.dart';
// //
// // class SingleChatPage extends StatefulWidget {
// //   final String name;
// //   final String avatarUrl;
// //
// //   const SingleChatPage({
// //     Key? key,
// //     required this.name,
// //     required this.avatarUrl,
// //   }) : super(key: key);
// //
// //   @override
// //   _SingleChatPageState createState() => _SingleChatPageState();
// // }
// //
// // class _SingleChatPageState extends State<SingleChatPage> {
// //   final TextEditingController _textController = TextEditingController();
// //   final ScrollController _scrollController = ScrollController();
// //
// //   List<Map<String, dynamic>> _messages = [
// //     {
// //       'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
// //       'isMe': false,
// //       'time': '2022-01-01 10:00:00',
// //     },
// //     {
// //       'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
// //       'isMe': true,
// //       'time': '2022-01-01 10:01:00',
// //     },
// //     {
// //       'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
// //       'isMe': false,
// //       'time': '2022-01-01 10:02:00',
// //     },
// //     {
// //       'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
// //       'isMe': true,
// //       'time': '2022-01-01 10:03:00',
// //     },
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         leading: IconButton(
// //           color: Colors.black,
// //           icon: Icon(Icons.arrow_back),
// //           onPressed: () {
// //             Navigator.pop(context);
// //           },
// //         ),
// //         title: Text(
// //           widget.name,
// //           style: TextStyle(
// //             color: Colors.black,
// //             fontSize: 20,
// //             fontWeight: FontWeight.w500,
// //           ),
// //         ),
// //         centerTitle: true,
// //         backgroundColor: Colors.transparent,
// //         elevation: 0,
// //       ),
// //       body: Column(
// //         children: [
// //           Expanded(
// //             child: ListView.builder(
// //               controller: _scrollController,
// //               itemCount: _messages.length,
// //               reverse: true,
// //               itemBuilder: (context, index) {
// //                 Map<String, dynamic> message = _messages[index
// //                 ];
// //
// //                 return Padding(
// //                     padding: const EdgeInsets.all(8.0),
// //                     child: Row(
// //                       mainAxisAlignment:
// //                       message['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
// //                       children: [
// //                         Container(
// //                           constraints: BoxConstraints(
// //                             maxWidth: MediaQuery.of(context).size.width * 0.8,
// //                           ),
// //                           decoration: BoxDecoration(
// //                             color: message['isMe'] ? Colors.blueAccent : Colors.white,
// //                             borderRadius: BorderRadius.circular(10),
// //                           ),
// //                           child: Padding(
// //                             padding: const EdgeInsets.all(8.0),
// //                             child: Column(
// //                               crossAxisAlignment:
// //                               message['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
// //                               children: [
// //                                 Text(
// //                                   message['text'],
// //                                   style: TextStyle(
// //                                     color: message['isMe'] ? Colors.white : Colors.black,
// //                                     fontSize: 16,
// //                                   ),
// //                                 ),
// //                                 Text(
// //                                   message['time'],
// //                                   style: TextStyle(
// //                                     color: message['isMe'] ? Colors.white : Colors.black54,
// //                                     fontSize: 14,
// //                                   ),
// //                                 ),
// //                               ],
// //                             ),
// //                           ),
// //                         ),
// //                         SizedBox(width: 10),
// //                       ],
// //                     ));
// //               },
// //             ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: Row(
// //               children: [
// //                 Expanded(
// //                   child: TextField(
// //                     controller: _textController,
// //                     decoration: InputDecoration(
// //                       contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
// //                       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
// //                       hintText: 'Write a message...',
// //                     ),
// //                   ),
// //                 ),
// //                 IconButton(
// //                   icon: Icon(Icons.send),
// //                   onPressed: () {
// //                     setState(() {
// //                       _messages.insert(
// //                         0,
// //                         {
// //                           'text': _textController.text,
// //                           'isMe': true,
// //                           'time': DateTime.now().toString().substring(0, 19),
// //                         },
// //                       );
// //                       _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
// //                       _textController.clear();
// //                     });
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// //
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:nomadly_app/screens/message_bubble.dart';
//
// class SingleChatPage extends StatefulWidget {
//   final String name;
//   final String avatarUrl;
//
//   SingleChatPage({
//     required this.name,
//     required this.avatarUrl,
//   });
//
//   @override
//   _SingleChatPageState createState() => _SingleChatPageState();
// }
//
// class _SingleChatPageState extends State<SingleChatPage> {
//   final TextEditingController _textEditingController =
//   TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.name,
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             fontSize: 20.0,
//             height: 1.2,
//             color: Colors.black,
//             fontWeight: FontWeight.w700,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         textTheme: TextTheme(
//           subtitle1: TextStyle(
//             color: Colors.black,
//             fontSize: 20,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<QuerySnapshot>(
//               stream: FirebaseFirestore.instance
//                   .collection('messages')
//                   .orderBy('timestamp', descending: true)
//                   .snapshots(),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 }
//                 List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
//                 List<Widget> messages = [];
//                 for (var doc in docs) {
//                   Map<String, dynamic> data =
//                   doc.data() as Map<String, dynamic>;
//                   String message = data['message'];
//                   String senderId = data['senderId'];
//                   String receiverId = data['receiverId'];
//                   if ((senderId == '1' && receiverId == '2') ||
//                       (senderId == '2' && receiverId == '1')) {
//                     bool isRead = data['isRead'] ?? false;
//                     messages.add(
//                       MessageBubble(
//                         message: message,
//                         isMe: senderId == '1',
//                         isRead: isRead, sender: '',
//                       ),
//                     );
//                   }
//                 }
//                 return ListView(
//                   reverse: true,
//                   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
//                   children: messages,
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(10.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _textEditingController,
//                     decoration: InputDecoration(
//                       hintText: 'Type your message...',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 ElevatedButton(
//                   onPressed: () {
//                     String message = _textEditingController.text.trim();
//                     if (message.isNotEmpty) {
//                       _textEditingController.clear();
//                       FirebaseFirestore.instance
//                           .collection('messages')
//                           .add({
//                         'senderId': '1',
//                         'receiverId': '2',
//                         'message': message,
//                         'timestamp': DateTime.now().millisecondsSinceEpoch,
//                         'isRead': false,
//                       });
//                     }
//                   },
//                   child: Text('Send'),
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
