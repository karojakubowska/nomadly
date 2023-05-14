// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nomadly_app/utils/app_styles.dart';
//
// class ToDoListScreen extends StatefulWidget {
//   const ToDoListScreen({Key? key}) : super(key: key);
//
//   @override
//   _ToDoListScreenState createState() => _ToDoListScreenState();
// }
//
// class _ToDoListScreenState extends State<ToDoListScreen> {
//   List<String> _todoList = [];
//   final TextEditingController _textEditingController = TextEditingController();
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Styles.backgroundColor,
//       appBar: AppBar(
//         leading: IconButton(
//           color: Colors.black,
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).popUntil((route) => route.isFirst);
//           },
//         ),
//         title: Text(
//           'To do list',
//           textAlign: TextAlign.center,
//           style: GoogleFonts.roboto(
//               textStyle: TextStyle(
//                   fontSize: 20.0,
//                   height: 1.2,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w700)),
//         ),
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
//       floatingActionButton: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: FloatingActionButton(
//           child: Icon(Icons.add),
//           backgroundColor: Colors.blue,
//           onPressed: () {
//             setState(() {
//               _todoList.add('');
//             });
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.transparent,
//         elevation: 0,
//         child: Container(
//           height: 56.0,
//           margin: EdgeInsets.all(15.0),
//           child: ElevatedButton(
//             onPressed: () {},
//             child: Text(
//               'Add To do',
//               style: TextStyle(fontSize: 18.0),
//             ),
//             style: ElevatedButton.styleFrom(
//               primary: Colors.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               minimumSize: Size(double.infinity, 56.0),
//               padding: EdgeInsets.all(16.0),
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(15.0),
//           child: ListView.builder(
//             itemCount: _todoList.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller:
//                             TextEditingController(text: _todoList[index]),
//                         decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10.0)),
//                               borderSide: BorderSide(
//                                   width: 1,
//                                   color: Color.fromARGB(255, 217, 217, 217)),
//                             ),
//                             filled: true,
//                             fillColor: Color.fromARGB(255, 249, 250, 250)),
//                         onChanged: (text) {
//                           _todoList[index] = text;
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         setState(() {
//                           _todoList.removeAt(index);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:nomadly_app/utils/app_styles.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// class ToDoListScreen extends StatefulWidget {
//     final String travelDocumentId;
//
//   const ToDoListScreen({Key? key, required this.travelDocumentId}) : super(key: key);
//
//   @override
//   _ToDoListScreenState createState() => _ToDoListScreenState();
// }
//
// class _ToDoListScreenState extends State<ToDoListScreen> {
//   List<String> _todoList = [];
//   final TextEditingController _textEditingController = TextEditingController();
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Styles.backgroundColor,
//       appBar: AppBar(
//         leading: IconButton(
//           color: Colors.black,
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).popUntil((route) => route.isFirst);
//           },
//         ),
//         title: Text(
//           'To do list',
//           textAlign: TextAlign.center,
//           style: GoogleFonts.roboto(
//               textStyle: TextStyle(
//                   fontSize: 20.0,
//                   height: 1.2,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w700)),
//         ),
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
//       floatingActionButton: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: FloatingActionButton(
//           child: Icon(Icons.add),
//           backgroundColor: Colors.blue,
//           onPressed: () {
//             setState(() {
//               _todoList.add('');
//             });
//           },
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.transparent,
//         elevation: 0,
//         child: Container(
//           height: 56.0,
//           margin: EdgeInsets.all(15.0),
//           child:  ElevatedButton(
//               onPressed: () async {
//                 await Firebase.initializeApp();
//                 FirebaseFirestore.instance
//                     .collection('Travel')
//                     .doc(widget.travelDocumentId) // użyj identyfikatora dokumentu podróży przekazanego jako argument
//                     .update({'todoList': _todoList}) // zaktualizuj istniejący dokument z listą to do
//                     .then((value) => Navigator.of(context).pop())
//                     .catchError((error) => print('Error updating document: $error'));
//               },
//             child: Text(
//               'Add To do',
//               style: TextStyle(fontSize: 18.0),
//             ),
//             style: ElevatedButton.styleFrom(
//               primary: Colors.blue,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               minimumSize: Size(double.infinity, 56.0),
//               padding: EdgeInsets.all(16.0),
//             ),
//           ),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: EdgeInsets.all(15.0),
//           child: ListView.builder(
//             itemCount: _todoList.length,
//             itemBuilder: (context, index) {
//               return Padding(
//                 padding: EdgeInsets.symmetric(vertical: 8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller:
//                             TextEditingController(text: _todoList[index]),
//                         decoration: InputDecoration(
//                             enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(10.0)),
//                               borderSide: BorderSide(
//                                   width: 1,
//                                   color: Color.fromARGB(255, 217, 217, 217)),
//                             ),
//                             filled: true,
//                             fillColor: Color.fromARGB(255, 249, 250, 250)),
//                         onChanged: (text) {
//                           _todoList[index] = text;
//                         },
//                       ),
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.delete),
//                       onPressed: () {
//                         setState(() {
//                           _todoList.removeAt(index);
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
// class _ToDoListScreenState extends State<ToDoListScreen> {
//   List<String> _todoList = [];
//   final TextEditingController _textEditingController = TextEditingController();
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('To do list'),
//         ),
//         body: Padding(
//         padding: const EdgeInsets.all(16.0),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.stretch,
//     children: [
//     Expanded(
//     child: ListView.builder(
//     itemCount: _todoList.length,
//     itemBuilder: (context, index) {
//     return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 8.0),
//     child: Row(
//       children: [
//         Expanded(
//           child: TextField(
//             controller: TextEditingController(
//                 text: _todoList[index]),
//             decoration: InputDecoration(
//               filled: true,
//               fillColor: Colors.grey[200],
//               border: OutlineInputBorder(),
//             ),
//             onChanged: (value) {
//               setState(() {
//                 _todoList[index] = value;
//               });
//             },
//           ),
//         ),
//         IconButton(
//           icon: Icon(Icons.delete),
//           onPressed: () {
//             setState(() {
//               _todoList.removeAt(index);
//             });
//           },
//         ),
//       ],
//     ),
//     );
//     },
//     ),
//     ),
//       ElevatedButton(
//         onPressed: () async {
//           await showDialog(
//             context: context,
//             builder: (context) => AlertDialog(
//               title: Text('Add To Do'),
//               content: TextField(
//                 controller: _textEditingController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter a To Do',
//                 ),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     _textEditingController.clear();
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _todoList.add(_textEditingController.text);
//                     });
//                     Navigator.of(context).pop();
//                     _textEditingController.clear();
//                   },
//                   child: Text('Add'),
//                 ),
//               ],
//             ),
//           );
//         },
//         child: Text('Add To Do'),
//       ),
//       SizedBox(height: 16.0),
//       ElevatedButton(
//               onPressed: () async {
//                 await Firebase.initializeApp();
//                 FirebaseFirestore.instance
//                     .collection('Travel')
//                     .doc(widget.travelDocumentId) // użyj identyfikatora dokumentu podróży przekazanego jako argument
//                     .update({'todoList': _todoList}) // zaktualizuj istniejący dokument z listą to do
//                     .then((value) => Navigator.of(context).pop())
//                     .catchError((error) => print('Error updating document: $error'));
//               },
//         child: Text('Save'),
//       ),
//     ],
//     ),
//         ),
//     );
//   }
// }
//
// class ToDoListScreen extends StatefulWidget {
//   final String travelDocumentId;
//
//   const ToDoListScreen({Key? key, required this.travelDocumentId}) : super(key: key);
//
//   @override
//   _ToDoListScreenState createState() => _ToDoListScreenState();
// }
//
// class _ToDoListScreenState extends State<ToDoListScreen> {
//   List<String> _todoList = [];
//   final TextEditingController _textEditingController = TextEditingController();
//
//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('To do list'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: _todoList.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           child: TextField(
//                             controller: TextEditingController(
//                               text: _todoList[index],
//                             ),
//                             decoration: InputDecoration(
//                               filled: true,
//                               fillColor: Colors.grey[200],
//                               border: OutlineInputBorder(),
//                             ),
//                             onChanged: (value) {
//                               setState(() {
//                                 _todoList[index] = value;
//                               });
//                             },
//                           ),
//                         ),
//                         IconButton(
//                           icon: Icon(Icons.delete),
//                           onPressed: () {
//                             setState(() {
//                               _todoList.removeAt(index);
//                             });
//                           },
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 await showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text('Add To Do'),
//                     content: TextField(
//                       controller: _textEditingController,
//                       decoration: InputDecoration(
//                         hintText: 'Enter a To Do',
//                       ),
//                     ),
//                     actions: [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                           _textEditingController.clear();
//                         },
//                         child: Text('Cancel'),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _todoList.add(_textEditingController.text);
//                           });
//                           Navigator.of(context).pop();
//                           _textEditingController.clear();
//                         },
//                         child: Text('Add'),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//               child: Text('Add To Do'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () async {
//                 await Firebase.initializeApp();
//                 FirebaseFirestore.instance
//                     .collection('Travel')
//                     .doc(widget.travelDocumentId) // użyj identyfikatora dokumentu podróży przekazanego jako argument
//                     .update({'todoList': _todoList}) // zaktualizuj istniejący dokument z listą to do
//                     .then((value) => Navigator.of(context).pop())
//                     .catchError((error) => print('Error updating document: $error'));
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ToDoListScreen extends StatefulWidget {
  final String travelDocumentId;

  const ToDoListScreen({Key? key, required this.travelDocumentId})
      : super(key: key);

  @override
  _ToDoListScreenState createState() => _ToDoListScreenState();
}

class _ToDoListScreenState extends State<ToDoListScreen> {
  List<String> _todoList = [];
  final TextEditingController _textEditingController =
  TextEditingController();
  bool _isEditing = false;
  int _editingIndex = -1;

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  void _loadToDoList() async {
    await Firebase.initializeApp();
    final travelDocumentSnapshot = await FirebaseFirestore.instance
        .collection('Travel')
        .doc(widget.travelDocumentId)
        .get();
    final data = travelDocumentSnapshot.data();
    if (data != null) {
      final todoList = data['todoList'] as List<dynamic>;
      setState(() {
        _todoList = todoList.map((e) => e.toString()).toList();
      });
    }
  }

  void _addNewToDo() {
    setState(() {
      _todoList.add('');
      _isEditing = true;
      _editingIndex = _todoList.length - 1;
    });
  }

  void _saveToDo() {
    setState(() {
      _isEditing = false;
      _editingIndex = -1;
    });
  }

  void _deleteToDo() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm'),
            content: Text('Are you sure you want to delete this To Do?'),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Delete'),
                onPressed: () {
                  setState(() {
                    _todoList.removeAt(_editingIndex);
                    _isEditing = false;
                    _editingIndex = -1;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
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
            onPressed: () async {
              await Firebase.initializeApp();
              FirebaseFirestore.instance
                  .collection('Travel')
                  .doc(widget.travelDocumentId) // użyj identyfikatora dokumentu podróży przekazanego jako argument
                  .update({'todoList': _todoList}) // zaktualizuj istniejący dokument z listą to do
                  .then((value) => Navigator.of(context).pop())
                  .catchError((error) => print('Error updating document: $error'));
            },
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
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                _todoList.removeAt(index);
              });
            },
            child: ListTile(
              title: TextField(
                controller: TextEditingController(text: _todoList[index]),
                decoration: InputDecoration(
                  hintText: 'Enter a to do',
                ),
                onChanged: (text) {
                  _todoList[index] = text;
                },
              ),
            ),
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              color: Colors.red,
              child: Icon(Icons.delete, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}