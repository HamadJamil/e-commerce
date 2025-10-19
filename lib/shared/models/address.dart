class Address {
  final String id;
  final String name;
  final String addressLine;
  final String city;
  final String postalCode;
  bool isDefault;

  Address({
    required this.id,
    required this.name,
    required this.addressLine,
    required this.city,
    required this.postalCode,
    this.isDefault = false,
  });

  Address copyWith({
    String? id,
    String? name,
    String? addressLine,
    String? city,
    String? postalCode,
    bool? isDefault,
  }) {
    return Address(
      id: id ?? this.id,
      name: name ?? this.name,
      addressLine: addressLine ?? this.addressLine,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}
