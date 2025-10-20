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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'addressLine': addressLine,
      'city': city,
      'postalCode': postalCode,
      'isDefault': isDefault,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'] as String,
      name: map['name'] as String,
      addressLine: map['addressLine'] as String,
      city: map['city'] as String,
      postalCode: map['postalCode'] as String,
      isDefault: map['isDefault'] == true,
    );
  }

  String toJson() => toMap().toString();
}
