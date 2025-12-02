import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/categories_service.dart';
import 'package:learner_space_app/Apis/Services/course_service.dart';
import 'package:learner_space_app/Components/FilterSheetTwoPane.dart';
import 'package:learner_space_app/Data/Models/CourseModel.dart';
import 'package:learner_space_app/Data/Enums/Enums.dart';
import 'package:learner_space_app/Utils/UserSession.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final TextEditingController _searchController = TextEditingController();

  static const Color brandColor = Color(0xFFEF7C08);

  String selectedCategory = "All";
  final categoryService = CategoryService();

  List<CourseModel> categoryCourses = [];
  bool isCategoryLoading = false;

  final List<Map<String, dynamic>> categories = [
    {"name": "All", "count": 0},
    {"name": "Tech", "count": 0},
    {"name": "Business", "count": 0},
    {"name": "Design", "count": 0},
    {"name": "Marketing", "count": 0},
  ];

  List<CourseModel> recommendedCourses = [];
  bool isLoading = true;
  String? errorMessage;

  final Map<String, int?> categoryMap = {
    "All": null,
    "Tech": 0,
    "Business": 1,
    "Design": 2,
    "Marketing": 3,
  };

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

  Future<void> _loadCategoryCounts() async {
    try {
      for (var item in categories) {
        if (item["name"] == "All") continue;

        final categoryId = categoryMap[item["name"]];
        if (categoryId == null) continue;

        final response = await categoryService.getCompanyCategoryCount(
          categoryId,
        );

        final count = response["data"]["courseCount"] ?? 0;

        item["count"] = count;
      }

      if (mounted) setState(() {});
    } catch (e) {
      print("Failed to load counts: $e");
    }
  }

  Future<void> _loadRecommendedCourses() async {
    try {
      if (!mounted) return;
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final userId = await UserSession.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception("User ID missing");
      }

      final response = await CourseService().getRecommendedCourses(userId);

      // safe parse: response["data"] or response
      final data = response["data"] ?? response;

      final list = (data as List<dynamic>).map((e) {
        return CourseModel.fromJson(e);
      }).toList();

      if (!mounted) return;
      setState(() {
        recommendedCourses = list;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _loadCoursesByCategory(String categoryName) async {
    try {
      if (!mounted) return;
      setState(() {
        isCategoryLoading = true;
        errorMessage = null;
      });

      final userId = await UserSession.getUserId();
      if (userId == null || userId.isEmpty) {
        throw Exception("User ID missing");
      }

      final categoryId = categoryMap[categoryName];

      // If "All", clear categoryCourses and reload recommended
      if (categoryId == null) {
        // Clear any category-specific data
        categoryCourses = [];
        await _loadRecommendedCourses();
        if (!mounted) return;
        setState(() => isCategoryLoading = false);
        return;
      }

      final response = await CourseService().getRecommendedCourseByCategory(
        userId,
        categoryId.toString(),
      );

      final data = response["data"] ?? response;

      final list = (data as List<dynamic>).map((e) {
        return CourseModel.fromJson(e);
      }).toList();

      if (!mounted) return;
      setState(() {
        categoryCourses = list;
        isCategoryLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isCategoryLoading = false;
        errorMessage = e.toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadCategoryCounts();
    _loadRecommendedCourses();
  }

  Widget _buildRecommendedSection() {
    if (recommendedCourses.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Recommended For You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
            children: recommendedCourses.take(3).map((course) {
              return _courseCard(course);
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a column with an Expanded ListView for the course list so the page scrolls correctly
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildSearchBar(),
            const SizedBox(height: 12),
            Expanded(child: _buildContentArea(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildContentArea(BuildContext context) {
    // The content area will be a scrollable ListView so the top parts remain visible
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        const SizedBox(height: 8),
        _buildPremiumReferralBanner(),
        const SizedBox(height: 16),
        _buildStatsCard(),
        const SizedBox(height: 16),
        _buildQuickCards(),
        const SizedBox(height: 16),
        _buildCategoryChips(),
        const SizedBox(height: 16),
        // Recommended or Category-specific featured courses
        if (isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          )
        else ...[
          if (selectedCategory == "All") ...[
            _buildRecommendedSection(),
            const SizedBox(height: 20),
          ],
          _buildFeaturedCourses(),
        ],
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Learner Space",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Find your perfect course",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              _headerIcon(LucideIcons.bell),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/profile");
                },
                child: _headerIcon(LucideIcons.user),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Icon(icon, size: 22),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search courses, skills, careers...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(LucideIcons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
          Positioned(
            right: 6,
            top: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: _openFilterSheet,
                icon: const Icon(LucideIcons.filter),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumReferralBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/referrals");
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                brandColor.withOpacity(0.15),
                brandColor.withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: brandColor),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: brandColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  LucideIcons.crown,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Premium Referral Network",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    Text(
                      "Get job referrals from our community • Enroll to unlock",
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((c) {
          final bool active = c['name'] == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text("${c['name']} (${c['count']})"),
              selected: active,
              selectedColor: brandColor,
              backgroundColor: Colors.white,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: active ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onSelected: (_) async {
                // Update selection then load
                setState(() => selectedCategory = c['name']);
                await _loadCoursesByCategory(selectedCategory);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [brandColor, brandColor.withOpacity(0.8)],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "This Week's Highlight",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text(
                  "92% Success Rate",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "from verified learners",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Icon(
              LucideIcons.trendingUp,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _quickCard("Reviews", LucideIcons.star)),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "/userOutcomes");
              },
              child: _quickCard("Outcomes", LucideIcons.trendingUp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _quickCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: brandColor),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            title == "Reviews" ? "100% verified" : "Real placements",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourses() {
    final listToShow = selectedCategory == "All"
        ? recommendedCourses
        : categoryCourses;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedCategory == "All"
                    ? "Featured Courses"
                    : "Top $selectedCategory Courses",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("View All", style: TextStyle(color: brandColor)),
            ],
          ),
          const SizedBox(height: 12),

          if (isCategoryLoading)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (listToShow.isEmpty)
            Padding(
              padding: const EdgeInsets.all(40),
              child: Text(
                "No courses found",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            )
          else
            Column(
              children: listToShow.map((course) {
                return _courseCard(course);
              }).toList(),
            ),
        ],
      ),
    );
  }

  Widget _courseCard(CourseModel course) {
    final imageUrl = course.courseImage.isNotEmpty ? course.courseImage[0] : "";
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/courseDetails", arguments: course.id);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 72,
                      height: 72,
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
                  // title + verified
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          course.courseName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    course.companyName,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            "${course.noOfLeads}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " (${course.noOfLeads})",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          const Icon(LucideIcons.users, size: 14),
                          const SizedBox(width: 3),
                          Text("${course.noOfLeads}"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "${course.duration.value} ${course.duration.unit.label}",
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "₹${course.price}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: brandColor,
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
}
