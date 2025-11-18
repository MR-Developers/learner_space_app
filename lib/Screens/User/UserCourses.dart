import 'package:flutter/material.dart';
import 'package:learner_space_app/Components/FilterSheetTwoPane.dart';
import 'package:lucide_icons/lucide_icons.dart';

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

  // -----------------------------
  // COURSE LIST
  // -----------------------------
  final List<Map<String, dynamic>> courses = [
    {
      "id": "1",
      "title": "Full Stack Web Development Bootcamp",
      "startup": "CodeMaster Academy",
      "rating": 4.8,
      "reviews": 2456,
      "students": 12400,
      "salary": "₹8-12 LPA",
      "duration": "6 months",
      "category": "Tech",
      "verified": true,
    },
    {
      "id": "2",
      "title": "Product Management Masterclass",
      "startup": "PMSchool",
      "rating": 4.9,
      "reviews": 1823,
      "students": 8900,
      "salary": "₹12-18 LPA",
      "duration": "4 months",
      "category": "Business",
      "verified": true,
    },
    {
      "id": "3",
      "title": "UI/UX Design Pro",
      "startup": "DesignHub",
      "rating": 4.7,
      "reviews": 1567,
      "students": 7200,
      "salary": "₹6-10 LPA",
      "duration": "5 months",
      "category": "Design",
      "verified": true,
    },
    {
      "id": "4",
      "title": "Data Science & Machine Learning",
      "startup": "AILearn",
      "rating": 4.8,
      "reviews": 3201,
      "students": 15600,
      "salary": "₹10-16 LPA",
      "duration": "7 months",
      "category": "Tech",
      "verified": true,
    },
    {
      "id": "5",
      "title": "Digital Marketing Mastery",
      "startup": "GrowthAcademy",
      "rating": 4.6,
      "reviews": 1234,
      "students": 5600,
      "salary": "₹5-9 LPA",
      "duration": "3 months",
      "category": "Marketing",
      "verified": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildHeader(theme),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                children: [...courses.map((c) => _buildCourseCard(context, c))],
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
              const Spacer(),
              IconButton(
                style: IconButton.styleFrom(shape: const CircleBorder()),
                onPressed: () {},
                icon: Icon(LucideIcons.gitCompare, color: primary),
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

  // -----------------------------
  // COURSE LIST ITEM
  // -----------------------------
  Widget _buildCourseCard(BuildContext context, Map<String, dynamic> course) {
    final theme = Theme.of(context);

    return Container(
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
          // LEFT ICON BOX
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(LucideIcons.bookOpen, color: primary, size: 34),
          ),
          const SizedBox(width: 16),

          // COURSE DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TITLE + VERIFIED BADGE
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        course["title"],
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (course["verified"])
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.shade500,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Text(
                          "Verified",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 4),
                Text(
                  course["startup"],
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 16, color: primary.withOpacity(0.9)),
                    const SizedBox(width: 4),
                    Text(
                      "${course["rating"]}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      " (${course["reviews"]})",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(width: 16),
                    const Icon(LucideIcons.users, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      "${course["students"]}",
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
                        course["duration"],
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      course["salary"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      useSafeArea: true, // <-- IMPORTANT
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
