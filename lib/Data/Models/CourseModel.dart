import 'package:learner_space_app/Data/Enums/Enums.dart';

class CourseModel {
  final String id;
  final String courseName;
  final int noOfLeads;
  final String courseUrl;
  final int category;
  final int companyCategory;
  final int price;
  final String companyId;
  final String companyName;
  final String description;
  final List<String> courseImage;
  final String mode;
  final bool placementAssistance;
  final String language;
  final DurationModel duration;
  final List<String> pdf;
  final String createdAt;
  final String updatedAt;
  final int v;
  final int? score; // only in recommended API

  CourseModel({
    required this.id,
    required this.courseName,
    required this.noOfLeads,
    required this.courseUrl,
    required this.category,
    required this.companyCategory,
    required this.price,
    required this.companyId,
    required this.companyName,
    required this.description,
    required this.courseImage,
    required this.mode,
    required this.placementAssistance,
    required this.language,
    required this.duration,
    required this.pdf,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.score,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json["_id"] ?? "",
      courseName: json["courseName"] ?? "",
      noOfLeads: json["noOfLeads"] ?? 0,
      courseUrl: json["courseUrl"] ?? "",
      category: json["category"] ?? 0,
      companyCategory: json["companyCategory"] ?? 0,
      price: json["price"] ?? 0,
      companyId: json["companyId"] ?? "",
      companyName: json["companyName"] ?? "",
      description: json["description"] ?? "",
      courseImage: List<String>.from(json["courseImage"] ?? []),
      mode: json["mode"] ?? "",
      placementAssistance: json["placementAssistance"] ?? false,
      language: json["language"] ?? "",
      duration: DurationModel.fromJson(json["duration"] ?? {}),
      pdf: List<String>.from(json["pdf"] ?? []),
      createdAt: json["createdAt"] ?? "",
      updatedAt: json["updatedAt"] ?? "",
      v: json["__v"] ?? 0,
      score: json["score"], // optional
    );
  }
}

class DurationModel {
  final int value;
  final DurationUnit unit;

  DurationModel({required this.value, required this.unit});

  factory DurationModel.fromJson(Map<String, dynamic> json) {
    return DurationModel(
      value: json["value"] ?? 0,
      unit: DurationUnitExtension.fromInt(json["unit"] ?? 0),
    );
  }
}
