import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'screens/authentication/auth_page.dart';
import 'screens/bottomnavbar.dart';
import 'screens/introduction_view.dart';

int? initScreen;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  initScreen = preferences.getInt('initScreen');
  await preferences.setInt('initScreen', 1); //if already shown  1 else 0
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),

        initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
        routes: {
          'home': (context) => LoginPage(),
          'onboard': (context) => IntroPage(),
        },

        navigatorKey: navigatorKey,
        // home:  LoginPage(),
      );
  //home: CardScreen(),);

}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              getpref();
              return BottomNavBar();
            } else {
              getpref();
              return const AuthPage();
            }
          },
        ),
      );
}

Future<Map<String, String>> getpref() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return <String, String>{
    for (String key in prefs.getKeys()) ...{key: prefs.get(key).toString()}
  };
}
