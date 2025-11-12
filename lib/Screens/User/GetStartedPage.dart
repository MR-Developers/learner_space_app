import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class GetStartedPage extends StatefulWidget {
  const GetStartedPage({super.key});

  @override
  State<GetStartedPage> createState() => _GetStartedPageState();
}

class _GetStartedPageState extends State<GetStartedPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != currentPage) {
        setState(() => currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- PageView for 3 steps ---
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  OnboardingStep(
                    titlePart1: "Learner ",
                    titlePart2: "Space",
                    imagePath: "assets/User/Step_1.png",
                    midTitle: [
                      TextSpan(
                        text: "Welcome To ",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const TextSpan(
                        text: "Discover Verified Courses",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                    subtitle:
                        "Browse 1000+ courses from trusted EdTech startups with transparent outcomes",
                  ),
                  OnboardingStep(
                    titlePart1: "Learner ",
                    titlePart2: "Space",
                    imagePath: "assets/User/Step_2.png",
                    midTitle: [
                      TextSpan(
                        text: "Real Reviews",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const TextSpan(
                        text: ", Real Results",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                    subtitle:
                        "Read authentic reviews from verified learners who've completed the programs",
                  ),
                  OnboardingStep(
                    titlePart1: "Learner ",
                    titlePart2: "Space",
                    imagePath: "assets/User/Step_3.png",
                    midTitle: [
                      TextSpan(
                        text: "Track Your",
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      const TextSpan(
                        text: " Success",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    ],
                    subtitle:
                        "See real placement data, salary outcomes, and career transitions",
                  ),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.orange.shade600,
                dotColor: Colors.grey.shade400,
                dotHeight: 10,
                dotWidth: 10,
                spacing: 8,
              ),
            ),

            // --- Button ---
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0, top: 30),
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  currentPage == 2 ? "Get Started" : "Next",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingStep extends StatelessWidget {
  final String titlePart1;
  final String titlePart2;
  final String imagePath;
  final List<TextSpan> midTitle;
  final String subtitle;

  const OnboardingStep({
    super.key,
    required this.titlePart1,
    required this.titlePart2,
    required this.imagePath,
    required this.midTitle,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Main title
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 26,
                ),
                children: [
                  TextSpan(
                    text: titlePart1,
                    style: TextStyle(color: Colors.orange.shade600),
                  ),
                  TextSpan(
                    text: titlePart2,
                    style: const TextStyle(color: Colors.black),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),

            // Image
            Padding(
              padding: const EdgeInsets.only(top: 80.0, bottom: 30),
              child: Image.asset(imagePath, height: 250),
            ),

            Text.rich(
              TextSpan(children: midTitle),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
