import 'package:flutter/material.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final PageController _bannerController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _autoScrollBanner();
  }

  void _autoScrollBanner() {
    Future.delayed(const Duration(seconds: 3), () {
      if (!_bannerController.hasClients) return;

      _currentPage++;
      if (_currentPage > 2) _currentPage = 0;

      _bannerController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );

      _autoScrollBanner(); // repeat
    });
  }

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  Widget _buildAutoBanner() {
    final List<String> bannerImages = [
      "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
      "https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg",
      "https://images.pexels.com/photos/4491461/pexels-photo-4491461.jpeg",
    ];

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: bannerImages.length,
            controller: _bannerController,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  image: DecorationImage(
                    image: NetworkImage(bannerImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // 🔥 Page indicators (dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(bannerImages.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 12 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? Colors.orange
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20),
              ),
            );
          }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> courses = [
      {
        "title": "Full Stack Web Development",
        "lessons": "6 Lessons",
        "price": "₹90,000",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/414612/pexels-photo-414612.jpeg",
        "institution": "CodeMaster Academy", // 👈 NEW
      },
      {
        "title": "3D Design Basic",
        "lessons": "16 Lessons",
        "price": "₹9,999",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/3184339/pexels-photo-3184339.jpeg",
        "institution": "Pixel School of Design", // 👈 NEW
      },
      {
        "title": "Digital Illustration",
        "lessons": "18 Lessons",
        "price": "₹8,499",
        "rating": 4.5,
        "image":
            "https://images.pexels.com/photos/4491461/pexels-photo-4491461.jpeg",
        "institution": "Creative Arts Hub", // 👈 NEW
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildAutoBanner(),
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
    );
  }

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
                "Budda Manikanta Saaketh",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        const Icon(Icons.notifications_none, color: Colors.orange, size: 28),
      ],
    );
  }

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

  Widget _buildCourseFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterButton("All Courses", Icons.menu_book, Colors.purple),
          const SizedBox(width: 10),

          _filterButton("Web Development", Icons.web, Colors.blue),
          const SizedBox(width: 10),

          _filterButton("App Development", Icons.phone_android, Colors.teal),
          const SizedBox(width: 10),

          _filterButton("Digital Marketing", Icons.campaign, Colors.red),
        ],
      ),
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
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  "/courseDetails",
                  arguments: "987",
                );
              },
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      Text(
                        course["lessons"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course["institution"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
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
            ),
          );
        },
      ),
    );
  }
}
