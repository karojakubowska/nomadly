// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nomadly_app/screens/chat_single_view.dart';
//
// class Chat  extends StatefulWidget {
//   const Chat({ Key? key }) : super(key: key);
//
//   @override
//   State<Chat> createState() => _ChatState();
// }
//
// class _ChatState extends State<Chat> {
//
//   @override
//   Widget build(BuildContext context) =>
//       Scaffold(
//         appBar: AppBar(
//           title: Text('Chat',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.roboto(
//                 textStyle: TextStyle(
//                     fontSize: 20.0,
//                     height: 1.2,
//                     color: Colors.black,
//                     fontWeight: FontWeight.w700
//                 )
//             ),),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           textTheme: TextTheme(
//             subtitle1: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//         body: ListView.builder(
//           itemCount: 3,
//           itemBuilder: (context, index) {
//             return InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => SingleChatPage(name: '', avatarUrl: '',),
//                   ),
//                 );
//               },
//               child: Container(
//                 margin: EdgeInsets.symmetric(vertical: 10),
//                 child: Card(
//                   child: Padding(
//                     padding: EdgeInsets.all(15),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween, // <- Dodano
//                       children: [
//                         CircleAvatar(
//                           radius: 30,
//                           backgroundImage: NetworkImage(
//                             'https://pbs.twimg.com/profile_images/1132273809079554048/CNV5-_GG_400x400.jpg',
//                           ),
//                         ),
//                         SizedBox(width: 15),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Imię Nazwisko'),
//                               SizedBox(height: 5),
//                               Text(
//                                 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'.substring(0,50) + '...',
//                                 style: Theme.of(context).textTheme.bodyText2,
//                               ),
//                             ],
//                           ),
//                         ),
//                         Text('10:15 AM'),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       );
// }
//


import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
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
    body: ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
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
                          Text('Imię Nazwisko'),
                          SizedBox(height: 5),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'.substring(0,50) + '...',
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        ],
                      ),
                    ),
                    Text('10:15 AM'),
                    Positioned(
                      right: -30,
                      top: 50,
                      child: PopupMenuButton(
                        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
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
    ),
  );
}
