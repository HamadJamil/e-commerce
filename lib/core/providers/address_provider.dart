import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../shared/models/address.dart';

class AddressProvider extends ChangeNotifier {
  final List<Address> _addresses = [];
  final Uuid _uuid = Uuid();
  static const _kPrefsKey = 'saved_addresses';

  AddressProvider() {
    _loadAddresses();
  }

  List<Address> get addresses => List.unmodifiable(_addresses);

  void addAddress({
    required String name,
    required String addressLine,
    required String city,
    required String postalCode,
    bool makeDefault = false,
  }) {
    final address = Address(
      id: _uuid.v4(),
      name: name,
      addressLine: addressLine,
      city: city,
      postalCode: postalCode,
      isDefault: makeDefault || _addresses.isEmpty,
    );

    if (address.isDefault) {
      for (var a in _addresses) {
        a.isDefault = false;
      }
    }

    _addresses.add(address);
    _saveAddresses();
    notifyListeners();
  }

  void removeAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses.first.isDefault = true;
    }
    _saveAddresses();
    notifyListeners();
  }

  void setDefault(String id) {
    for (var a in _addresses) {
      a.isDefault = a.id == id;
    }
    _saveAddresses();
    notifyListeners();
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_kPrefsKey);
    if (jsonStr == null || jsonStr.isEmpty) return;
    try {
      final List<dynamic> list = json.decode(jsonStr);
      _addresses.clear();
      for (var item in list) {
        if (item is Map<String, dynamic>) {
          _addresses.add(Address.fromMap(item));
        } else if (item is String) {
          // sometimes maps are encoded as strings; try to decode
          final decoded = json.decode(item);
          if (decoded is Map<String, dynamic>) {
            _addresses.add(Address.fromMap(decoded));
          }
        }
      }
      // Ensure exactly one default exists
      if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
        _addresses.first.isDefault = true;
      }
      notifyListeners();
    } catch (_) {
      // ignore malformed data
    }
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();
    final list = _addresses.map((a) => a.toMap()).toList();
    await prefs.setString(_kPrefsKey, json.encode(list));
  }
}
