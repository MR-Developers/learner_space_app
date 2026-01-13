import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FaqPage extends StatelessWidget {
  FaqPage({super.key});

  static const Color brandColor = Color(0xFFEF7C08);

  final List<Map<String, String>> faqs = [
    {
      "q": "What is Learner Space?",
      "a":
          "Learner Space is a platform that helps learners discover verified courses, real learner outcomes, and career opportunities.",
    },
    {
      "q": "Who can use Learner Space?",
      "a":
          "Learner Space is designed for students, working professionals, career switchers, and anyone looking to upskill.",
    },
    {
      "q": "Are the courses verified?",
      "a":
          "Yes. All courses listed on Learner Space go through a verification process to ensure quality and authenticity.",
    },
    {
      "q": "What are verified outcomes?",
      "a":
          "Verified outcomes are real learner success stories such as placements, internships, or achievements that are reviewed and approved by our team.",
    },
    {
      "q": "Do all courses provide placement assistance?",
      "a":
          "No. Only selected courses offer placement assistance. You can use filters to find courses that include placement support.",
    },
    {
      "q": "How do referrals work?",
      "a":
          "Premium users can access referral opportunities from the Learner Space community based on skills, performance, and eligibility.",
    },
    {
      "q": "Is Learner Space free to use?",
      "a":
          "Yes, browsing courses and content is free. Some premium features or courses may require enrollment or payment.",
    },
    {
      "q": "How do I enroll in a course?",
      "a":
          "Open a course, review the details, and click on the enroll button. You will be redirected to the official course provider.",
    },
    {
      "q": "Can I contact the course provider directly?",
      "a":
          "Yes. Most course pages include links or contact options provided by the course provider.",
    },
    {
      "q": "How do I contact Learner Space support?",
      "a":
          "Go to Help & Support in Settings and choose email or chat support to reach our team.",
    },
    {
      "q": "Is my personal data safe?",
      "a":
          "Yes. We take data privacy seriously and follow industry-standard security practices to protect your information.",
    },
    {
      "q": "How can I report an issue or give feedback?",
      "a":
          "You can submit feedback or report issues from the Help & Support section in the app.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? colors.surface : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? colors.surface : Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: brandColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "FAQs",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: brandColor.withOpacity(0.15)),
        ),
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [for (final faq in faqs) _faqTile(faq["q"]!, faq["a"]!)],
        ),
      ),
    );
  }

  Widget _faqTile(String question, String answer) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: brandColor.withOpacity(0.2)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        iconColor: brandColor,
        collapsedIconColor: brandColor,
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: brandColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(
            LucideIcons.helpCircle,
            color: brandColor,
            size: 20,
          ),
        ),
        title: Text(
          question,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        children: [
          Text(
            answer,
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.black.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
