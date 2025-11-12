import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  // Example of dynamic state (you can modify these later)
  String userName = "Dheeraj Reddy";
  String userEmail = "xxxxxxxxxx@gmail.com";
  String userImage =
      'https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF57C00),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            const SizedBox(height: 20),
            _buildProfileSection(),
            const SizedBox(height: 30),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [const SizedBox(height: 20), _buildMenuList()],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- App Bar --------------------
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- Profile Section --------------------
  Widget _buildProfileSection() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  userImage,
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              bottom: 5,
              right: 5,
              child: InkWell(
                onTap: () {
                  // Example: Open image picker in future
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Change profile picture clicked!"),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF57C00),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.edit, color: Colors.white, size: 18),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          userEmail,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ],
    );
  }

  // -------------------- Menu List --------------------
  Widget _buildMenuList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.edit_outlined,
            iconColor: const Color(0xFFF57C00),
            title: "Edit Profile",
            onTap: () {
              // Example: edit profile logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit Profile clicked")),
              );
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            iconColor: const Color(0xFFF57C00),
            title: "Settings",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.favorite_border,
            iconColor: const Color(0xFFF57C00),
            title: "Favorites",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.link,
            iconColor: const Color(0xFFF57C00),
            title: "Linked Accounts",
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.info_outline,
            iconColor: const Color(0xFFF57C00),
            title: "About Us",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // -------------------- Menu Item --------------------
  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Color(0xFFF57C00), size: 28),
          ],
        ),
      ),
    );
  }
}
