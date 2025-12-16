import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/course_service.dart';
import 'package:learner_space_app/Apis/Services/categories_service.dart';
import 'package:learner_space_app/Data/Enums/Enums.dart';

class FilterSheetTwoPane extends StatefulWidget {
  final List<String> selectedCategories;
  final List<CourseLanguage> selectedLanguages;
  final double minPrice;
  final double maxPrice;
  final String rating;
  final List<String> modes;
  final String placement;

  const FilterSheetTwoPane({
    super.key,
    this.selectedCategories = const [],
    this.selectedLanguages = const [],
    this.minPrice = 0,
    this.maxPrice = 50000,
    this.rating = "Any",
    this.modes = const [],
    this.placement = "false",
  });

  @override
  State<FilterSheetTwoPane> createState() => _FilterSheetTwoPaneState();
}

class _FilterSheetTwoPaneState extends State<FilterSheetTwoPane> {
  static const Color brandColor = Color(0xFFEF7C08);

  int selectedIndex = 0;

  final List<String> filterSections = [
    "Categories",
    "Language",
    "Price",
    "Customer Rating",
    "Latest Arrivals",
    "Placement assistance",
    "Mode",
  ];

  //CATEGORIES
  List<dynamic> categories = [];
  List<String> selectedCategories = [];
  bool isLoadingCategories = true;

  // LANGUAGE
  final List<CourseLanguage> languages = CourseLanguage.values;

  List<CourseLanguage> selectedLanguages = [];

  // PRICE
  RangeValues price = const RangeValues(0, 50000);
  double minPrice = 0;
  double maxPrice = 50000;

  // CUSTOMER RATING
  String rating = "Any";

  // LATEST ARRIVALS
  String arrivalFilter = "Any";

  List<String> selectedOffers = [];

  // PLACEMENT
  String? placement;

  // MODE
  final List<String> modes = ["Online", "Offline", "Hybrid"];
  List<String> selectedModes = [];
  @override
  void initState() {
    super.initState();

    // restore values from parent
    selectedCategories = List.from(widget.selectedCategories);
    selectedLanguages = List.from(widget.selectedLanguages);
    minPrice = widget.minPrice;
    maxPrice = widget.maxPrice;
    rating = widget.rating;
    selectedModes = List.from(widget.modes);
    if (widget.placement == "true") {
      placement = "Yes";
    } else if (widget.placement == "false") {
      placement = "No";
    } else {
      placement = "Any";
    }

    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final response = await CategoryService().getAllCategories();
      printFull(response);
      // Your API returns a MAP, so extract the list
      categories = response["data"] ?? response["categories"] ?? [];

      setState(() {
        isLoadingCategories = false;
      });
    } catch (e) {
      isLoadingCategories = false;
      setState(() {});
    }
  }

  void printFull(Object? value) {
    final jsonString = const JsonEncoder.withIndent('  ').convert(value);
    final pattern = RegExp('.{1,800}'); // print 800 characters at a time
    pattern.allMatches(jsonString).forEach((match) => print(match.group(0)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.92,
      child: Row(
        children: [
          _buildLeftMenu(),

          // RIGHT SIDE with APPLY BUTTON
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    color: colors.surface,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: _buildRightPanel(),
                    ),
                  ),
                ),

                // APPLY BUTTON FIXED AT BOTTOM
                SafeArea(
                  bottom: true,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, -2),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, {
                            "categories": selectedCategories,
                            "languages": selectedLanguages,
                            "minPrice": minPrice,
                            "maxPrice": maxPrice,
                            "rating": rating,
                            "placement": placement == "Any"
                                ? null
                                : placement == "Yes"
                                ? "true"
                                : "false",
                            "modes": selectedModes,
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- LEFT MENU ----------------
  Widget _buildLeftMenu() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      width: 130,
      color: colors.surfaceBright,
      child: ListView.builder(
        itemCount: filterSections.length,
        itemBuilder: (context, index) {
          bool isActive = selectedIndex == index;

          return InkWell(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? colors.surface : Colors.transparent,
                border: Border(
                  left: BorderSide(
                    color: isActive ? brandColor : Colors.transparent,
                    width: 3,
                  ),
                ),
              ),
              child: Text(
                filterSections[index],
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  color: isActive ? brandColor : colors.onSurface,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightPanel() {
    switch (selectedIndex) {
      case 0:
        return _buildCategoryFilter();
      case 1:
        return _buildLanguageFilter();
      case 2:
        return _buildPriceFilter();
      case 3:
        return _buildRatingFilter();
      case 4:
        return _buildArrivalFilter();
      case 5:
        return _buildPlacementFilter();
      case 6:
        return _buildModeFilter();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoryFilter() {
    if (isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categories.isEmpty) {
      return const Center(child: Text("No categories available"));
    }

    return ListView(
      children: [
        for (var cat in categories) ...[
          // Main Category Heading
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              cat["name"] ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 8),

          // ⭐ Dynamic wrapping subcategories
          if (cat["courseCategories"] != null)
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                for (var sub in cat["courseCategories"])
                  IntrinsicWidth(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        minWidth: 120, // Minimum block width
                        maxWidth: 180, // Max width so multiple can fit
                      ),
                      child: _buildCheckboxWithId(
                        sub["name"],
                        sub["CourseCategoryId"],
                      ),
                    ),
                  ),
              ],
            ),

          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildCheckboxWithId(String label, String id) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    bool checked = selectedCategories.contains(id);

    return GestureDetector(
      onTap: () {
        setState(() {
          checked ? selectedCategories.remove(id) : selectedCategories.add(id);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: colors.onSurface),
                borderRadius: BorderRadius.circular(8),
                color: checked ? brandColor : Colors.transparent,
              ),
              child: checked
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ---------------- LANGUAGE UI ----------------
  Widget _buildLanguageFilter() {
    return ListView(
      children: [for (final lang in languages) _buildCheckboxLanguage(lang)],
    );
  }

  Widget _buildCheckboxLanguage(CourseLanguage lang) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final bool checked = selectedLanguages.contains(lang);

    return GestureDetector(
      onTap: () {
        setState(() {
          checked
              ? selectedLanguages.remove(lang)
              : selectedLanguages.add(lang);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: colors.onSurface),
                borderRadius: BorderRadius.circular(8),
                color: checked ? brandColor : Colors.transparent,
              ),
              child: checked
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(lang.label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ---------------- PRICE UI ----------------
  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Price", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),

        // 🔶 RANGE SLIDER
        RangeSlider(
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 200000,
          activeColor: brandColor,
          onChanged: (v) {
            setState(() {
              minPrice = v.start;
              maxPrice = v.end;
            });
          },
        ),

        const SizedBox(height: 12),

        // 🔶 MIN & MAX PRICE INPUTS
        Row(
          children: [
            // MIN PRICE
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Min Price",
                  border: OutlineInputBorder(),
                  prefixText: "₹ ",
                  prefixStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onChanged: (value) {
                  double val = double.tryParse(value) ?? 0;
                  if (val <= maxPrice) {
                    setState(() {
                      minPrice = val;
                    });
                  }
                },
                controller: TextEditingController(
                  text: minPrice.toInt().toString(),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // MAX PRICE
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Max Price",
                  border: OutlineInputBorder(),
                  prefixText: "₹ ",
                  prefixStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onChanged: (value) {
                  double val = double.tryParse(value) ?? maxPrice;
                  if (val >= minPrice) {
                    setState(() {
                      maxPrice = val;
                    });
                  }
                },
                controller: TextEditingController(
                  text: maxPrice.toInt().toString(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- RATING UI ----------------
  Widget _buildRatingFilter() {
    List<String> ratings = ["Any", "4 ★ & above", "4.5 ★ & above", "5 ★"];

    return ListView(
      children: [
        for (var r in ratings)
          _buildRadio(r, rating, (val) => setState(() => rating = val)),
      ],
    );
  }

  // ---------------- ARRIVALS UI ----------------
  Widget _buildArrivalFilter() {
    List<String> options = ["Any", "Last 30 days", "Last 90 days"];

    return ListView(
      children: [
        for (var opt in options)
          _buildRadio(
            opt,
            arrivalFilter,
            (val) => setState(() => arrivalFilter = val),
          ),
      ],
    );
  }

  // ---------------- PLACEMENT UI ----------------
  Widget _buildPlacementFilter() {
    // Display labels
    final List<String> options = ["Any", "Yes", "No"];

    return ListView(
      children: [
        for (var opt in options)
          _buildRadio(opt, placement!, (v) => setState(() => placement = v)),
      ],
    );
  }

  // ---------------- MODE UI ----------------
  Widget _buildModeFilter() {
    return ListView(
      children: [for (var m in modes) _buildCheckbox(m, selectedModes)],
    );
  }

  // ---------------- CHECKBOX ----------------
  Widget _buildCheckbox(String label, List<String> selectedList) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    bool checked = selectedList.contains(label);

    return GestureDetector(
      onTap: () {
        setState(() {
          checked ? selectedList.remove(label) : selectedList.add(label);
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: colors.onSurface),
                borderRadius: BorderRadius.circular(8),
                color: checked ? brandColor : Colors.transparent,
              ),
              child: checked
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  // ---------------- RADIO ----------------
  Widget _buildRadio(
    String label,
    String groupValue,
    Function(String) onChange,
  ) {
    bool active = label == groupValue;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return GestureDetector(
      onTap: () => onChange(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              active ? Icons.radio_button_checked : Icons.radio_button_off,
              color: active ? brandColor : colors.onSurface,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
