import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final password2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    passwordController.text = '';
    password2Controller.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
          ),
          title: Text(
            'Change Password',
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
          centerTitle: true,
        ),
        body: ListView(
          // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 24),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: passwordController,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'New Password',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 217, 217, 217)),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 249, 250, 250),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: password2Controller,
                        cursorColor: Colors.white,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          labelText: 'Confirm New Password',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                width: 1,
                                color: Color.fromARGB(255, 217, 217, 217)),
                          ),
                          filled: true,
                          fillColor: Color.fromARGB(255, 249, 250, 250),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: const Color.fromARGB(255, 50, 134, 252),
                        ),
                        onPressed: () {

                        },
                        child: const Text('Save',
                            style: TextStyle(
                                fontSize: 18.0,
                                height: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ]))
            ]));
  }
}
