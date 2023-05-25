
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';

import '../../main.dart';
import '../../utils/app_styles.dart';

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confPassController = TextEditingController();

  final List<String> _types = ["Client", "Host"];
  String? _selectedType;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 60,
          ),
          const Text(
            "Sign Up",
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 57, 57, 57)),
          ),
          const SizedBox(
            height: 50,
          ),
          TextField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'E-mail',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 249, 250, 250),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: nameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Name',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 249, 250, 250),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: passwordController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Password',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 249, 250, 250),
            ),
            obscureText: true,
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            controller: confPassController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Confirm Password',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 249, 250, 250),
            ),
            obscureText: true,
          ),
          const Gap(20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 249, 250, 250),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 1, color: const Color.fromARGB(255, 217, 217, 217)),
            ),
            child: DropdownButton<String>(
              value: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
              hint: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text("Select the type of account",
                      textAlign: TextAlign.left)),
              underline: Container(),
              dropdownColor: Styles.backgroundColor,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Color.fromARGB(255, 57, 57, 57),
              ),
              isExpanded: true,
              items: _types
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            e,
                          ),
                        ),
                      ))
                  .toList(),

              // Customize the selected item
              selectedItemBuilder: (BuildContext context) => _types
                  .map((e) => Center(
                        child: Text(
                          e,
                          style: const TextStyle(
                            color: Color.fromARGB(255, 57, 57, 57),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(
            height: 60,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
            onPressed: signUp,
            icon: const Icon(Icons.lock_open, size: 0),
            label: const Text('Sign Up', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(
            height: 24,
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                text: 'Already have account? ',
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignIn,
                    text: 'Login',
                    style: const TextStyle(
                        color: Color.fromARGB(255, 50, 134, 252),
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ]),
          ),
        ],
      ));

  void addUserToFirestore() {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    var db = FirebaseFirestore.instance;
    db.collection("Users").doc(uid).set({
      'Name': nameController.text,
      'Email': emailController.text,
      'AccountType': _selectedType,
      'AccountImage': 'gs://nomady-ae4b6.appspot.com/example/user.png',
      'AccountStatus': 'Active',
      'rate': 0,
    });
    //druga wersja dodania danych do bazy
    /* return users
          .add({

            'Name': 'Karolina', // John Doe
            'Surname': 'Jakubowska', // Stokes and Sons
            'IsHost': true // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error")); */
  }

  Future signUp() async {
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      addUserToFirestore();
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
