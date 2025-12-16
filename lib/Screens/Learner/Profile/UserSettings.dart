import 'package:flutter/material.dart';
import 'package:learner_space_app/State/auth_provider.dart';
import 'package:learner_space_app/State/theme_provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color brandColor = Color(0xFFEF7C08);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: brandColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: brandColor.withOpacity(0.15)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionTitle("Account"),
          SettingsTile(icon: LucideIcons.user, title: "Profile", onTap: () {}),
          SettingsTile(
            icon: LucideIcons.lock,
            title: "Privacy & Security",
            onTap: () {},
          ),

          const SizedBox(height: 24),
          _sectionTitle("Preferences"),

          SettingsTile(
            icon: LucideIcons.bell,
            title: "Notifications",
            onTap: () {},
          ),
          SettingsTile(
            icon: LucideIcons.sliders,
            title: "App Preferences",
            onTap: () {
              Navigator.pushNamed(context, "/settings/preferences");
            },
          ),

          const SizedBox(height: 24),
          _sectionTitle("Support"),
          SettingsTile(
            icon: LucideIcons.info,
            title: "About Learner Space",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Learner Space",
                applicationVersion: "1.0.0",
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: brandColor.withOpacity(0.7),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  static const Color brandColor = Color(0xFFEF7C08);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: brandColor.withOpacity(0.2)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: brandColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
