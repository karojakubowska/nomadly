import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSingleView extends StatefulWidget {
  final String chatId;
  //final String recipientName;

  const ChatSingleView({Key? key, required this.chatId})
      : super(key: key);

  @override
  _ChatSingleViewState createState() => _ChatSingleViewState();
}

class _ChatSingleViewState extends State<ChatSingleView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String _userId;

  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    if (user != null) {
      _userId = user.uid;
    }
  }

  Future<void> _sendMessage() async {
    // zapisz wiadomość w bazie danych
    await _firestore.collection('ChatMessage').add({
      'senderId': _userId,
      'recipientId': widget.chatId,
      'text': _messageController.text,
      'isRead': false,
      'timestamp': DateTime.now(),
    });

    // wyczyść pole wprowadzania wiadomości
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text(widget.recipientName,
        //     style: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('ChatMessage')
                  .where('senderId', isEqualTo: _userId)
                  .where('recipientId', isEqualTo: widget.chatId)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot message =
                    snapshot.data!.docs[index];
                    return ListTile(
                      title: Text(message['text']),
                      subtitle: Text(message['timestamp'].toString()),
                      leading: CircleAvatar(
                        //child: Text(widget.recipientName[0]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration:
                    InputDecoration(hintText: 'Wpisz wiadomość...'),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
