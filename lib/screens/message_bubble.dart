// import 'package:flutter/material.dart';
//
// class MessageBubble extends StatelessWidget {
//   final String message;
//   final String sender;
//   final bool isMe;
//   final bool isRead;
//
//   MessageBubble({required this.message, required this.sender, required this.isMe, required this.isRead});
//
//   @override
//   Widget build(BuildC 54ontext context) {
//     return Row(
//       mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Column(
//           crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//           children: [
//             Text(
//               sender,
//               style: TextStyle(
//                 fontSize: 12.0,
//                 color: Colors.black54,
//               ),
//             ),
//             Container(
//               constraints: BoxConstraints(
//                 maxWidth: MediaQuery.of(context).size.width * 0.7,
//               ),
//               padding: EdgeInsets.symmetric(
//                 vertical: 10.0,
//                 horizontal: 16.0,
//               ),
//               margin: EdgeInsets.symmetric(
//                 vertical: 5.0,
//                 horizontal: 8.0,
//               ),
//               decoration: BoxDecoration(
//                 color: isMe ? Colors.grey[300] : Colors.blue[300],
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30.0),
//                   topRight: Radius.circular(30.0),
//                   bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(30.0),
//                   bottomRight: isMe ? Radius.circular(0) : Radius.circular(30.0),
//                 ),
//               ),
//               child: Column(
//                 crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     message,
//                     style: TextStyle(
//                       color: isMe ? Colors.black : Colors.white,
//                       fontSize: 16.0,
//                       fontWeight: isRead ? FontWeight.w400 : FontWeight.w700,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
