import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/comments_service.dart';
import 'package:learner_space_app/Components/Community/RepliesBottomSheet.dart';
import 'package:learner_space_app/Utils/UserSession.dart';

class CommentBottomSheet extends StatefulWidget {
  final String postId;
  final VoidCallback onCommentAdded;

  const CommentBottomSheet({
    super.key,
    required this.postId,
    required this.onCommentAdded,
  });

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final TextEditingController _controller = TextEditingController();
  final CommentsService _commentsService = CommentsService();

  bool isSending = false;
  bool isLoadingComments = true;
  List<dynamic> comments = [];
  Map<String, bool> isLiking = {}; // like loader per comment

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  Future<void> _loadComments() async {
    try {
      final response = await _commentsService.getComments(widget.postId);
      setState(() {
        comments = response["data"]["comments"];
        isLoadingComments = false;
      });
    } catch (e) {
      setState(() => isLoadingComments = false);
    }
  }

  Future<void> _submitComment() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => isSending = true);

    try {
      final userId = await UserSession.getUserId();
      await _commentsService.addComment(widget.postId, userId!, text);

      _controller.clear();
      FocusScope.of(context).unfocus();

      await _loadComments();
      widget.onCommentAdded();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add comment")));
    } finally {
      setState(() => isSending = false);
    }
  }

  void _openReplies(dynamic parentComment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) =>
          RepliesBottomSheet(comment: parentComment, postId: widget.postId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SafeArea(
      top: false,
      child: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Top handle
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),

              const Text(
                "Comments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: isLoadingComments
                    ? const Center(child: CircularProgressIndicator())
                    : comments.isEmpty
                    ? const Center(
                        child: Text(
                          "No comments yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: comments.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, i) => _buildCommentItem(comments[i]),
                      ),
              ),

              _buildCommentInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCommentItem(dynamic c) {
    final userName = c["userName"]["firstname"] ?? "Unknown";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey[300],
          child: Text(
            userName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(c["text"]),
              const SizedBox(height: 4),

              GestureDetector(
                onTap: () => _openReplies(c),
                child: Text(
                  "View replies",
                  style: TextStyle(color: Colors.blue[600], fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInput() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              minLines: 1,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Add a comment...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          isSending
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : GestureDetector(
                  onTap: _submitComment,
                  child: const Icon(Icons.send, color: Colors.black87),
                ),
        ],
      ),
    );
  }
}
