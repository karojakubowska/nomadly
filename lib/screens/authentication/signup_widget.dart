import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';

import '../../main.dart';
import '../../utils/app_styles.dart';

// class SignUpWidget extends StatefulWidget {
//   final VoidCallback onClickedSignIn;
//
//   const SignUpWidget({Key? key, required this.onClickedSignIn})
//       : super(key: key);
//
//   @override
//   State<SignUpWidget> createState() => _SignUpWidgetState();
// }
//
// class _SignUpWidgetState extends State<SignUpWidget> {
//   final emailController = TextEditingController();
//   final nameController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confPassController = TextEditingController();
//
//   final List<String> _types = ["Client", "Host"];
//   String? _selectedType;
//
//   @override
//   Widget build(BuildContext context) => SingleChildScrollView(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           const SizedBox(
//             height: 60,
//           ),
//           const Text(
//             "Sign Up",
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Color.fromARGB(255, 57, 57, 57)),
//           ),
//           const SizedBox(
//             height: 50,
//           ),
//           TextField(
//             controller: emailController,
//             cursorColor: Colors.white,
//             textInputAction: TextInputAction.next,
//             decoration: const InputDecoration(
//               labelText: 'E-mail',
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 borderSide: BorderSide(
//                     width: 1, color: Color.fromARGB(255, 217, 217, 217)),
//               ),
//               filled: true,
//               fillColor: Color.fromARGB(255, 249, 250, 250),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           TextField(
//             controller: nameController,
//             cursorColor: Colors.white,
//             textInputAction: TextInputAction.next,
//             decoration: const InputDecoration(
//               labelText: 'Name',
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 borderSide: BorderSide(
//                     width: 1, color: Color.fromARGB(255, 217, 217, 217)),
//               ),
//               filled: true,
//               fillColor: Color.fromARGB(255, 249, 250, 250),
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           TextField(
//             controller: passwordController,
//             cursorColor: Colors.white,
//             textInputAction: TextInputAction.next,
//             decoration: const InputDecoration(
//               labelText: 'Password',
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 borderSide: BorderSide(
//                     width: 1, color: Color.fromARGB(255, 217, 217, 217)),
//               ),
//               filled: true,
//               fillColor: Color.fromARGB(255, 249, 250, 250),
//             ),
//             obscureText: true,
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           TextField(
//             controller: confPassController,
//             cursorColor: Colors.white,
//             textInputAction: TextInputAction.done,
//             decoration: const InputDecoration(
//               labelText: 'Confirm Password',
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                 borderSide: BorderSide(
//                     width: 1, color: Color.fromARGB(255, 217, 217, 217)),
//               ),
//               filled: true,
//               fillColor: Color.fromARGB(255, 249, 250, 250),
//             ),
//             obscureText: true,
//           ),
//           const Gap(20),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
//             decoration: BoxDecoration(
//               color: const Color.fromARGB(255, 249, 250, 250),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                   width: 1, color: const Color.fromARGB(255, 217, 217, 217)),
//             ),
//             child: DropdownButton<String>(
//               value: _selectedType,
//               onChanged: (value) {
//                 setState(() {
//                   _selectedType = value;
//                 });
//               },
//               hint: Container(
//                   alignment: Alignment.centerLeft,
//                   child: const Text("Select the type of account",
//                       textAlign: TextAlign.left)),
//               underline: Container(),
//               dropdownColor: Styles.backgroundColor,
//               icon: const Icon(
//                 Icons.arrow_drop_down,
//                 color: Color.fromARGB(255, 57, 57, 57),
//               ),
//               isExpanded: true,
//               items: _types
//                   .map((e) => DropdownMenuItem(
//                         value: e,
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             e,
//                           ),
//                         ),
//                       ))
//                   .toList(),
//
//               // Customize the selected item
//               selectedItemBuilder: (BuildContext context) => _types
//                   .map((e) => Center(
//                         child: Text(
//                           e,
//                           style: const TextStyle(
//                             color: Color.fromARGB(255, 57, 57, 57),
//                           ),
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ),
//           const SizedBox(
//             height: 60,
//           ),
//           ElevatedButton.icon(
//             style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(60),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0)),
//                 backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
//             onPressed: signUp,
//             icon: const Icon(Icons.lock_open, size: 0),
//             label: const Text('Sign Up', style: TextStyle(fontSize: 24)),
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           RichText(
//             text: TextSpan(
//                 style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
//                 text: 'Already have account? ',
//                 children: [
//                   TextSpan(
//                     recognizer: TapGestureRecognizer()
//                       ..onTap = widget.onClickedSignIn,
//                     text: 'Login',
//                     style: const TextStyle(
//                         color: Color.fromARGB(255, 50, 134, 252),
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold),
//                   )
//                 ]),
//           ),
//         ],
//       ));
//
//   void addUserToFirestore() {
//     final uid = FirebaseAuth.instance.currentUser!.uid;
//     var db = FirebaseFirestore.instance;
//     db.collection("Users").doc(uid).set({
//       'Name': nameController.text,
//       'Email': emailController.text,
//       'AccountType': _selectedType,
//       'AccountImage': 'gs://nomady-ae4b6.appspot.com/example/user.png',
//       'AccountStatus': 'Active',
//       'rate': 0,
//     });
//   }
//
//   Future signUp() async {
//     showDialog(
//         context: context,
//         builder: (context) => const Center(child: CircularProgressIndicator()));
//
//     try {
//       await FirebaseAuth.instance.createUserWithEmailAndPassword(
//           email: emailController.text.trim(),
//           password: passwordController.text.trim());
//       addUserToFirestore();
//     } on FirebaseAuthException catch (e) {
//       print(e);
//     }
//     navigatorKey.currentState!.popUntil((route) => route.isFirst);
//   }
// }

class SignUpWidget extends StatefulWidget {
  final VoidCallback onClickedSignIn;

  const SignUpWidget({Key? key, required this.onClickedSignIn})
      : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confPassController = TextEditingController();

  final List<String> _types = ["Client", "Host"];
  String? _selectedType;

  bool _isPasswordVisible = false;
  bool _isPassword2Visible = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 60,
              ),
              Text(
                tr("Sign Up"),
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
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: tr('E-mail'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                        width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 249, 250, 250),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('Please enter an email');
                  }
                  if (!isValidEmail(value)) {
                    return tr('Please enter a valid email address');
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: nameController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: tr('Name'),
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
              TextFormField(
                controller: passwordController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: tr('Password'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    borderSide: BorderSide(
                        width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 249, 250, 250),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('Please enter a password');
                  }
                  if (value.length < 6) {
                    return tr('Password must be at least 6 characters long');
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: confPassController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: tr('Confirm Password'),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                        width: 1, color: Color.fromARGB(255, 217, 217, 217)),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 249, 250, 250),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPassword2Visible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPassword2Visible = !_isPassword2Visible;
                      });
                    },
                  ),
                ),
                obscureText: !_isPassword2Visible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return tr('Please enter a password');
                  }
                  if (value != passwordController.text) {
                    return tr('Passwords do not match');
                  }
                  return null;
                },
              ),
              const Gap(20),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 249, 250, 250),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      width: 1,
                      color: const Color.fromARGB(255, 217, 217, 217)),
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
                      child: Text(tr("Select the type of account"),
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
                label: Text(tr('Sign Up'), style: TextStyle(fontSize: 24)),
              ),
              const SizedBox(
                height: 24,
              ),
              RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                    text: tr('Already have an account? '),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap = widget.onClickedSignIn,
                        text: tr('Login'),
                        style: const TextStyle(
                            color: Color.fromARGB(255, 50, 134, 252),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            ],
          ),
        ),
      );

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
  }

  Future signUp() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));

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

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    return emailRegex.hasMatch(email);
  }
}
