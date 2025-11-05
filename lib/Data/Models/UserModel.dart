class UserSignUpFormValues {
  final String firstName;
  final String middleName;
  final String lastName;
  final String email;
  final String password;
  final String confirmPassword;
  final int age;
  final int number;

  UserSignUpFormValues({
    required this.firstName,
    required this.middleName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.age,
    required this.number,
  });

  factory UserSignUpFormValues.fromJson(Map<String, dynamic> json) {
    return UserSignUpFormValues(
      firstName: json['name']['first'] ?? '',
      middleName: json['name']['middle'] ?? '',
      lastName: json['name']['last'] ?? '',
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
        'firstname': firstName,
        'middlename': middleName,
        'lastname': lastName,
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
