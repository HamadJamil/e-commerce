import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:e_commerce/core/services/firebase_auth_service.dart';
import 'package:e_commerce/core/services/firestore_service.dart';
import 'package:e_commerce/shared/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:e_commerce/core/providers/cart_provider.dart';
import 'package:e_commerce/core/providers/favorites_provider.dart';
import 'package:e_commerce/core/providers/address_provider.dart';

class AuthenticationProvider with ChangeNotifier {
  final FirebaseAuthService _authService;
  final FirestoreService _firestoreService;
  bool _isLoading = false;
  String _error = '';

  UserModel? _userModel;

  UserModel? get userModel => _userModel;

  AuthenticationProvider(this._authService, this._firestoreService);

  User? get currentUser => _authService.currentUser;
  bool get isEmailVerified => currentUser?.emailVerified ?? false;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> signIn(String email, String password) async {
    try {
      _setLoading(true);
      _error = '';
      final cred = await _authService.signInWithEmailAndPassword(
        email,
        password,
      );
      await _authService.reloadUser();
      if ((_authService.currentUser?.emailVerified ?? false)) {
        final uid = cred.user?.uid ?? _authService.currentUser?.uid;
        if (uid != null) {
          final fetched = await _firestoreService.getUser(uid);
          _userModel = fetched;
        }
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAndInitialize(
    BuildContext context,
    String email,
    String password,
  ) async {
    await signIn(email, password);
    if (_authService.currentUser?.emailVerified ?? false) {
      await initializeAppProviders(context);
    }
  }

  Future<void> loadUserAndInitialize(BuildContext context) async {
    try {
      await _authService.reloadUser();
      if (_authService.currentUser == null) return;
      if (!(_authService.currentUser?.emailVerified ?? false)) return;

      final uid = _authService.currentUser?.uid;
      if (uid != null) {
        final fetched = await _firestoreService.getUser(uid);
        _userModel = fetched;
        notifyListeners();
        await initializeAppProviders(context);
      }
    } catch (_) {
      // ignore errors during startup initialization
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String name,
    String phone,
  ) async {
    try {
      _setLoading(true);
      _error = '';
      final cred = await _authService.createUserWithEmailAndPassword(
        email,
        password,
        name,
      );

      final uid = cred.user?.uid;
      if (uid != null) {
        final userModel = UserModel(username: name, phones: [phone]);
        await _firestoreService.createOrUpdateUser(uid, userModel);
      }

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

  Future<void> initializeAppProviders(BuildContext context) async {
    if (_userModel == null) return;
    try {
      final cartProvider = context.read<CartProvider>();
      cartProvider.setItemsFromCartItems(_userModel!.cartItems);

      final favoritesProvider = context.read<FavoritesProvider>();
      await favoritesProvider.setFromIds(
        _userModel!.favoriteProductIds.toSet(),
      );

      final addressProvider = context.read<AddressProvider>();
      addressProvider.setAddressesFromList(_userModel!.addresses);
    } catch (_) {
      // ignore provider initialization errors for now
    }
  }
}
