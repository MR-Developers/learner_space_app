import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(debugShowCheckedModeBanner: false, home: UserHome()),
  );
}

class UserHome extends StatelessWidget {
  const UserHome({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {
        "title": "Character Animation",
        "lessons": "23 Lessons",
        "price": "₹10,000",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
      },
      {
        "title": "3D Design Basic",
        "lessons": "16 Lessons",
        "price": "₹9,999",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg",
      },
      {
        "title": "Digital Illustration",
        "lessons": "18 Lessons",
        "price": "₹8,499",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/4491461/pexels-photo-4491461.jpeg",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNavBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          // ✅ Prevent overflow by adding bottom padding dynamically
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 10,
            bottom: MediaQuery.of(context).padding.bottom + 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildSearchBar(),
              const SizedBox(height: 20),
              _buildUiClassCard(),
              const SizedBox(height: 25),
              _buildSectionHeader("Featured Courses"),
              const SizedBox(height: 12),
              _buildCourseFilters(),
              const SizedBox(height: 20),
              _buildCourseList(courses),
              const SizedBox(height: 30),
              _buildSectionHeader("3D Design"),
              const SizedBox(height: 12),
              _buildCourseList(courses),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // -------------------- Header --------------------
  Widget _buildHeader() {
    return Row(
      children: [
        const CircleAvatar(
          radius: 28,
          backgroundImage: NetworkImage(
            "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back,",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              ),
              const Text(
                "Dheeraj Reddy",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none, color: Colors.orange, size: 28),
      ],
    );
  }

  // -------------------- Search Bar --------------------
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search For Courses",
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.black54),
        ),
      ),
    );
  }

  // -------------------- UI Class Card --------------------
  Widget _buildUiClassCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF8E2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "UI Class",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Starting soon",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/614810/pexels-photo-614810.jpeg",
                      ),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg",
                      ),
                    ),
                    const SizedBox(width: 4),
                    const CircleAvatar(
                      radius: 14,
                      backgroundImage: NetworkImage(
                        "https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "12+",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Check Now"),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Image.network(
              "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  // -------------------- Section Header --------------------
  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const Text(
          "View all",
          style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  // -------------------- Course Filter Buttons --------------------
  Widget _buildCourseFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _filterButton("All Courses", Icons.menu_book, Colors.purple),
        _filterButton("Popular", Icons.local_fire_department, Colors.orange),
        _filterButton("Newest", Icons.add_box_outlined, Colors.green),
      ],
    );
  }

  Widget _filterButton(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // -------------------- Course List --------------------
  Widget _buildCourseList(List<Map<String, dynamic>> courses) {
    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return Container(
            width: 190,
            margin: const EdgeInsets.only(right: 16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        course["image"],
                        height: 100,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      course["title"],
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      course["lessons"],
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "By Upgrad",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              course["rating"].toString(),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        Text(
                          course["price"],
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // -------------------- Bottom Navigation Bar --------------------
  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          _BottomNavItem(icon: Icons.home, label: "Home", active: true),
          _BottomNavItem(icon: Icons.play_circle, label: ""),
          _BottomNavItem(icon: Icons.ac_unit_outlined, label: ""),
          _BottomNavItem(icon: Icons.person_outline, label: ""),
        ],
      ),
    );
  }
}

// -------------------- Bottom Nav Item --------------------
class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? Colors.orange : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: active ? Colors.white : Colors.grey.shade600,
            size: 24,
          ),
        ),
        if (label.isNotEmpty)
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: active ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
      ],
    );
  }
}
