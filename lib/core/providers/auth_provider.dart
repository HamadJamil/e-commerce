// lib/core/providers/auth_provider.dart
import 'package:e_commerce/core/services/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuthService _authService;
  bool _isLoading = false;
  String _error = '';

  AuthenticationProvider(this._authService);

  User? get currentUser => _authService.currentUser;
  bool get isEmailVerified => currentUser?.emailVerified ?? false;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _error = '';
      await _authService.signInWithEmailAndPassword(email, password);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      _setLoading(true);
      _error = '';
      await _authService.createUserWithEmailAndPassword(email, password, name);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    try {
      _error = '';
      await _authService.signOut();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      _error = '';
      await _authService.sendPasswordResetEmail(email);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      _setLoading(true);
      _error = '';
      await _authService.sendEmailVerification();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> checkEmailVerification() async {
    try {
      await _authService.reloadUser();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      rethrow;
    }
  }

  void clearError() {
    _error = '';
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
