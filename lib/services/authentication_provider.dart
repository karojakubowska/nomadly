import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationProvider{
  final FirebaseAuth _firebaseAuth;
  AuthenticationProvider(this._firebaseAuth);

   Stream<User?> get authState => _firebaseAuth.authStateChanges();
}