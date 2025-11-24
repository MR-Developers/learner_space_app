import 'package:flutter/material.dart';

class UserOutcomes extends StatefulWidget {
  const UserOutcomes({super.key});

  static const Color primary = Color(0xFFEF7C08);

  @override
  State<UserOutcomes> createState() => _UserOutcomesState();
}

class _UserOutcomesState extends State<UserOutcomes> {
  // Sample data (mirrors your React example)
  final List<Map<String, dynamic>> salaryData = const [
    {"month": "Pre-Course", "salary": 4},
    {"month": "Month 1", "salary": 4},
    {"month": "Month 3", "salary": 6},
    {"month": "Month 6", "salary": 9},
    {"month": "Post", "salary": 12},
  ];

  final List<Map<String, dynamic>> offerLetters = const [
    {
      "id": 1,
      "name": "Priya Sharma",
      "company": "Google",
      "role": "Software Engineer",
      "salary": "₹18 LPA",
      "verified": true,
    },
    {
      "id": 2,
      "name": "Arjun Mehta",
      "company": "Amazon",
      "role": "Product Manager",
      "salary": "₹22 LPA",
      "verified": true,
    },
    {
      "id": 3,
      "name": "Neha Gupta",
      "company": "Microsoft",
      "role": "UX Designer",
      "salary": "₹16 LPA",
      "verified": true,
    },
    {
      "id": 4,
      "name": "Rahul Singh",
      "company": "Flipkart",
      "role": "Data Scientist",
      "salary": "₹20 LPA",
      "verified": true,
    },
  ];

  final List<String> companies = const [
    "Google",
    "Amazon",
    "Microsoft",
    "Flipkart",
    "Swiggy",
    "Zomato",
    "PhonePe",
    "Razorpay",
  ];

  final List<Map<String, dynamic>> alumniStories = const [
    {
      "id": 1,
      "name": "Priya Sharma",
      "role": "Software Engineer at Google",
      "story":
          "Switched from non-tech to tech career. The bootcamp gave me hands-on experience and confidence to crack FAANG interviews.",
      "beforeSalary": "₹3.5 LPA",
      "afterSalary": "₹18 LPA",
      "growth": "414%",
    },
    {
      "id": 2,
      "name": "Arjun Mehta",
      "role": "Product Manager at Amazon",
      "story":
          "Transitioned from engineering to product management. The curriculum was exactly what I needed to make the switch.",
      "beforeSalary": "₹8 LPA",
      "afterSalary": "₹22 LPA",
      "growth": "175%",
    },
    {
      "id": 3,
      "name": "Neha Gupta",
      "role": "UX Designer at Microsoft",
      "story":
          "From graphic design to product design. Learned industry-standard tools and got my dream job in 4 months!",
      "beforeSalary": "₹4 LPA",
      "afterSalary": "₹16 LPA",
      "growth": "300%",
    },
  ];

  double _maxSalary() {
    double max = 0;
    for (var d in salaryData) {
      if ((d['salary'] as num).toDouble() > max)
        max = (d['salary'] as num).toDouble();
    }
    return max;
  }

  @override
  Widget build(BuildContext context) {
    final double maxSalary = _maxSalary();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _salaryCard(maxSalary),
                    const SizedBox(height: 16),
                    _offerLettersSection(),
                    const SizedBox(height: 16),
                    _companiesCard(),
                    const SizedBox(height: 16),
                    _alumniStoriesSection(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Header ----------------
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.maybePop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            color: Colors.black87,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Placement Outcomes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2),
                Text(
                  "Verified success stories",
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Salary Card ----------------
  Widget _salaryCard(double maxSalary) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 20,
                  color: UserOutcomes.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  "Average Salary Growth",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...salaryData.map((data) {
              final widthFactor =
                  (data['salary'] as num).toDouble() /
                  (maxSalary == 0 ? 1 : maxSalary);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          data['month'] as String,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          "₹${data['salary']} LPA",
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FractionallySizedBox(
                          widthFactor: widthFactor.clamp(0.0, 1.0),
                          child: Container(
                            height: 10,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  UserOutcomes.primary,
                                  Color(0xFFDE7A08),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: UserOutcomes.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Average Growth",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  _GrowthChip(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Offer Letters ----------------
  Widget _offerLettersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Verified Offer Letters",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: offerLetters.map((offer) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              margin: const EdgeInsets.only(bottom: 10),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.insert_drive_file,
                        size: 24,
                        color: UserOutcomes.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                offer['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (offer['verified'] == true)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Text(
                                    "Verified",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            offer['role'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.apartment,
                                    size: 16,
                                    color: Colors.black54,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    offer['company'] as String,
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              Text(
                                offer['salary'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: UserOutcomes.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ---------------- Companies ----------------
  Widget _companiesCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.business, color: UserOutcomes.primary),
                SizedBox(width: 8),
                Text(
                  "Top Hiring Companies",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 3.8,
              children: companies.map((c) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    c,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- Alumni Stories ----------------
  Widget _alumniStoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            "Success Stories",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
        const SizedBox(height: 8),
        Column(
          children: alumniStories.map((story) {
            return Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 28,
                            color: UserOutcomes.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                story['name'] as String,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                story['role'] as String,
                                style: const TextStyle(
                                  color: UserOutcomes.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      story['story'] as String,
                      style: const TextStyle(
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Before",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  story['beforeSalary'] as String,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: UserOutcomes.primary.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: UserOutcomes.primary.withOpacity(0.14),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "After",
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.black54,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Text(
                                      story['afterSalary'] as String,
                                      style: const TextStyle(
                                        color: UserOutcomes.primary,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: UserOutcomes.primary,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        "+${story['growth']}",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// Small helper widget for growth chip
class _GrowthChip extends StatelessWidget {
  const _GrowthChip({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.trending_up, size: 18, color: UserOutcomes.primary),
        SizedBox(width: 8),
        Text(
          "200%",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: UserOutcomes.primary,
          ),
        ),
      ],
    );
  }
}
