import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/profile_service.dart';
import 'package:learner_space_app/State/auth_provider.dart';
import 'package:learner_space_app/Utils/UserSession.dart';
import 'package:provider/provider.dart';

class MenuItem {
  final IconData icon;
  final String label;
  final int? count;
  final String route;

  MenuItem({
    required this.icon,
    required this.label,
    this.count,
    required this.route,
  });
}

class UserProfile extends StatefulWidget {
  static const Color brandColor = Color(0xFFEF7C08);

  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final ProfileService _userService = ProfileService();

  bool _isLoading = true;
  String? _fullName;
  String? _email;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final userId = await UserSession.getUserId();
      final user = await _userService.getUserInfo(userId!);

      final name = user['name'];

      setState(() {
        _fullName =
            '${name['firstname']} ${name['middlename'] ?? ""} ${name['lastname']}';
        _email = user['email'];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load profile';
        _isLoading = false;
      });
    }
  }

  List<MenuItem> get menuItems => [
    MenuItem(
      icon: Icons.book_outlined,
      label: "My Courses",
      route: "/my-courses",
    ),
    MenuItem(
      icon: Icons.settings_outlined,
      label: "Settings",
      route: "/settings",
    ),
    MenuItem(icon: Icons.help_outline, label: "Help & Support", route: "/help"),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: UserProfile.brandColor.withOpacity(0.15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= PROFILE HEADER =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: UserProfile.brandColor.withOpacity(0.4),
                        width: 4,
                      ),
                      color: UserProfile.brandColor,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // -------- USER INFO --------
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: CircularProgressIndicator(),
                    )
                  else if (_error != null)
                    Text(
                      _error!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.red,
                      ),
                    )
                  else
                    Column(
                      children: [
                        Text(
                          _fullName ?? '',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _email ?? '',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 24),
                ],
              ),
            ),

            // ================= MENU ITEMS =================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ...menuItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildMenuItem(context, item),
                    ),
                  ),
                  _buildLogoutItem(context),
                ],
              ),
            ),

            // ================= VERSION =================
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Text(
                'Learner Space v1.0.0',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItem item) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: UserProfile.brandColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, item.route),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: UserProfile.brandColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 20, color: UserProfile.brandColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  item.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: UserProfile.brandColor.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutItem(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: UserProfile.brandColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to logout?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await authProvider.logout(context);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(color: UserProfile.brandColor),
                  ),
                ),
              ],
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: UserProfile.brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.logout,
                  size: 20,
                  color: UserProfile.brandColor,
                ),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: UserProfile.brandColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: UserProfile.brandColor.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
