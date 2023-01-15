import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/chat_single_view.dart';

class Chat  extends StatefulWidget {
  const Chat({ Key? key }) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SingleChatPage(name: '', avatarUrl: '',),
                ),
              );
              // tutaj możesz dodać kod odpowiedzialny za powrót do poprzedniego widoku
            },
          ),
          title: Text('Chat',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    height: 1.2,
                    color: Colors.black,
                    fontWeight: FontWeight.w700
                )
            ),),
          actions: [
            IconButton(
              color: Colors.black,
              icon: Icon(Icons.delete),
              onPressed: () {
                // tutaj możesz dodać kod odpowiedzialny za usuwanie czegoś
              },
            )
          ],
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
                    builder: (context) => SingleChatPage(name: '', avatarUrl: '',),
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
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            'https://pbs.twimg.com/profile_images/1132273809079554048/CNV5-_GG_400x400.jpg',
                          ),
                        ),
                        SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Imię Nazwisko'),
                            SizedBox(height: 5),
                            Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ],
                        ),
                        Text('10:15 AM'),
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



