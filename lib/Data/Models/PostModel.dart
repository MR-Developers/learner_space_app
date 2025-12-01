enum PostCategory { all, tech, career }

extension PostCategoryExtension on PostCategory {
  String get label {
    switch (this) {
      case PostCategory.all:
        return "All";
      case PostCategory.tech:
        return "Tech";
      case PostCategory.career:
        return "Career";
    }
  }

  int get value {
    switch (this) {
      case PostCategory.all:
        return 0;
      case PostCategory.tech:
        return 1;
      case PostCategory.career:
        return 2;
    }
  }

  static PostCategory fromInt(int value) {
    switch (value) {
      case 0:
        return PostCategory.all;
      case 1:
        return PostCategory.tech;
      case 2:
        return PostCategory.career;
      default:
        return PostCategory.all;
    }
  }
}

class Post {
  String id;
  String description;
  String userId;
  String userName;
  int likes;
  int commentNumber;
  PostCategory category;
  bool isLiked;

  Post({
    required this.id,
    required this.description,
    required this.userId,
    required this.userName,
    required this.likes,
    required this.commentNumber,
    required this.category,
    required this.isLiked,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["_id"],
      description: json["description"] ?? "",
      userId: json["userId"] ?? "",
      userName:
          "${json["userName"]["firstname"]} ${json["userName"]["lastname"]}" ??
          "",
      likes: json["likes"] ?? 0,
      commentNumber: json["commentNumber"] ?? 0,
      category: PostCategoryExtension.fromInt(json["category"] ?? 0),
      isLiked: json["isLiked"] ?? false,
    );
  }
}
