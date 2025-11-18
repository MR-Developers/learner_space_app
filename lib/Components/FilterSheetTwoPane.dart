import 'package:flutter/material.dart';

class FilterSheetTwoPane extends StatefulWidget {
  const FilterSheetTwoPane({super.key});

  @override
  State<FilterSheetTwoPane> createState() => _FilterSheetTwoPaneState();
}

class _FilterSheetTwoPaneState extends State<FilterSheetTwoPane> {
  static const Color brandColor = Color(0xFFEF7C08);

  int selectedIndex = 0;

  final List<String> filterSections = [
    "Language",
    "Price",
    "Customer Rating",
    "Latest Arrivals",
    "Offers",
    "Scholarship",
    "Placement assistance",
    "Mode",
  ];

  // LANGUAGE
  final List<String> languages = [
    "Telugu",
    "Hindi",
    "English",
    "Tamil",
    "Kannada",
    "Marathi",
  ];
  List<String> selectedLanguages = [];

  // PRICE
  RangeValues price = const RangeValues(0, 50000);

  // CUSTOMER RATING
  String rating = "Any";

  // LATEST ARRIVALS
  String arrivalFilter = "Any";

  // OFFERS
  final List<String> offersList = [
    "Free Demo",
    "Discount Available",
    "Cashback",
    "EMI Options",
  ];
  List<String> selectedOffers = [];

  // SCHOLARSHIP
  String scholarship = "Any";

  // PLACEMENT
  String placement = "Any";

  // MODE
  final List<String> modes = ["Online", "Offline", "Hybrid"];
  List<String> selectedModes = [];

  @override
  Widget build(BuildContext context) {
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: _buildRightPanel(),
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
                    decoration: const BoxDecoration(
                      color: Colors.white,
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
                        onPressed: () => Navigator.pop(context),
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
    return Container(
      width: 130,
      color: const Color(0xFFF1F4F6),
      child: ListView.builder(
        itemCount: filterSections.length,
        itemBuilder: (context, index) {
          bool isActive = selectedIndex == index;

          return InkWell(
            onTap: () => setState(() => selectedIndex = index),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : Colors.transparent,
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
                  color: isActive ? brandColor : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------------- RIGHT PANEL (Dynamic) ----------------
  Widget _buildRightPanel() {
    switch (selectedIndex) {
      case 0:
        return _buildLanguageFilter();
      case 1:
        return _buildPriceFilter();
      case 2:
        return _buildRatingFilter();
      case 3:
        return _buildArrivalFilter();
      case 4:
        return _buildOffersFilter();
      case 5:
        return _buildScholarshipFilter();
      case 6:
        return _buildPlacementFilter();
      case 7:
        return _buildModeFilter();
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------- LANGUAGE UI ----------------
  Widget _buildLanguageFilter() {
    return ListView(
      children: [
        for (final lang in languages) _buildCheckbox(lang, selectedLanguages),
      ],
    );
  }

  // ---------------- PRICE UI ----------------
  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Price", style: TextStyle(fontSize: 18)),
        const SizedBox(height: 20),
        RangeSlider(
          values: price,
          min: 0,
          max: 100000,
          activeColor: brandColor,
          onChanged: (v) => setState(() => price = v),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("₹${price.start.toInt()}"),
            Text("₹${price.end.toInt()}"),
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

  // ---------------- OFFERS UI ----------------
  Widget _buildOffersFilter() {
    return ListView(
      children: [
        for (var offer in offersList) _buildCheckbox(offer, selectedOffers),
      ],
    );
  }

  // ---------------- SCHOLARSHIP UI ----------------
  Widget _buildScholarshipFilter() {
    List<String> options = ["Any", "Available", "Not Available"];

    return ListView(
      children: [
        for (var opt in options)
          _buildRadio(opt, scholarship, (v) => setState(() => scholarship = v)),
      ],
    );
  }

  // ---------------- PLACEMENT UI ----------------
  Widget _buildPlacementFilter() {
    List<String> options = ["Any", "Guaranteed", "Assisted", "None"];

    return ListView(
      children: [
        for (var opt in options)
          _buildRadio(opt, placement, (v) => setState(() => placement = v)),
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
                border: Border.all(width: 2, color: Colors.black),
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

    return GestureDetector(
      onTap: () => onChange(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Icon(
              active ? Icons.radio_button_checked : Icons.radio_button_off,
              color: active ? brandColor : Colors.black54,
            ),
            const SizedBox(width: 12),
            Text(label, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
