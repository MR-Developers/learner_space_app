import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/profile_service.dart';
import 'package:learner_space_app/Utils/UserSession.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileService _profileService = ProfileService();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _error;

  static const Color brandColor = Color(0xFFEF7C08);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final userId = await UserSession.getUserId();
      final user = await _profileService.getUserInfo(userId!);

      final name = user['name'];

      _firstNameController.text = name['firstname'] ?? '';
      _middleNameController.text = name['middlename'] ?? '';
      _lastNameController.text = name['lastname'] ?? '';
      _ageController.text = user['age']?.toString() ?? '';
      _phoneController.text = user['number']?.toString() ?? '';

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final userId = await UserSession.getUserId();

      await _profileService.updateUserProfile(userId!, {
        "name": {
          "firstname": _firstNameController.text.trim(),
          "middlename": _middleNameController.text.trim(),
          "lastname": _lastNameController.text.trim(),
        },
        "age": int.parse(_ageController.text.trim()),
        "number": _phoneController.text.trim(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully")),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _firstNameController,
                      label: "First Name",
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _middleNameController,
                      label: "Middle Name",
                      icon: Icons.person_outline,
                      isRequired: false,
                    ),
                    _buildTextField(
                      controller: _lastNameController,
                      label: "Last Name",
                      icon: Icons.person,
                    ),
                    _buildTextField(
                      controller: _ageController,
                      label: "Age",
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: brandColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: _isSaving
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                "Save Changes",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = true, // 👈 NEW
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: isRequired
            ? (value) =>
                  value == null || value.isEmpty ? "Required field" : null
            : null, // 👈 OPTIONAL FIELD
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
