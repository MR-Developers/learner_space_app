import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/course_service.dart';
import 'package:learner_space_app/Components/FilterSheetTwoPane.dart';
import 'package:learner_space_app/Data/Enums/Enums.dart';
import 'package:learner_space_app/Data/Models/CourseModel.dart';
import 'package:learner_space_app/Utils/CacheManager.dart';
import 'package:learner_space_app/Utils/CourseCacheManager.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  // FILTER STATES
  RangeValues priceRange = const RangeValues(0, 200000);
  List<String> selectedCategories = [];
  List<CourseLanguage> selectedLanguages = [];
  List<CourseModel> suggestions = [];
  bool showSuggestions = true;

  String searchQuery = "";
  String minRating = "0";
  String? placementType;
  String mode = "";

  List<CourseModel> courses = [];
  bool isLoading = false;
  bool filtersApplied = false;

  Timer? _debounce;

  void _openFilterSheet() async {
    final filters = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      useSafeArea: true,
      builder: (context) {
        return FilterSheetTwoPane(
          selectedCategories: selectedCategories,
          selectedLanguages: selectedLanguages,
          minPrice: priceRange.start,
          maxPrice: priceRange.end,
          rating: minRating,
          modes: [mode],
          placement: placementType ?? "Any",
        );
      },
    );

    if (filters != null) {
      _applyFilters(filters);
    }
  }

  Future<void> _loadSuggestions() async {
    setState(() => isLoading = true);

    try {
      final result = await CourseService().getCourses(page: 1, limit: 10);

      setState(() {
        suggestions = (result["data"]?["courses"] as List<dynamic>? ?? [])
            .map((e) => CourseModel.fromJson(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      showSuggestions = false;
      filtersApplied = true;

      selectedCategories = filters["categories"] ?? [];
      selectedLanguages = filters["languages"] ?? [];

      priceRange = RangeValues(
        filters["minPrice"] ?? 0,
        filters["maxPrice"] ?? 200000,
      );

      minRating = filters["rating"] ?? "0";
      placementType = filters["placement"];
      mode = filters["modes"]?.isNotEmpty == true ? filters["modes"][0] : "";
    });

    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() => isLoading = true);

    try {
      final result = await CourseService().getCourses(
        page: 1,
        limit: 20,
        courseCategory: selectedCategories,
        priceMin: priceRange.start,
        priceMax: priceRange.end,
        mode: mode,
        placementAssistance: placementType,
        language: selectedLanguages.map((e) => e.apiValue).toList(),
        search: searchQuery,
      );

      setState(() {
        courses = (result["data"]?["courses"] as List<dynamic>? ?? [])
            .map((e) => CourseModel.fromJson(e))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint(e.toString());
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSuggestions();
  }

  Widget _buildSectionHeader(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colors.surface : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? colors.surface : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),

        /// 👇 Put search bar here
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(72),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
            child: _buildSearchBar(context),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  showSuggestions ? "Recommended Courses" : "Search Results",
                  subtitle: showSuggestions
                      ? "Handpicked courses you might like"
                      : "${courses.length} courses found",
                ),

                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: showSuggestions
                        ? suggestions.length
                        : courses.length,
                    itemBuilder: (context, index) {
                      final course = showSuggestions
                          ? suggestions[index]
                          : courses[index];
                      return _buildCourseCard(
                        context,
                        course,
                        isSuggested: showSuggestions,
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (searchQuery.isNotEmpty) {
        showSuggestions = false;
        _loadCourses();
      } else {
        showSuggestions = true;
      }
      setState(() {});
    });
  }

  /// 🔁 EXACT SAME SEARCH BAR AS HOME
  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          /// SEARCH FIELD
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              onChanged: (value) {
                searchQuery = value;
                _onSearchChanged();
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? colors.surface : Colors.white,
                hintStyle: TextStyle(color: colors.onSurface.withOpacity(0.5)),
                prefixIcon: Icon(LucideIcons.search, color: colors.onSurface),

                /// ✅ Clear icon ONLY
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          _controller.clear();
                          searchQuery = "";
                          showSuggestions = true;
                          setState(() {});
                        },
                      )
                    : null,

                hintText: "Search for courses",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: colors.outline),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: colors.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(color: colors.primary),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// FILTER BUTTON (SEPARATE)
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: _openFilterSheet,
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(LucideIcons.filter, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCourseCard(
  BuildContext context,
  CourseModel course, {
  bool isSuggested = false,
}) {
  final theme = Theme.of(context);
  final colors = theme.colorScheme;
  final isDark = Theme.of(context).brightness == Brightness.dark;

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
        border: isDark
            ? Border.all(color: colors.outline.withOpacity(0.3))
            : Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(26),
        color: theme.colorScheme.surface,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: imageUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: imageUrl,
                    cacheManager: CourseCacheManager(),
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
                if (isSuggested)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Suggested",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

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
                    color: colors.onSurface,
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
                    Text(" ($reviews)", style: const TextStyle()),
                    const SizedBox(width: 16),
                    const Icon(LucideIcons.users, size: 14),
                    const SizedBox(width: 4),
                    Text("$students", style: const TextStyle()),
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
                        color: colors.onSurface.withOpacity(0.2),
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
