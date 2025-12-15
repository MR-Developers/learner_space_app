import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/outcome_service.dart';
import 'package:learner_space_app/Utils/UserSession.dart';

class SubmitOutcomePage extends StatefulWidget {
  final String courseId;

  const SubmitOutcomePage({super.key, required this.courseId});

  @override
  State<SubmitOutcomePage> createState() => _SubmitOutcomePageState();
}

class _SubmitOutcomePageState extends State<SubmitOutcomePage> {
  final OutcomeService _outcomeService = OutcomeService();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _packageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  bool _isSubmitting = false;
  bool _featured = false;

  // 🔐 LPA-only normalization
  String _normalizePackageLpa(String value) {
    final v = value.trim();

    if (v.isEmpty) return v;

    // Remove ₹ if present
    final cleaned = v.replaceAll('₹', '').trim();

    // number or decimal + LPA
    final lpaRegex = RegExp(r'^(\d+(\.\d+)?)\s*LPA$', caseSensitive: false);

    final match = lpaRegex.firstMatch(cleaned);
    if (match == null) {
      throw Exception("Package must be in LPA format (e.g. 12 LPA)");
    }

    final number = match.group(1);
    return '₹$number LPA';
  }

  Future<void> _submitOutcome() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final userId = await UserSession.getUserId();

      final payload = {
        "companyPlaced": _companyController.text.trim(),
        "package": _normalizePackageLpa(_packageController.text),
        "description": _descriptionController.text.trim(),
        "courseId": widget.courseId,
        "userId": userId,
        "featured": _featured,
      };

      final res = await _outcomeService.createOutcome(payload);

      if (!mounted) return;

      if (res['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Outcome submitted successfully 🎉"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(true);
      } else {
        throw Exception(res['message'] ?? 'Submission failed');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _companyController.dispose();
    _packageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          "Submit Placement Outcome",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Share your success 🎉",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Help future learners by sharing your placement outcome.",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Form Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildField(
                      controller: _companyController,
                      label: "Company Placed",
                      hint: "e.g. Amazon, Google",
                      icon: Icons.business_center_outlined,
                    ),
                    const SizedBox(height: 16),
                    _buildPackageField(),
                    const SizedBox(height: 16),
                    _buildField(
                      controller: _descriptionController,
                      label: "Description",
                      hint: "Your role, interview experience, tips…",
                      maxLines: 4,
                      icon: Icons.description_outlined,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Featured switch
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SwitchListTile(
                  value: _featured,
                  onChanged: (v) => setState(() => _featured = v),
                  activeThumbColor: const Color(0xFFFF6B35),
                  title: const Text(
                    "Mark as featured",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    "Featured outcomes may be highlighted after verification",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ),
              ),

              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitOutcome,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Submit Outcome",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Package field with strict LPA validation
  Widget _buildPackageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Package",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _packageController,
          keyboardType: TextInputType.text,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return "Package is required";
            }

            final cleaned = v.replaceAll('₹', '').trim();
            final lpaRegex = RegExp(
              r'^(\d+(\.\d+)?)\s*LPA$',
              caseSensitive: false,
            );

            if (!lpaRegex.hasMatch(cleaned)) {
              return "Enter package in LPA (e.g. 12 LPA)";
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: "e.g. ₹12 LPA",
            prefixIcon: Icon(
              Icons.payments_outlined,
              color: Colors.grey.shade600,
            ),
            filled: true,
            fillColor: Colors.grey.shade100,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required IconData icon,
  int maxLines = 1,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      const SizedBox(height: 8),
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.grey.shade600),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ],
  );
}
