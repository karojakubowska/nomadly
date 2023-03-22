import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatSingleView extends StatefulWidget {
  final String chatId;

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
  DateTime now = DateTime.now();

  Future<void> _sendMessage() async {
    await _firestore.collection('ChatMessage').add({
      'senderId': _userId,
      'recipientId': widget.chatId,
      'text': _messageController.text,
      'isRead': false,
      'timestamp': now,
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('ChatMessage')
                  .where('recipientId', isEqualTo: 'HDQ7oOhqYlf5ZhtTOhossDLiP3G2')
                  //.orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot message = snapshot.data!.docs[index];
                    final bool isMe = message['senderId'] == _userId;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: isMe ? Colors.green[100] : Colors.grey[200],
                        ),
                        child: Text(message['text']),
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
                    decoration: InputDecoration(hintText: 'Wpisz wiadomość...'),
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
