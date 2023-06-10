import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/main-web.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/models/Booking.dart';
import 'package:nomadly_app/models/User.dart';
import 'package:nomadly_app/screens/all_bookings_view.dart';

//import 'package:nomadly_app/screens/calendar.dart';
import 'package:nomadly_app/screens/chat_view.dart';
import 'package:nomadly_app/screens/checkout.dart';
import 'package:nomadly_app/screens/checkout_confirmed.dart';
import 'package:nomadly_app/screens/home_view.dart';
import 'package:nomadly_app/screens/host/all_bookings_host_view.dart';
import 'package:nomadly_app/screens/new_bottomnavbar.dart';
import 'package:nomadly_app/screens/travel_view.dart';
import 'package:nomadly_app/screens/userprofile_view.dart';
import 'package:nomadly_app/screens/wishlist_view.dart';
import 'package:nomadly_app/services/accommodation_provider.dart';
import 'package:nomadly_app/services/booking_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/add_accommodation_view.dart';
import 'screens/home_host_view.dart';
import 'screens/new_bottomnavbarhost.dart';
import 'services/authentication_provider.dart';
import 'firebase_options.dart';
import 'screens/authentication/auth_page.dart';
import 'screens/introduction_view.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:easy_localization/easy_localization.dart';

int? initScreen;

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await EasyLocalization.ensureInitialized();
//
//   if (kIsWeb) {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     runApp(
//         MaterialApp(
//           debugShowCheckedModeBanner: false,
//           home: Scaffold(
//             body: Container(
//               child: MyWebView(),
//             ),
//           ),
//         )
//     );
//   }
//   else {
//     WidgetsFlutterBinding.ensureInitialized();
//     SharedPreferences preferences = await SharedPreferences.getInstance();
//     initScreen = preferences.getInt('initScreen');
//     await preferences.setInt('initScreen', 1); //if already shown  1 else 0
//     await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform);
//     runApp(MultiProvider(providers: [
//       Provider<AuthenticationProvider>(
//         create: (_) => AuthenticationProvider(FirebaseAuth.instance),
//       ),
//       StreamProvider(
//         create: (context) =>
//         context
//             .read<AuthenticationProvider>()
//             .authState,
//         initialData: null,
//       ),
//       StreamProvider<List<Acommodation>>.value(
//         value: AccommodationProvider().allAccommodations,
//         initialData: const [],
//         child: const HomeTest(),
//       ),
//       StreamProvider<List<Booking>>.value(
//         value: BookingProvider().allBookings,
//         initialData: const [],
//         child: const HomeTest(),
//       ),
//     ], child: const MyApp()));
//   }
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  if (kIsWeb) {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: MyWebView(),
        ),
      ),
    ));
  } else {
    WidgetsFlutterBinding.ensureInitialized();
    await EasyLocalization.ensureInitialized();

    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    initScreen = preferences.getInt('initScreen');
    await preferences.setInt('initScreen', 1); //if already shown  1 else 0
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(EasyLocalization(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('pl', 'PL'),
      ],
      fallbackLocale: Locale('en', 'US'),
      path: 'assets/translate',
      child: MultiProvider(
        providers: [
          Provider<AuthenticationProvider>(
            create: (_) => AuthenticationProvider(FirebaseAuth.instance),
          ),
          StreamProvider(
            create: (context) =>
            context.read<AuthenticationProvider>().authState,
            initialData: null,
          ),
          StreamProvider<List<Acommodation>>.value(
            value: AccommodationProvider().allAccommodations,
            initialData: const [],
            child: const HomeTest(),
          ),
          StreamProvider<List<Booking>>.value(
            value: BookingProvider().allBookings,
            initialData: const [],
            child: const HomeTest(),
          ),
        ],
        child: const MyApp(),
      ),
    ));
  }
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255)),
      initialRoute: initScreen == 0 || initScreen == null ? 'onboard' : 'home',
      routes: {
        'home': (context) => const LoginPage(),
        'onboard': (context) => IntroPage(),
      },
      navigatorKey: navigatorKey,
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.active) {
              return const Center(child: CircularProgressIndicator());
            }
            final user = snapshot.data;
            if (user != null) {
              final uid = user.uid;
              CollectionReference users =
                  FirebaseFirestore.instance.collection('Users');
                  FirebaseFirestore.instance.collection('Users');
              return FutureBuilder<DocumentSnapshot>(
                future: users.doc(uid).get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text("Something went wrong.");
                  }
                  // Wewnątrz funkcji LoginPage
                  if (snapshot.connectionState == ConnectionState.done) {
                    UserModel user = UserModel.fromSnapshot(snapshot.data);

                    if (user.isBlocked) {
                      // Konto jest zablokowane
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('You have been blocked. Please contact the administration.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => LoginPage()),
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    }

                    if (user.accountType == 'Client') {
                      // Widok dla klienta
                      return NewBottomNavBar(
                        screens: [
                          HomeTest(),
                          WishlistScreen(),
                          AllBookingsScreen(),
                          TravelView(),
                          Chat(),
                          UserProfileScreen(),
                        ],
                      );
                    }

                    // Widok dla hosta
                    return NewBottomNavBarHost(
                      screens: const [
                        HomeHostScreen(),
                        AllBookingsHostScreen(),
                        AddAccommodationScreen(),
                        Chat(),
                        UserProfileScreen(),
                      ],
                    );
                  }
                  return const Text("Loading");
                },
              );
            } else {
              return const AuthPage();
            }
          }),
    );
  }
}
