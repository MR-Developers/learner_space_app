import 'package:flutter/material.dart';
import 'package:learner_space_app/Apis/Services/comments_service.dart';
import 'package:learner_space_app/Utils/UserSession.dart';

class RepliesBottomSheet extends StatefulWidget {
  final dynamic comment; // parent comment object
  final String postId;

  const RepliesBottomSheet({
    super.key,
    required this.comment,
    required this.postId,
  });

  @override
  State<RepliesBottomSheet> createState() => _RepliesBottomSheetState();
}

class _RepliesBottomSheetState extends State<RepliesBottomSheet> {
  final CommentsService _commentsService = CommentsService();
  final TextEditingController _controller = TextEditingController();

  bool isSending = false;
  bool isLoadingReplies = true;

  List<dynamic> replies = [];
  Map<String, bool> isLiking = {};

  @override
  void initState() {
    super.initState();
    _loadReplies();
  }

  Future<void> _loadReplies() async {
    try {
      final res = await _commentsService.getReplies(widget.comment["_id"]);
      setState(() {
        replies = res["data"];
        isLoadingReplies = false;
      });
    } catch (e) {
      setState(() {
        isLoadingReplies = false;
      });
    }
  }

  Future<void> _submitReply() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() => isSending = true);

    try {
      final userId = await UserSession.getUserId();

      await _commentsService.addReply(
        widget.comment["_id"],
        widget.postId,
        userId!,
        text,
      );

      _controller.clear();
      FocusScope.of(context).unfocus();

      await _loadReplies();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to add reply")));
    } finally {
      setState(() => isSending = false);
    }
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
              // Handle
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
                "Replies",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              Expanded(
                child: isLoadingReplies
                    ? const Center(child: CircularProgressIndicator())
                    : replies.isEmpty
                    ? const Center(
                        child: Text(
                          "No replies yet",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: replies.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (_, index) =>
                            _buildReplyItem(replies[index]),
                      ),
              ),

              _buildReplyInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReplyItem(dynamic r) {
    final userName = r["userName"]["firstname"] ?? "Unknown";

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
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
              Text(r["text"]),
              const SizedBox(height: 4),
              Text(
                "Just now",
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReplyInput() {
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
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Add a reply...",
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
                  onTap: _submitReply,
                  child: const Icon(Icons.send, color: Colors.black87),
                ),
        ],
      ),
    );
  }
}
