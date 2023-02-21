import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class ToDoListScreen extends StatefulWidget {
  const ToDoListScreen({Key? key}) : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<String> _todoList = [];
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          'To do list',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
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
      floatingActionButton: Padding(
        padding: EdgeInsets.all(8.0),
        child: FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
          onPressed: () {
            setState(() {
              _todoList.add('');
            });
          },
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 56.0,
          margin: EdgeInsets.all(15.0),
          child: ElevatedButton(
            onPressed: () {},
            child: Text(
              'Add To do',
              style: TextStyle(fontSize: 18.0),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              minimumSize: Size(double.infinity, 56.0),
              padding: EdgeInsets.all(16.0),
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: ListView.builder(
            itemCount: _todoList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller:
                            TextEditingController(text: _todoList[index]),
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Color.fromARGB(255, 217, 217, 217)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 249, 250, 250)),
                        onChanged: (text) {
                          _todoList[index] = text;
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _todoList.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
