class UserName {
  final String firstName;
  final String middleName;
  final String lastName;

  UserName({
    required this.firstName,
    required this.middleName,
    required this.lastName,
  });

  factory UserName.fromJson(Map<String, dynamic> json) {
    return UserName(
      firstName: json['firstname'] ?? '',
      middleName: json['middlename'] ?? '',
      lastName: json['lastname'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstName,
      'middlename': middleName,
      'lastname': lastName,
    };
  }

  String get fullName {
    return [
      firstName,
      middleName,
      lastName,
    ].where((e) => e.trim().isNotEmpty).join(' ');
  }
}
