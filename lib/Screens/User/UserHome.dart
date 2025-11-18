import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final TextEditingController _searchController = TextEditingController();

  String selectedCategory = "All";

  final List<Map<String, dynamic>> categories = [
    {"name": "All", "count": 1234},
    {"name": "Tech", "count": 456},
    {"name": "Business", "count": 234},
    {"name": "Design", "count": 178},
    {"name": "Marketing", "count": 145},
  ];

  final List<Map<String, dynamic>> featuredCourses = [
    {
      "id": "1",
      "title": "Full Stack Web Development Bootcamp",
      "startup": "CodeMaster Academy",
      "rating": 4.8,
      "reviews": 2456,
      "students": 12400,
      "salary": "₹8–12 LPA",
      "duration": "6 months",
      "verified": true,
    },
    {
      "id": "2",
      "title": "Product Management Masterclass",
      "startup": "PMSchool",
      "rating": 4.9,
      "reviews": 1823,
      "students": 8900,
      "salary": "₹12–18 LPA",
      "duration": "4 months",
      "verified": true,
    },
    {
      "id": "3",
      "title": "UI/UX Design Pro",
      "startup": "DesignHub",
      "rating": 4.7,
      "reviews": 1567,
      "students": 7200,
      "salary": "₹6–10 LPA",
      "duration": "5 months",
      "verified": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildPremiumReferralBanner(),
            const SizedBox(height: 20),
            _buildStatsCard(),
            const SizedBox(height: 20),
            _buildQuickCards(),
            const SizedBox(height: 20),
            _buildCategoryChips(),
            const SizedBox(height: 20),
            _buildFeaturedCourses(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ---------------- UI BLOCKS ---------------- //

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Learner Space",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                "Find your perfect course",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
          Row(
            children: [
              _headerIcon(LucideIcons.bell),
              const SizedBox(width: 6),
              _headerIcon(LucideIcons.user),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Icon(icon, size: 22),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search courses, skills, careers...",
              filled: true,
              fillColor: Colors.white,
              prefixIcon: const Icon(LucideIcons.search),
              contentPadding: const EdgeInsets.symmetric(vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),

          Positioned(
            right: 6,
            top: 6,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(LucideIcons.filter),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumReferralBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.orange.shade50],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                LucideIcons.crown,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Premium Referral Network",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  Text(
                    "Get job referrals from our community • Enroll to unlock",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: categories.map((c) {
          final bool active = c['name'] == selectedCategory;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text("${c['name']} (${c['count']})"),
              selected: active,
              selectedColor: Colors.orange,
              backgroundColor: Colors.white,
              showCheckmark: false,
              labelStyle: TextStyle(
                color: active ? Colors.white : Colors.black,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.grey.shade300),
              ),
              onSelected: (_) {
                setState(() => selectedCategory = c['name']);
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade700, Colors.orange.shade500],
          ),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "This Week's Highlight",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
                SizedBox(height: 4),
                Text(
                  "92% Success Rate",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "from verified learners",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            Icon(
              LucideIcons.trendingUp,
              size: 60,
              color: Colors.white.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(child: _quickCard("Reviews", LucideIcons.star)),
          const SizedBox(width: 12),
          Expanded(child: _quickCard("Outcomes", LucideIcons.trendingUp)),
        ],
      ),
    );
  }

  Widget _quickCard(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 30, color: Colors.orange),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(
            title == "Reviews" ? "100% verified" : "Real placements",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedCourses() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Featured Courses",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text("View All", style: TextStyle(color: Colors.orange.shade700)),
            ],
          ),
          const SizedBox(height: 12),

          // Course cards
          Column(
            children: featuredCourses.map((course) {
              return _courseCard(course);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _courseCard(Map<String, dynamic> course) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/courseDetails", arguments: course["id"]);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(LucideIcons.bookOpen, size: 36),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title + verified
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          course["title"],
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      if (course["verified"])
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            "Verified",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),
                  Text(
                    course["startup"],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 2),
                          Text(
                            "${course["rating"]}",
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            " (${course["reviews"]})",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          const Icon(LucideIcons.users, size: 14),
                          const SizedBox(width: 3),
                          Text("${course["students"]}"),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          course["duration"],
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        course["salary"],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange.shade700,
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
  }
}
