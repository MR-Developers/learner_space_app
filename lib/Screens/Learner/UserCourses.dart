import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learner_space_app/Components/FilterSheetTwoPane.dart';
import 'package:learner_space_app/Data/Models/CourseModel.dart';
import 'package:learner_space_app/Data/Enums/Enums.dart';
import 'package:learner_space_app/Utils/Loaders.dart';
import 'package:learner_space_app/Utils/UserSession.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:learner_space_app/Apis/Services/course_service.dart';

class UserCourses extends StatefulWidget {
  const UserCourses({super.key});

  @override
  State<UserCourses> createState() => _UserCoursesState();
}

class _UserCoursesState extends State<UserCourses> {
  static const Color primary = Color(0xFFEF7C08);

  // -----------------------------
  // FILTER STATES
  // -----------------------------
  RangeValues priceRange = const RangeValues(0, 200000);
  List<String> selectedCategories = [];
  String duration = "";
  String minRating = "0";
  String placementType = "";
  String mode = "";
  String eligibility = "";
  String language = "";
  String batchSize = "";
  String refundPolicy = "";
  String minOutcomes = "0";
  List<String> skills = [];
  List<dynamic> courses = [];
  List<dynamic> recommendedCourses = [];
  bool isLoading = true;
  String? errorMessage;

  // COURSE LIST
  Future<void> _loadCourses() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final userId = await UserSession.getUserId();

      if (userId == null || userId.isEmpty) {
        throw Exception("User not logged in. UID missing.");
      }

      final result = await CourseService().getCourses(page: 1, limit: 20);
      debugPrint(const JsonEncoder.withIndent('  ').convert(result));

      final recommended = await CourseService().getRecommendedCourses(userId);

      setState(() {
        courses =
            (result["data"]?["courses"] as List<dynamic>?)
                ?.map((e) => CourseModel.fromJson(e))
                .toList() ??
            [];

        recommendedCourses =
            (recommended["data"] as List<dynamic>?)
                ?.map((e) => CourseModel.fromJson(e))
                .toList() ??
            [];

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: isLoading
                ? _buildLoader()
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (recommendedCourses.isNotEmpty)
                          _buildRecommendedSection(context),
                        Text(
                          "Featured Courses",
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 20),
                        ...courses.map((c) => _buildCourseCard(context, c)),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // -----------------------------
  // HEADER WITH SEARCH + FILTERS
  // -----------------------------
  Widget _buildHeader(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          bottom: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Discover Courses",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${courses.length} courses found",
                    style: theme.textTheme.bodySmall!.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.black45),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration.collapsed(
                            hintText: "Search courses...",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // FILTER BUTTON LIKE SHADCN SHEET
              GestureDetector(
                onTap: () => _openFilterSheet(),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCard(BuildContext context, CourseModel course) {
    final theme = Theme.of(context);

    final imageUrl = course.courseImage.isNotEmpty
        ? course.courseImage.first
        : "";

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/courseDetails", arguments: course.id);
      },
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 160,
                      height: 80,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 160,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.image, size: 35),
                    ),
            ),

            const SizedBox(height: 8),

            Text(
              course.courseName,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "₹${course.price}",
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedSection(BuildContext context) {
    final theme = Theme.of(context);

    final List topThree = recommendedCourses.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Recommended for You",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),

        ...topThree.map((c) => _buildCourseCard(context, c)),
      ],
    );
  }

  Widget _buildCourseCard(BuildContext context, CourseModel course) {
    final theme = Theme.of(context);

    final String title = course.courseName;
    final String startup = course.companyName;

    final rating = course.noOfLeads.toDouble();
    final reviews = course.noOfLeads;
    final students = course.noOfLeads;

    final price = "₹${course.price}";

    final duration = "${course.duration.value} ${course.duration.unit.label}";

    final imageUrl = course.courseImage.isNotEmpty ? course.courseImage[0] : "";

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/courseDetails", arguments: course.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(26),
          color: theme.colorScheme.surface,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 70,
                      height: 70,
                      color: Colors.grey.shade200,
                      child: Icon(
                        LucideIcons.bookOpen,
                        color: Colors.orange,
                        size: 34,
                      ),
                    ),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    startup,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        "$rating",
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        " ($reviews)",
                        style: const TextStyle(color: Colors.black54),
                      ),
                      const SizedBox(width: 16),
                      const Icon(LucideIcons.users, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        "$students",
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black12,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Text(
                          duration,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        price,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // FILTER SHEET (BOTTOM SHEET)
  // -----------------------------
  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      useSafeArea: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: const FilterSheetTwoPane(),
        );
      },
    );
  }

  // -----------------------------
  // UI HELPERS
  // -----------------------------
  Widget _buildRadioGroup(
    String title,
    List<String> options,
    String selected,
    Function(String) onChange,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...options.map(
          (v) => RadioListTile(
            value: v,
            groupValue: selected,
            onChanged: (s) => onChange(s!),
            activeColor: primary,
            title: Text(v),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  Widget _buildLoader() {
    return ProfessionalCourseLoader();
  }

  Widget _buildCheckboxGroup({
    required String title,
    required List<String> items,
    required List<String> selectedList,
    required Function(String) onChange,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (e) => CheckboxListTile(
            value: selectedList.contains(e),
            title: Text(e),
            activeColor: primary,
            onChanged: (_) => onChange(e),
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }
}
