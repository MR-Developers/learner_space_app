import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learner_space_app/Apis/Services/course_service.dart';
import 'package:learner_space_app/Apis/Services/lead_service.dart';
import 'package:learner_space_app/Apis/Services/outcome_service.dart';
import 'package:learner_space_app/Apis/Services/review_service.dart';
import 'package:learner_space_app/Data/Models/OutcomesModel.dart';
import 'package:learner_space_app/Data/Models/ReviewModel.dart';
import 'package:learner_space_app/Utils/Formatters.dart';
import 'package:http/http.dart' as http;
import 'package:learner_space_app/Utils/UserSession.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';

class CourseDetailPage extends StatefulWidget {
  final String id;

  const CourseDetailPage({super.key, required this.id});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage> {
  final CourseService _courseService = CourseService();
  final OutcomeService _outcomeService = OutcomeService();
  final ReviewService _reviewService = ReviewService();
  final LeadService _leadService = LeadService();
  bool _enrolling = false;

  List<ReviewModel> courseReviews = [];
  bool reviewsLoading = false;

  List<OutcomeModel> courseOutcomes = [];

  bool outcomesLoading = false;

  Map<String, dynamic>? course;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _handleEnroll(Map<String, dynamic> course) async {
    if (_enrolling) return;

    setState(() => _enrolling = true);

    try {
      final String? userId = await UserSession.getUserId();
      if (userId == null) {
        throw Exception("User not logged in");
      }

      final String? courseUrl = course['raw']?['courseUrl'];
      if (courseUrl == null || courseUrl.isEmpty) {
        throw Exception("Course URL not available");
      }

      // 1️⃣ CREATE LEAD
      await _leadService.createLead({
        "clientId": userId,
        "courseId": course['id'],
        "companyId": course['raw']?['companyId'],
      });

      // 2️⃣ OPEN COURSE URL (EXTERNAL)
      final Uri uri = Uri.parse(courseUrl);

      if (!await canLaunchUrl(uri)) {
        throw Exception("Could not open course link");
      }

      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _enrolling = false);
    }
  }

  Future<void> _loadReviews() async {
    try {
      setState(() => reviewsLoading = true);

      final res = await _reviewService.getReviewsByCourse(widget.id);

      if (res['success'] == true && res['data'] is List) {
        courseReviews = (res['data'] as List)
            .map((e) => ReviewModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to load reviews: $e');
    } finally {
      if (mounted) {
        setState(() => reviewsLoading = false);
      }
    }
  }

  Future<void> _loadOutcomes() async {
    try {
      setState(() => outcomesLoading = true);

      final res = await _outcomeService.getOutcomesByCourse(widget.id);

      if (res['success'] == true && res['data'] is List) {
        courseOutcomes = (res['data'] as List)
            .map((e) => OutcomeModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint('Failed to load outcomes: $e');
    } finally {
      if (mounted) {
        setState(() => outcomesLoading = false);
      }
    }
  }

  Future<void> _loadCourse() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final res = await _courseService.getCourseById(widget.id);

      Map<String, dynamic>? extractRaw(dynamic resp) {
        if (resp == null) return null;

        if (resp is Map &&
            resp.containsKey('success') &&
            resp['success'] == true &&
            resp.containsKey('data')) {
          final d = resp['data'];
          if (d is Map<String, dynamic>) return Map<String, dynamic>.from(d);
          if (d is List && d.isNotEmpty && d.first is Map)
            return Map<String, dynamic>.from(d.first as Map);
          return null;
        }

        if (resp is Map<String, dynamic>) {
          return Map<String, dynamic>.from(resp);
        }

        if (resp is Map) {
          return Map<String, dynamic>.from(resp.cast<String, dynamic>());
        }

        if (resp is List && resp.isNotEmpty) {
          final first = resp.first;
          if (first is Map<String, dynamic>)
            return Map<String, dynamic>.from(first);
          if (first is Map)
            return Map<String, dynamic>.from(first.cast<String, dynamic>());
        }

        return null;
      }

      final raw = extractRaw(res);

      if (raw == null) {
        throw Exception('Unexpected API response shape. See logs for details.');
      }

      final fetched = normalizeCourse(raw);

      if (!mounted) return;
      setState(() {
        course = fetched;
        isLoading = false;
      });
      await _loadOutcomes();
      await _loadReviews();
    } catch (e, st) {
      print('Error in _loadCourse: $e\n$st');

      if (!mounted) return;
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> normalizeCourse(Map<String, dynamic> raw) {
    String? pickImage(dynamic images) {
      if (images == null) return null;
      if (images is String) return images;
      if (images is List && images.isNotEmpty) return images.first.toString();
      if (images is Map && images.containsKey('url'))
        return images['url'].toString();
      return null;
    }

    Map<String, dynamic> buildOutcomes(dynamic rawOut) {
      if (rawOut is Map<String, dynamic>) return rawOut;
      if (rawOut is List && rawOut.isNotEmpty && rawOut.first is Map)
        return Map<String, dynamic>.from(rawOut.first);
      return {};
    }

    String normalizeId(dynamic idField, Map rawMap) {
      if (idField == null) {
        final candidate = rawMap['_id'] ?? rawMap['id'];
        return candidate?.toString() ?? '';
      }
      return idField.toString();
    }

    final id = normalizeId(raw['_id'], raw);
    final title = raw['courseName'] ?? raw['title'] ?? raw['name'] ?? '';
    final startup =
        raw['companyName'] ?? raw['startup'] ?? raw['company'] ?? '';
    final priceFormatted = formatPrice(
      raw['price'] ?? raw['coursePrice'] ?? raw['fee'],
    );
    final durationText = durationToString(
      raw['duration'] ?? raw['courseDuration'],
    );
    final curriculum = (raw['pdf'] is List)
        ? List<dynamic>.from(raw['pdf'])
        : <dynamic>[];
    final outcomes = buildOutcomes(raw['outcomes'] ?? raw['placement'] ?? {});
    final image = pickImage(
      raw['courseImage'] ?? raw['images'] ?? raw['image'],
    );

    // Build final shape expected by UI
    return {
      'id': id,
      'title': title,
      'startup': startup,
      'rating': raw['rating'] ?? raw['avgRating'] ?? 0,
      'reviews': raw['reviews'] ?? raw['noOfReviews'] ?? 0,
      'students': raw['noOfLeads'] ?? raw['enrolledCount'] ?? 0,
      'salary': raw['salary'] ?? raw['salaryRange'] ?? '-',
      'duration': durationText,
      'description': raw['description'] ?? raw['shortDescription'] ?? '',
      'verified': raw['verified'] ?? false,
      'price': priceFormatted,
      'outcomes': {
        'placed': outcomes['placed'] ?? outcomes['placedPercent'] ?? 0,
        'avgSalary':
            outcomes['avgSalary'] ??
            outcomes['avgSalaryPackage'] ??
            raw['avgSalary'] ??
            '-',
        'companies': (outcomes['companies'] is List)
            ? List<dynamic>.from(outcomes['companies'])
            : (outcomes['hiringCompanies'] is List
                  ? List<dynamic>.from(outcomes['hiringCompanies'])
                  : []),
      },
      'curriculum': curriculum,
      'nextBatch': raw['nextBatch'] ?? raw['next_batch'] ?? '-',
      'raw': raw,
      'image': image,
    };
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back, color: Colors.black87),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Failed to load course',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  error ?? 'Unknown error',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _loadCourse,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B35),
                  ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Ensure course is non-null here
    final Map<String, dynamic> c = course!;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // App Bar
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: IconButton(
                  onPressed: () => Navigator.of(context).maybePop(),
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Share tapped')),
                      );
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      color: Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to favorites')),
                      );
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),

              // Course Header
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: _CourseHeader(course: c),
                ),
              ),

              // Quick Stats
              SliverToBoxAdapter(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: _QuickStats(course: c),
                ),
              ),

              // Tab Bar
              SliverPersistentHeader(
                pinned: true,
                delegate: _StickyTabBarDelegate(
                  TabBar(
                    labelColor: const Color(0xFFFF6B35),
                    unselectedLabelColor: Colors.grey.shade600,
                    indicatorColor: const Color(0xFFFF6B35),
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Curriculum'),
                      Tab(text: 'Outcomes'),
                      Tab(text: 'Reviews'),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              _OverviewTab(course: c),
              _CurriculumTab(pdfs: List<dynamic>.from(c['curriculum'] ?? [])),
              _OutcomesTab(
                outcomes: courseOutcomes,
                loading: outcomesLoading,
                courseId: c['id'],
              ),

              _ReviewsTab(
                rating: c['rating'],
                totalReviews: c['reviews'],
                reviews: courseReviews,
                loading: reviewsLoading,
              ),
            ],
          ),
        ),
        bottomNavigationBar: _BottomCTA(
          price: c['price']?.toString() ?? '-',
          loading: _enrolling,
          onEnroll: () => _handleEnroll(c),
        ),
      ),
    );
  }
}

// Sticky Tab Bar Delegate
class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _StickyTabBarDelegate(this.tabBar);

  @override
  double get minExtent => 48;

  @override
  double get maxExtent => 48;

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return Container(color: Colors.white, child: tabBar);
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return false;
  }
}

/// Course header area: icon, title, startup, rating, students
class _CourseHeader extends StatelessWidget {
  final Map<String, dynamic> course;
  const _CourseHeader({required this.course});

  @override
  Widget build(BuildContext context) {
    final NumberFormat nf = NumberFormat.decimalPattern();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon box
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF6B35).withOpacity(0.2),
                    const Color(0xFFFF6B35).withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Icon(
                  Icons.menu_book,
                  size: 32,
                  color: Color(0xFFFF6B35),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (course['verified'] == true)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 8),
                  Text(
                    course['title'] ?? '-',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    course['startup'] ?? '-',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Rating and students
        Wrap(
          spacing: 16,
          runSpacing: 8,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, size: 18, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  (course['rating'] ?? '-').toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '(${nf.format(course['reviews'] ?? 0)})',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

/// Three quick stats shown in a row
class _QuickStats extends StatelessWidget {
  final Map<String, dynamic> course;
  const _QuickStats({required this.course});

  @override
  Widget build(BuildContext context) {
    Widget statItem(IconData icon, String label, String value) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24, color: const Color(0xFFFF6B35)),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Row(
      children: [
        statItem(Icons.access_time, 'Duration', course['duration'] ?? '-'),
        const SizedBox(width: 8),
        statItem(Icons.group, 'Students', "${course['students']}"),
        const SizedBox(width: 8),
      ],
    );
  }
}

/// Overview tab content
class _OverviewTab extends StatelessWidget {
  final Map<String, dynamic> course;
  const _OverviewTab({required this.course});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About this course',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(height: 12),
          Text(
            course['description'] ?? '-',
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 15,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFF6B35).withOpacity(0.1),
                  const Color(0xFFFF6B35).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF6B35).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    size: 24,
                    color: Color(0xFFFF6B35),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Next Batch',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course['nextBatch'] ?? '-',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Limited seats available',
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 100), // Bottom padding
        ],
      ),
    );
  }
}

/// Curriculum tab: renders PDF directly inside the tab.
/// Expects course['pdf'] (or curriculum) as List<dynamic> of URLs.
class _CurriculumTab extends StatefulWidget {
  final List<dynamic> pdfs;
  const _CurriculumTab({required this.pdfs});

  @override
  State<_CurriculumTab> createState() => _CurriculumTabState();
}

class _CurriculumTabState extends State<_CurriculumTab> {
  PdfControllerPinch? _pdfController;
  Future<PdfDocument>? _docFuture;
  bool _loading = false;
  String? _error;
  int _activeIndex = 0;

  List<String> get _pdfUrls => (widget.pdfs ?? [])
      .where((e) => e != null)
      .map((e) => e.toString())
      .toList();

  @override
  void initState() {
    super.initState();
    if (_pdfUrls.isNotEmpty) _loadPdfAtIndex(0);
  }

  Future<void> _loadPdfAtIndex(int index) async {
    if (index < 0 || index >= _pdfUrls.length) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    final url = _pdfUrls[index];

    try {
      final resp = await http.get(Uri.parse(url));
      if (resp.statusCode != 200) {
        throw Exception('Failed to download PDF (status ${resp.statusCode})');
      }
      final bytes = resp.bodyBytes;

      await _disposePdfResources();

      final docFuture = PdfDocument.openData(bytes);

      // create controller with future document
      final controller = PdfControllerPinch(document: docFuture);

      if (!mounted) {
        // if unmounted, close doc when resolved
        docFuture.then((d) => d.close()).catchError((_) {});
        return;
      }

      setState(() {
        _docFuture = docFuture;
        _pdfController = controller;
        _activeIndex = index;
        _loading = false;
      });
    } catch (e, st) {
      // capture both Dart & platform exceptions
      print('Error loading PDF: $e\n$st');
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _disposePdfResources() async {
    try {
      _pdfController?.dispose();
    } catch (_) {}
    _pdfController = null;

    if (_docFuture != null) {
      try {
        final doc = await _docFuture;
        await doc?.close();
      } catch (_) {}
      _docFuture = null;
    }
  }

  @override
  void dispose() {
    _disposePdfResources();
    super.dispose();
  }

  Widget _buildSelector() {
    final urls = _pdfUrls;
    if (urls.length <= 1) return const SizedBox.shrink();

    return SizedBox(
      height: 52,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, i) {
          final name =
              Uri.tryParse(urls[i])?.pathSegments.last ?? 'PDF ${i + 1}';
          final selected = i == _activeIndex;
          return GestureDetector(
            onTap: () {
              if (i == _activeIndex) return;
              _loadPdfAtIndex(i);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFFF6B35) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 6,
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.picture_as_pdf,
                    size: 18,
                    color: selected ? Colors.white : Colors.redAccent,
                  ),
                  const SizedBox(width: 8),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 140),
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.grey.shade800,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemCount: urls.length,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final urls = _pdfUrls;

    if (urls.isEmpty) {
      // fallback UI when no PDFs are available
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFFF6B35).withOpacity(0.14),
                      const Color(0xFFFF6B35).withOpacity(0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.menu_book_outlined,
                    size: 56,
                    color: Color(0xFFFF6B35),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Curriculum not available",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "The instructor hasn't uploaded a curriculum PDF for this course yet.\nYou can ask for an update or check back later.",
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "We'll notify you when the curriculum is added.",
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.notifications_active_outlined),
                label: const Text("Notify me"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Normal view: selector + PDF viewer
    return Column(
      children: [
        _buildSelector(),
        const Divider(height: 1, thickness: 1),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Failed to load PDF',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _loadPdfAtIndex(_activeIndex),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B35),
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _pdfController == null
              ? const Center(child: Text('No document loaded'))
              : _buildPdfViewSafely(),
        ),
        const SizedBox(height: 8),
        // NOTE: filename/UI removed here as requested
      ],
    );
  }

  // build PdfViewPinch inside try/catch and show helpful platform error UI
  Widget _buildPdfViewSafely() {
    try {
      // Creating the PdfViewPinch can throw a platform exception if plugin/native side not available
      return PdfViewPinch(
        controller: _pdfController!,
        onDocumentLoaded: (doc) {
          // optional
        },
      );
    } catch (e, st) {
      // Log native channel error and show friendly UI
      print('Platform error while creating PdfViewPinch: $e\n$st');
      final errMsg = e.toString();
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 56,
                color: Colors.redAccent,
              ),
              const SizedBox(height: 12),
              const Text(
                'PDF viewer is unavailable on this device',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                errMsg,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => _loadPdfAtIndex(_activeIndex),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }
  }
}

/// Outcomes tab content
class _OutcomesTab extends StatelessWidget {
  final List<OutcomeModel> outcomes;

  final bool loading;
  final String courseId;

  const _OutcomesTab({
    required this.outcomes,
    required this.loading,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // ✅ ADD OUTCOME BUTTON
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  "/userSubmitOutcome",
                  arguments: {"courseId": courseId},
                );
              },
              icon: const Icon(Icons.add_circle_outline),
              label: const Text(
                "Add Your Outcome",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF6B35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),

        const Divider(height: 1),

        // ✅ OUTCOMES LIST / EMPTY STATE
        Expanded(
          child: outcomes.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.insights_outlined,
                          size: 56,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text(
                          "No outcomes available yet",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Be the first to share your placement outcome.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: outcomes.length,
                  itemBuilder: (context, index) {
                    return _OutcomeCard(outcome: outcomes[index]);
                  },
                ),
        ),
      ],
    );
  }
}

class _OutcomeCard extends StatelessWidget {
  final OutcomeModel outcome;

  const _OutcomeCard({required this.outcome});

  @override
  Widget build(BuildContext context) {
    final String userName = outcome.fullUserName;
    final bool verified = outcome.verified;
    final String? profilePic = outcome.userProfilePic;

    final bool hasProfilePic = profilePic != null && profilePic.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 USER HEADER
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: hasProfilePic
                    ? NetworkImage(profilePic)
                    : null,
                child: !hasProfilePic
                    ? Icon(Icons.person, color: Colors.grey.shade600)
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "Placed Student",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              if (verified)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.verified,
                        size: 14,
                        color: Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Verified",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // 🏢 COMPANY
          Row(
            children: [
              const Icon(
                Icons.business_center,
                size: 18,
                color: Color(0xFFFF6B35),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  outcome.companyPlaced,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // 💰 PACKAGE
          Text(
            "Package: ${outcome.package}",
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          const SizedBox(height: 8),

          // 📝 DESCRIPTION
          Text(
            outcome.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// Reviews tab content
class _ReviewsTab extends StatelessWidget {
  final int rating;
  final int totalReviews;
  final List<ReviewModel> reviews;
  final bool loading;

  const _ReviewsTab({
    required this.rating,
    required this.totalReviews,
    required this.reviews,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // ⭐ SUMMARY
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < rating.round() ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '$totalReviews reviews',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // 📝 REVIEWS LIST
        if (reviews.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text("No reviews yet"),
            ),
          )
        else
          ...reviews.map((r) => _ReviewCard(review: r)),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    final bool hasProfilePic =
        review.userProfilePic != null && review.userProfilePic!.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 👤 USER HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: hasProfilePic
                    ? NetworkImage(review.userProfilePic!)
                    : null,
                child: !hasProfilePic
                    ? Icon(Icons.person, color: Colors.grey.shade600)
                    : null,
              ),
              const SizedBox(width: 10),

              // NAME + DATE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName?.fullName ?? 'Anonymous',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    if (review.createdAt != null)
                      Text(
                        DateFormat('dd MMM yyyy').format(review.createdAt!),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                  ],
                ),
              ),

              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.stars ? Icons.star : Icons.star_border,
                    size: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            review.description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCTA extends StatelessWidget {
  final String price;
  final VoidCallback onEnroll;
  final bool loading;

  const _BottomCTA({
    required this.price,
    required this.onEnroll,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Course Price', style: TextStyle(fontSize: 12)),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: loading ? null : onEnroll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF6B35),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Enroll Now',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
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
