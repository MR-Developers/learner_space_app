import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/posts_service.dart';
import 'package:learner_space_app/Data/Models/PostModel.dart';

class UserCommunity extends StatefulWidget {
  const UserCommunity({super.key});

  @override
  State<UserCommunity> createState() => _UserCommunityState();
}

class _UserCommunityState extends State<UserCommunity>
    with SingleTickerProviderStateMixin {
  static const Color brandColor = Color(0xFFEF7C08);

  late TabController _tabController;
  final PostsService _postsService = PostsService();
  List<Post> discussions = [];

  bool isLoading = false;
  String? errorMessage;

  final List<PostCategory> categories = [
    PostCategory.all,
    PostCategory.tech,
    PostCategory.career,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);

    _fetchPosts(PostCategory.all);

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _fetchPosts(categories[_tabController.index]);
    });
  }

  Future<void> _fetchPosts(PostCategory category) async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      Map<String, dynamic> response;

      if (category == PostCategory.all) {
        response = await _postsService.getAllPosts();
      } else {
        response = await _postsService.getPostsByCategory(
          category.value.toString(),
        );
      }

      discussions = (response["data"] as List<dynamic>)
          .map((e) => Post.fromJson(e))
          .toList();

      setState(() => isLoading = false);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getInitials(String name) {
    return name
        .split(" ")
        .map((n) => n.isNotEmpty ? n[0] : "")
        .join("")
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(theme),
            _buildTabs(theme),
            Expanded(child: _buildBody(theme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.people, size: 22, color: brandColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "Community",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, "/userPostPage");
            },
            style: FilledButton.styleFrom(
              backgroundColor: brandColor,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(12),
            ),
            child: const Icon(Icons.add, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs(ThemeData theme) {
    return TabBar(
      controller: _tabController,
      tabs: categories.map((c) => Tab(text: c.label)).toList(),
      labelColor: brandColor,
      unselectedLabelColor: theme.colorScheme.onSurface.withOpacity(0.6),
      indicatorColor: brandColor,
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: discussions.length,
      itemBuilder: (context, index) {
        final d = discussions[index];
        return _buildDiscussionCard(theme, d);
      },
    );
  }

  Widget _buildDiscussionCard(ThemeData theme, Post d) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: brandColor.withOpacity(0.1),
              child: Text(
                "hi",
                style: const TextStyle(
                  color: brandColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d.userName,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    d.description,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Chip(
                    label: Text(d.category.label),
                    backgroundColor: brandColor.withOpacity(0.1),
                    labelStyle: const TextStyle(
                      color: brandColor,
                      fontSize: 11,
                    ),
                    visualDensity: VisualDensity.compact,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(Icons.chat_bubble_outline, size: 16),
                      const SizedBox(width: 4),
                      Text("${d.commentNumber} replies"),

                      const SizedBox(width: 16),

                      const Icon(Icons.thumb_up_outlined, size: 16),
                      const SizedBox(width: 4),
                      Text("${d.likes} likes"),
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

  Widget _chip(String label, {Color color = brandColor}) {
    return Chip(
      label: Text(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontSize: 11),
      visualDensity: VisualDensity.compact,
    );
  }
}
