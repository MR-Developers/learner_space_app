import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ReferralsPage extends StatelessWidget {
  static const Color brandColor = Color(0xFFEF7C08);

  const ReferralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // HEADER
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  brandColor.withOpacity(0.12),
                  brandColor.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border(
                bottom: BorderSide(
                  color: theme.colorScheme.outline.withOpacity(0.2),
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      style: IconButton.styleFrom(shape: const CircleBorder()),
                      icon: const Icon(Icons.arrow_back),
                    ),

                    const SizedBox(height: 8),

                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: brandColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            LucideIcons.crown,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Premium Referral Network",
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Unlock exclusive job opportunities",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(
                                  0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                children: [
                  // 🔒 LOCKED BANNER
                  _buildLockedBanner(context),

                  const SizedBox(height: 24),

                  // BENEFITS
                  _buildBenefitsSection(context),

                  const SizedBox(height: 24),

                  // HOW IT WORKS
                  _buildHowItWorks(),

                  const SizedBox(height: 24),

                  // SUCCESS STATS
                  _buildStatsCard(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // 🔒 LOCKED BANNER
  // ------------------------------
  Widget _buildLockedBanner(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: brandColor, width: 2),
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [brandColor.withOpacity(0.1), Colors.transparent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        color: theme.colorScheme.surface,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(LucideIcons.lock, color: brandColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Premium Feature",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Get access to exclusive job referrals from our community. Enroll in any verified course to unlock this feature.",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: brandColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: () {},
              child: const Text("Browse Courses to Unlock"),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------
  // ⭐ BENEFITS
  // ------------------------------
  Widget _buildBenefitsSection(BuildContext context) {
    final theme = Theme.of(context);

    final benefits = [
      {
        "icon": LucideIcons.users,
        "color": Colors.green,
        "title": "Community Referrals",
        "desc": "Get referred by alumni working at top companies",
      },
      {
        "icon": LucideIcons.trendingUp,
        "color": brandColor,
        "title": "Priority Access",
        "desc": "Get early access to job openings and referrals",
      },
      {
        "icon": LucideIcons.gift,
        "color": brandColor,
        "title": "Exclusive Network",
        "desc": "Connect with 10,000+ verified learners & professionals",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What You'll Get",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),

        ...benefits.map(
          (b) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.2),
              ),
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: (b["color"] as Color).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    b["icon"] as IconData,
                    color: b["color"] as Color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b["title"].toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        b["desc"].toString(),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------
  // ⚙ HOW IT WORKS
  // ------------------------------
  Widget _buildHowItWorks() {
    final steps = [
      {
        "step": "1",
        "title": "Enroll in a Course",
        "desc": "Choose any verified course",
      },
      {
        "step": "2",
        "title": "Complete & Excel",
        "desc": "Build projects & showcase your skills",
      },
      {
        "step": "3",
        "title": "Access Referral Network",
        "desc": "Get referred by alumni",
      },
      {
        "step": "4",
        "title": "Land Your Dream Job",
        "desc": "Better opportunities via referrals",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "How It Works",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...steps.map(
          (item) => Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: brandColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      item["step"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item["desc"]!,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------
  // 📊 SUCCESS STATS
  // ------------------------------
  Widget _buildStatsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Text(
            "Success Stories",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStat("2,400+", "Successful Referrals"),
              _buildStat("₹12L", "Avg Package"),
              _buildStat("150+", "Top Companies"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: brandColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.black.withOpacity(0.6)),
        ),
      ],
    );
  }
}
