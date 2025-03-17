class User {
  final int id;
  final String name;
  final String gender;
  final String country;
  final String? address;
  final String? email;
  final String? numberPhone;

  User({
    required this.id,
    required this.name,
    required this.gender,
    required this.country,
    this.address,
    this.email,
    this.numberPhone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      country: json['country'],
      address: json['address'],
      email: json['email'],
      numberPhone: json['numberPhone'],
    );
  }
}
