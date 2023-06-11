import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/app_styles.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
String _errorMessage = '';
String _message='';
  void _ResetPassword() async {
    showDialog(
          context: context,
          builder: (context) =>
              const Center(child: CircularProgressIndicator()));
      try {
         FirebaseAuth.instance.sendPasswordResetEmail(
            email: emailController.text.trim());
           
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? tr('An error occurred');
        });
      }
      setState(() {
          _message = tr("Reset link was sent to your e-mail.");
        });
      Navigator.pop(context);
      if (_errorMessage.isEmpty) {
        emailController.clear();
         showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text(''),
            content: Text(_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(tr('Error')),
            content: Text(_errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            color: Colors.grey,
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          title: Text(
           tr('Forgot Password'),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Color.fromARGB(255, 57, 57, 57)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                const SizedBox(height: 24),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: tr('E-mail'),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 249, 250, 250),
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return tr('Please enter your email');
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(60),
                      backgroundColor: const Color.fromARGB(255, 50, 134, 252),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                    ),
                    onPressed: _ResetPassword,
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: Text(tr('Send'), style: TextStyle(fontSize: 24)),
                  ),
                ),
              ]))
            ]));
  }
}
