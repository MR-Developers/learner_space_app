import 'package:learner_space_app/Data/Models/UserNameModel.dart';

class OutcomeModel {
  final String id;
  final String companyPlaced;
  final bool featured;
  final String package;
  final String courseId;
  final String description;
  final String userId;
  final bool verified;
  final DateTime createdAt;
  final DateTime updatedAt;

  final UserName? userName;
  final String? userProfilePic;

  OutcomeModel({
    required this.id,
    required this.companyPlaced,
    required this.featured,
    required this.package,
    required this.courseId,
    required this.description,
    required this.userId,
    required this.verified,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userProfilePic,
  });

  factory OutcomeModel.fromJson(Map<String, dynamic> json) {
    return OutcomeModel(
      id: json['_id']?.toString() ?? '',
      companyPlaced: json['companyPlaced'] ?? '',
      featured: json['featured'] ?? false,
      package: json['package'] ?? '',
      courseId: json['courseId']?.toString() ?? '',
      description: json['description'] ?? '',
      userId: json['userId']?.toString() ?? '',
      verified: json['verified'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      userName: json['userName'] != null
          ? UserName.fromJson(json['userName'])
          : null,
      userProfilePic: json['userProfilePic'], // ✅ CORRECT KEY
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'companyPlaced': companyPlaced,
      'featured': featured,
      'package': package,
      'courseId': courseId,
      'description': description,
      'userId': userId,
      'verified': verified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'userName': userName?.toJson(),
      'userProfilePic': userProfilePic,
    };
  }

  /// UI helpers
  String get fullUserName => userName?.fullName ?? 'Anonymous';

  bool get hasProfilePic =>
      userProfilePic != null && userProfilePic!.isNotEmpty;
}
