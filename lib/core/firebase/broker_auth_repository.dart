import 'package:firebase_auth/firebase_auth.dart';

class BrokerAuthRepository {
  const BrokerAuthRepository();

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() => FirebaseAuth.instance.signOut();

  User? get currentUser => FirebaseAuth.instance.currentUser;
}

