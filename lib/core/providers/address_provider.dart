import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../shared/models/address.dart';
import '../services/firestore_service.dart';

class AddressProvider extends ChangeNotifier {
  final List<Address> _addresses = [];
  final Uuid _uuid = Uuid();
  final FirestoreService? _firestoreService;

  AddressProvider([this._firestoreService]);

  List<Address> get addresses => List.unmodifiable(_addresses);

  void setAddressesFromList(List<Address> addresses) {
    _addresses.clear();
    _addresses.addAll(addresses);

    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses.first.isDefault = true;
    }
    notifyListeners();
  }

  Future<void> addAddressForUser({
    required String uid,
    required String name,
    required String addressLine,
    required String city,
    required String postalCode,
    bool makeDefault = false,
  }) async {
    final address = Address(
      id: _uuid.v4(),
      name: name,
      addressLine: addressLine,
      city: city,
      postalCode: postalCode,
      isDefault: makeDefault || _addresses.isEmpty,
    );

    if (address.isDefault) {
      for (var a in _addresses) a.isDefault = false;
    }
    _addresses.add(address);
    notifyListeners();

    if (_firestoreService == null) return;

    try {
      await _firestoreService.addAddress(uid, address);
    } catch (e) {
      _addresses.removeWhere((a) => a.id == address.id);
      if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
        _addresses.first.isDefault = true;
      }
      notifyListeners();
      throw Exception('Failed to add address. Please try again.');
    }
  }

  Future<void> removeAddressForUser(String uid, String addressId) async {
    final prev = List<Address>.from(_addresses);
    _addresses.removeWhere((a) => a.id == addressId);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses.first.isDefault = true;
    }
    notifyListeners();

    if (_firestoreService == null) return;

    try {
      await _firestoreService.removeAddress(uid, addressId);
    } catch (e) {
      _addresses.clear();
      _addresses.addAll(prev);
      notifyListeners();
      throw Exception('Failed to remove address. Please try again.');
    }
  }

  Future<void> setDefaultForUser(String uid, String id) async {
    final prev = List<Address>.from(_addresses);
    for (var a in _addresses) a.isDefault = a.id == id;
    notifyListeners();

    if (_firestoreService == null) return;

    try {
      await _firestoreService.updateAddress(
        uid,
        _addresses.firstWhere((a) => a.id == id),
      );
    } catch (e) {
      _addresses.clear();
      _addresses.addAll(prev);
      notifyListeners();
      throw Exception('Failed to set default address. Please try again.');
    }
  }
}
