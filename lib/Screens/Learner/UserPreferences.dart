import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/preferences_service.dart';
import 'package:learner_space_app/Utils/UserSession.dart';

class PreferencesSetupScreen extends StatefulWidget {
  const PreferencesSetupScreen({super.key});

  @override
  State<PreferencesSetupScreen> createState() => _PreferencesSetupScreenState();
}

class _PreferencesSetupScreenState extends State<PreferencesSetupScreen> {
  final PreferencesService _service = PreferencesService();
  static const Color brandColor = Color(0xFFEF7C08);
  // ================= STEP STATE =================
  int _currentStep = 0;

  // ================= FORM STATE =================
  List<int> companyCategories = [];
  List<int> courseCategories = [];

  RangeValues priceRange = const RangeValues(0, 20000);

  final Set<String> selectedModes = {};
  final Set<String> selectedLanguages = {};

  bool placementRequired = false;
  int? maxDuration;

  final List<String> keywords = [];
  final TextEditingController keywordController = TextEditingController();

  bool isSubmitting = false;

  // ================= OPTIONS =================
  final modes = ["Online", "Offline", "Hybrid"];
  final languages = ["English", "Hindi", "Telugu"];
  final durations = [1, 3, 6, 9, 12];

  final stepTitles = ["Learning Style", "Budget & Duration", "Keywords"];
  final stepDescriptions = [
    "Choose your preferred course format",
    "Set your budget and time constraints",
    "Add keywords to personalize recommendations",
  ];

  // ================= SUBMIT =================
  Future<void> _submit() async {
    final userId = await UserSession.getUserId();
    if (userId == null) return;

    setState(() => isSubmitting = true);

    final payload = {
      "preferredCompanyCategories": companyCategories,
      "preferredCourseCategories": courseCategories,
      "minPrice": priceRange.start.round(),
      "maxPrice": priceRange.end.round(),
      "preferredModes": selectedModes.toList(),
      "preferredLanguages": selectedLanguages.toList(),
      "placementRequired": placementRequired,
      "maxDurationValue": maxDuration,
      "keywordTags": keywords,
    };

    try {
      await _service.createUserPreferences(userId, payload);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/home");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  // ================= SKIP =================
  void _skip() {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? colors.onSurface : Colors.white,
        title: const Text("Skip preferences?"),
        content: const Text(
          "You can set your preferences later from settings.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: brandColor, // 🔥 brand color
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: const Text("Skip"),
          ),
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? colors.surface : Colors.grey[50],
      appBar: AppBar(
        title: const Text("Set Your Preferences"),
        backgroundColor: isDark ? colors.surface : Colors.white,
        elevation: 0,
        actions: [
          TextButton.icon(
            onPressed: isSubmitting ? null : _skip,
            icon: const Icon(Icons.skip_next, size: 18),
            label: const Text("Skip"),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _buildStepIndicator(colors),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepHeader(),
                  const SizedBox(height: 24),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildCurrentStep(),
                  ),
                ],
              ),
            ),
          ),
          _buildBottomBar(colors),
        ],
      ),
    );
  }

  // ================= STEP INDICATOR =================
  Widget _buildStepIndicator(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withOpacity(0.3),
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index == _currentStep;
          final isCompleted = index < _currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: isCompleted || isActive
                              ? brandColor
                              : colors.surfaceContainerHighest,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isActive
                                ? brandColor
                                : colors.outline.withOpacity(0.3),
                            width: isActive ? 2 : 1,
                          ),
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(
                                  Icons.check,
                                  color: colors.onPrimary,
                                  size: 18,
                                )
                              : Text(
                                  "${index + 1}",
                                  style: TextStyle(
                                    color: isActive
                                        ? colors.onPrimary
                                        : colors.onSurfaceVariant,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stepTitles[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          color: isActive
                              ? brandColor
                              : colors.onSurfaceVariant,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (index < 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      margin: const EdgeInsets.only(bottom: 24),
                      color: isCompleted
                          ? brandColor
                          : colors.outlineVariant.withOpacity(0.3),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          stepTitles[_currentStep],
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          stepDescriptions[_currentStep],
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    return Container(
      key: ValueKey(_currentStep),
      child: _currentStep == 0
          ? _stepOne()
          : _currentStep == 1
          ? _stepTwo()
          : _stepThree(),
    );
  }

  // ================= STEP 1 =================
  Widget _stepOne() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Course Mode", Icons.laptop),
              const SizedBox(height: 12),
              _optionChips(modes, selectedModes),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Preferred Languages", Icons.language),
              const SizedBox(height: 12),
              _optionChips(languages, selectedLanguages),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                Icon(Icons.work_outline, size: 20, color: brandColor),
                const SizedBox(width: 12),
                const Text("Placement Assistance"),
              ],
            ),
            value: placementRequired,
            onChanged: (v) => setState(() => placementRequired = v),
          ),
        ),
      ],
    );
  }

  // ================= STEP 2 =================
  Widget _stepTwo() {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Price Range", Icons.currency_rupee),
              const SizedBox(height: 8),
              Text(
                "₹${priceRange.start.round().toStringAsFixed(0)} - ₹${priceRange.end.round().toStringAsFixed(0)}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brandColor,
                ),
              ),
              RangeSlider(
                values: priceRange,
                min: 0,
                max: 50000,
                divisions: 50,
                labels: RangeLabels(
                  "₹${priceRange.start.round()}",
                  "₹${priceRange.end.round()}",
                ),
                onChanged: (v) => setState(() => priceRange = v),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Maximum Duration", Icons.schedule),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: maxDuration,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  hintText: "Select duration",
                ),
                items: durations
                    .map(
                      (d) => DropdownMenuItem(
                        value: d,
                        child: Text("$d ${d == 1 ? 'month' : 'months'}"),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => maxDuration = v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= STEP 3 =================
  Widget _stepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Interest Keywords", Icons.label_outline),
              const SizedBox(height: 12),
              if (keywords.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: keywords
                      .map(
                        (k) => Chip(
                          label: Text(k),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          onDeleted: () => setState(() => keywords.remove(k)),
                        ),
                      )
                      .toList(),
                ),
              if (keywords.isNotEmpty) const SizedBox(height: 16),
              TextField(
                controller: keywordController,
                decoration: InputDecoration(
                  hintText: "Type a keyword and press enter",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.add),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onSubmitted: (v) {
                  if (v.trim().isNotEmpty && !keywords.contains(v.trim())) {
                    setState(() {
                      keywords.add(v.trim());
                      keywordController.clear();
                    });
                  }
                },
              ),
              const SizedBox(height: 8),
              Text(
                "Examples: Python, Web Development, Data Science, AI",
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= HELPERS =================
  Widget _buildCard({required Widget child}) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? colors.surfaceContainer : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: child,
    );
  }

  Widget _sectionTitle(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: brandColor),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _optionChips(List<String> items, Set<String> target) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final isSelected = target.contains(item);
        return FilterChip(
          label: Text(item),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              selected ? target.add(item) : target.remove(item);
            });
          },
          showCheckmark: true,
        );
      }).toList(),
    );
  }

  Widget _buildBottomBar(ColorScheme colors) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(
          top: BorderSide(color: colors.outlineVariant.withOpacity(0.5)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              OutlinedButton.icon(
                onPressed: isSubmitting
                    ? null
                    : () => setState(() => _currentStep--),
                icon: const Icon(Icons.arrow_back, size: 18),
                label: const Text("Back"),
              ),
            const Spacer(),
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: brandColor,
                foregroundColor: Colors.white,
              ),
              onPressed: isSubmitting
                  ? null
                  : (_currentStep == 2
                        ? _submit
                        : () => setState(() => _currentStep++)),
              icon: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      _currentStep == 2 ? Icons.check : Icons.arrow_forward,
                      size: 18,
                    ),
              label: Text(_currentStep == 2 ? "Finish" : "Next"),
            ),
          ],
        ),
      ),
    );
  }
}
