import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthService {
  Stream<User?> get userStream;
  User? get currentUser;
  Future<UserCredential> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
    String name,
  );
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> reloadUser();
}
