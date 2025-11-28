import 'package:flutter/material.dart';
import 'package:learner_space_app/State/auth_provider.dart';
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

class UserProfile extends StatelessWidget {
  static const Color brandColor = Color(0xFFEF7C08);

  const UserProfile({super.key});

  List<MenuItem> get menuItems => [
    MenuItem(
      icon: Icons.book_outlined,
      label: "My Courses",
      count: 3,
      route: "/my-courses",
    ),
    MenuItem(
      icon: Icons.bookmark_outline,
      label: "Saved Courses",
      count: 12,
      route: "/saved",
    ),
    MenuItem(
      icon: Icons.shield_outlined,
      label: "Submit Outcome",
      route: "/submit-outcome",
    ),
    MenuItem(
      icon: Icons.notifications_outlined,
      label: "Notifications",
      route: "/notifications",
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: brandColor),
          style: IconButton.styleFrom(shape: const CircleBorder()),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            height: 1,
            thickness: 1,
            color: brandColor.withOpacity(0.15),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
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
                        color: brandColor.withOpacity(0.4),
                        width: 4,
                      ),
                      color: brandColor,
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Budda Manikanta Saaketh',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'BuddaManikantaSaaketh@gmial.com',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),

            // Menu Items
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
                  // Logout
                  _buildLogoutItem(context),
                ],
              ),
            ),

            // Version Info
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
        side: BorderSide(color: brandColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, size: 20, color: brandColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (item.count != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        '${item.count} items',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: brandColor.withOpacity(0.8),
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
        side: BorderSide(color: brandColor.withOpacity(0.2)),
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
                  child: Text('Logout', style: TextStyle(color: brandColor)),
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
                  color: brandColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.logout, size: 20, color: brandColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Logout',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: brandColor,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: brandColor.withOpacity(0.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
