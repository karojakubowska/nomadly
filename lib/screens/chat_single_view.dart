import 'package:flutter/material.dart';

class SingleChatPage extends StatefulWidget {
  final String name;
  final String avatarUrl;

  const SingleChatPage({
    Key? key,
    required this.name,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  _SingleChatPageState createState() => _SingleChatPageState();
}

class _SingleChatPageState extends State<SingleChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> _messages = [
    {
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'isMe': false,
      'time': '2022-01-01 10:00:00',
    },
    {
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'isMe': true,
      'time': '2022-01-01 10:01:00',
    },
    {
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'isMe': false,
      'time': '2022-01-01 10:02:00',
    },
    {
      'text': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
      'isMe': true,
      'time': '2022-01-01 10:03:00',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.name,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                Map<String, dynamic> message = _messages[index
                ];

                return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment:
                      message['isMe'] ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.8,
                          ),
                          decoration: BoxDecoration(
                            color: message['isMe'] ? Colors.blueAccent : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment:
                              message['isMe'] ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message['text'],
                                  style: TextStyle(
                                    color: message['isMe'] ? Colors.white : Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  message['time'],
                                  style: TextStyle(
                                    color: message['isMe'] ? Colors.white : Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      hintText: 'Write a message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    setState(() {
                      _messages.insert(
                        0,
                        {
                          'text': _textController.text,
                          'isMe': true,
                          'time': DateTime.now().toString().substring(0, 19),
                        },
                      );
                      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
                      _textController.clear();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

