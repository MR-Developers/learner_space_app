class UserSignUpFormValues {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final int age;
  final int number;

  UserSignUpFormValues({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.age,
    required this.number,
  });

  factory UserSignUpFormValues.fromJson(Map<String, dynamic> json) {
    final knownKeys = {'name', 'email', 'password', 'confirmPassword'};

    final extra = Map<String, dynamic>.from(json)
      ..removeWhere((key, _) => knownKeys.contains(key));

    return UserSignUpFormValues(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      confirmPassword: json['confirmPassword'] ?? '',
      age: json["age"] ?? 0,
      number: json["number"] ?? 0,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    final data = {
      'name': {
        'first': name.split(' ').first,
        'last': name.split(' ').length > 1 ? name.split(' ').last : '',
      },
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'number': number,
      'age': age,
    };
    return data;
  }
}
