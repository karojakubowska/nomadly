import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nomadly_app/screens/home_view.dart';

import '../../main.dart';

class LoginWidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const LoginWidget({Key? key, required this.onClickedSignUp})
      : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Text(
            tr("Login"),
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
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                borderSide: BorderSide(
                    width: 1, color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: const Color.fromARGB(255, 249, 250, 250),
              hintStyle: TextStyle(color: Colors.grey[800]),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              return null;
            },
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
                return tr('Please enter your password');
              }
              return null;
            },
          ),
          Container(
            margin: const EdgeInsets.all(5),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {},
                child: Text(
                  tr('Forgot Password?'),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 50, 134, 252)),
                ),
              ),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(60),
              backgroundColor: const Color.fromARGB(255, 50, 134, 252),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
            ),
            onPressed: signIn,
            icon: const Icon(Icons.lock_open, size: 0),
            label: Text(tr('Sign In'), style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(
            height: 24,
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
                text: tr('No account yet? '),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: tr('Sign Up'),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 50, 134, 252),
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  )
                ]),
          ),
          const SizedBox(height: 40)
        ],
      ),
    ),
  );

  Future signIn() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
          context: context,
          builder: (context) =>
          const Center(child: CircularProgressIndicator()));
      try {
        final user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim());

        if (user != null) {
          // Check if user's account is blocked
          if (user.user!.AccountStatus == "Blocked") {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Blocked Account'),
                content: Text('You cannot log in. Please contact the administration.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
            return;
          }

          // Navigate to the home screen after successful login
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeView()),
          );

          emailController.clear();
          passwordController.clear();
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message ?? 'An error occurred';
        });
      }
      Navigator.pop(context);
      if (_errorMessage.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(_errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }
}
