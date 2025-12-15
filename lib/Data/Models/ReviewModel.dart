import 'package:learner_space_app/Data/Models/UserNameModel.dart';

class ReviewModel {
  final String id;
  final String courseId;
  final String userId;
  final int stars;
  final String description;

  // 👇 same pattern as OutcomeModel
  final UserName? userName;
  final String? userProfilePic;
  final DateTime? createdAt;

  ReviewModel({
    required this.id,
    required this.courseId,
    required this.userId,
    required this.stars,
    required this.description,
    this.userName,
    this.userProfilePic,
    this.createdAt,
  });

  /// ✅ FROM JSON (API → APP)
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['_id']?.toString() ?? '',
      courseId: json['courseId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      stars: json['stars'] ?? 0,
      description: json['description'] ?? '',
      userName: json['userName'] != null
          ? UserName.fromJson(json['userName'])
          : null,
      userProfilePic: json['userProfilePic'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  /// ✅ TO JSON (APP → API)
  /// Used for CREATE / UPDATE
  Map<String, dynamic> toJson() {
    return {
      'stars': stars,
      'description': description,
      'courseId': courseId,
      'userId': userId,
    };
  }

  /// Convenience getter (same as OutcomeModel)
  String get fullUserName => userName?.fullName ?? 'Anonymous';
}
