import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/models/User.dart';
import 'package:nomadly_app/screens/home_view.dart';
import 'package:nomadly_app/screens/wishlist_card.dart';
import 'package:nomadly_app/screens/wishlist_view.dart';
import 'package:nomadly_app/services/accommodation_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/authentication_provider.dart';
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
  runApp(MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationProvider>(
          create: (_) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationProvider>().authState,
          initialData: null,
        ),
        StreamProvider<List<Acommodation>>.value(
            value: AccommodationProvider().allAccommodations,
            initialData: [],
            child: HomeTest()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),

        initialRoute:
            initScreen == 0 || initScreen == null ? 'onboard' : 'home',
        routes: {
          'home': (context) => LoginPage(),
          'onboard': (context) => IntroPage(),
        },
        navigatorKey: navigatorKey,
        // home:  LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final firebaseUser=context.watch<User?>();
    // var userid=firebaseUser?.uid;
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data;
            if (user != null) {
              final uid = user.uid;
              CollectionReference users =
                  FirebaseFirestore.instance.collection('Users');
              return FutureBuilder<DocumentSnapshot>(
                future: users.doc(uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text("Something went wrong.");
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    UserModel user = UserModel.fromSnapshot(snapshot.data);
                    if (user.accountType == 'Client') return BottomNavBar();
                    return WishlistScreen();
                  }
                  return Text("Loading");
                },
              );
            } else {
              return AuthPage();
            }
          }),
    );
  }
}
