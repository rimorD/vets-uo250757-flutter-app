class User {
  String? id;
  String name;
  String surname;
  String email;
  String birthDate;
  String password;

  User({
    this.id,
    required this.name,
    required this.surname,
    required this.email,
    required this.birthDate,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'surname': surname,
    'email': email,
    'birthDate': birthDate,
    'password': password,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'];
    String? id;
    if (rawId is String) {
      id = rawId;
    } else if (rawId is Map) {
      id = rawId['\$oid'] as String?;
    } else if (rawId != null) {
      id = rawId.toString();
    }
    return User(
      id: id,
      name: json['name'] ?? '',
      surname: json['surname'] ?? '',
      email: json['email'] ?? '',
      birthDate: json['birthDate'] ?? '',
      password: json['password'] ?? '',
    );
  }
}
