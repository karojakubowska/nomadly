import 'package:easy_localization/easy_localization.dart';
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
  late List<String> _todoList = [];
  final TextEditingController _textEditingController = TextEditingController();
  bool _isEditing = false;
  int _editingIndex = -1;
  late List<bool> _checkedList = [];

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
      final todoChecked = data['checkedList'] as List<dynamic>;
      setState(() {
        _todoList = todoList.map((e) => e.toString()).toList();
        _checkedList = todoChecked.map((e) => e as bool).toList();
      });
    } else {
      _checkedList = List.generate(_todoList.length, (_) => false);
    }
  }

  void _editToDo(int index) {
    setState(() {
      _isEditing = true;
      _editingIndex = index;
    });
  }

  void _clearList() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tr('Confirm')),
            content: Text(tr('Are you sure you want to clear the list?')),
            actions: <Widget>[
              TextButton(
                child: Text(tr('Cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(tr('Clear')),
                onPressed: () {
                  setState(() {
                    _todoList.clear();
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

  void _deleteItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(tr('Confirm')),
            content: Text(tr('Are you sure you want to delete this item?')),
            actions: <Widget>[
              TextButton(
                child: Text(tr('Cancel')),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text(tr('Delete')),
                onPressed: () {
                  setState(() {
                    _editingIndex = -1;
                    _todoList.removeAt(index);
                    _checkedList.removeAt(index);
                    _isEditing = false;
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<void> _updateCheckedList(int index, bool value) async {
    await Firebase.initializeApp();
    final travelDocument = FirebaseFirestore.instance
        .collection('Travel')
        .doc(widget.travelDocumentId);
    final data = {'todoList': _todoList, 'checkedList': _checkedList};
    data['checkedList']![index] = value;
    await travelDocument.update(data);
  }

  void _addNewToDo() {
    setState(() {
      _todoList.insert(_todoList.length, '');
      _checkedList.insert(_checkedList.length, false);
      _isEditing = true;
      _editingIndex = _todoList.length - 1;
    });
  }

  Widget _buildListItem(int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        _deleteItem(index);
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
          color: _checkedList[index] ? Colors.grey[200] : Colors.white, // new code
        ),
        child: Row(
          children: [
            Checkbox(
              value: _checkedList[index],
              onChanged: (value) async {
                setState(() {
                  _checkedList[index] = value!;
                });
                await _updateCheckedList(index, value!);
              },
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                    controller: TextEditingController(
                      text: _todoList[index],
                    ),
                    style: TextStyle(
                      color: _checkedList[index] ? Colors.grey : Colors.black,
                      decoration: _checkedList[index] ? TextDecoration.lineThrough : TextDecoration.none,
                    ),
                  decoration: InputDecoration(
                    hintText: tr('Enter a to do'),
                    border: InputBorder.none,
                  ),
                  onChanged: (text) {
                    _todoList[index] = text;
                  },
                ),
              ),
            ),
            IconButton(
              iconSize: 22,
              icon: Icon(Icons.delete, color: Colors.grey[400]),
              onPressed: () {
                _deleteItem(index);
              },
            ),
          ],
        ),
      ),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white, size: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.whiteColor,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          tr('To do list'),
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true, toolbarTextStyle: const TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).bodyText2, titleTextStyle: const TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).headline6,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton(
              child: const Icon(Icons.add),
              backgroundColor: Colors.blue,
              onPressed: _addNewToDo, // użyj funkcji _addNewToDo
            ),
            const SizedBox(height: 16.0),
            FloatingActionButton(
              child: const Icon(Icons.delete),
              backgroundColor: Colors.red,
              onPressed: _clearList,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 56.0,
          margin: const EdgeInsets.all(40.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
            onPressed: () async {
              await Firebase.initializeApp();
              FirebaseFirestore.instance
                  .collection('Travel')
                  .doc(widget.travelDocumentId)
                  .update({'todoList': _todoList, 'checkedList': _checkedList})
                  .then((value) => Navigator.of(context).pop())
                  .catchError(
                      (error) => print('Error updating document: $error'));
            },
            icon: const Icon(Icons.lock_open, size: 0),
            label: Text(tr('Save'), style: TextStyle(fontSize: 20)),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _todoList.length,
        itemBuilder: (context, index) {
          return _buildListItem(index);
        },
      ),
    );
  }
}
