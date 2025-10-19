import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/address.dart';

class AddressProvider extends ChangeNotifier {
  final List<Address> _addresses = [];
  final Uuid _uuid = Uuid();

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
    notifyListeners();
  }

  void removeAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses.first.isDefault = true;
    }
    notifyListeners();
  }

  void setDefault(String id) {
    for (var a in _addresses) {
      a.isDefault = a.id == id;
    }
    notifyListeners();
  }
}
