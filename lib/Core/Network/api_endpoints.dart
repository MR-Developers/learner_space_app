class ApiEndpoints {
  // AUTH
  static const String login = '/learners/login';
  static const String register = '/learners';
  static const String changePassword = '/learners/change-password';

  // COURSES
  static const String getCourses = "/learners/getCourses";

  static String getRecommendedCourses(String userId) =>
      "/learners/getRecommendedCourses/$userId";
  static String getRecommendedCourseByCat(String userId, String categoryId) =>
      "/learners/getRecommendedCourseByCat/$userId/$categoryId";
  static String getCourseById(String courseId) =>
      "/learners/getCourse/$courseId";

  // POSTS
  static const String createPost = "/posts";
  static String getAllPosts(String userId) => "/posts/$userId";
  static String updatePost(String postId) => "/posts/$postId";
  static String deletePost(String postId) => "/posts/$postId";

  static String getPostsByUser(String userId) => "/posts/user/$userId";
  static String getPostsByCategory(String category, String userId) =>
      "/posts/category/$category/$userId";

  //LIKES
  static String likePost(String postId) => "/likes/$postId";

  static String unlikePost(String postId) => "/likes/unlike/$postId";

  static String checkIsLiked(String postId, String userId) =>
      "/likes/check/$postId/$userId";

  static String getLikesForPost(String postId) => "/likes/post/$postId";

  // COMMENTS
  static const String addComment = "/comments";

  static String addReply(String parentCommentId) =>
      "/comments/reply/$parentCommentId";

  static String getCommentsForPost(String postId) => "/comments/post/$postId";

  static String getReplies(String commentId) => "/comments/replies/$commentId";

  static String deleteComment(String commentId) => "/comments/$commentId";

  //CATEGORIES
  static const String getAllCategories = "/learners/getAllCategories";

  static String getCompanyCategoryCount(String categoryId) =>
      "/learners/companyCategoryCount/$categoryId";

  //OUTCOMES
  static const String createOutcome = "/outcomes";
  static const String getAllOutcomes = "/outcomes";

  static String getOutcomeById(String outcomeId) => "/outcomes/$outcomeId";

  static String getOutcomesByUser(String userId) => "/outcomes/user/$userId";

  static String getOutcomesByCourse(String courseId) =>
      "/outcomes/course/$courseId";

  static String updateOutcome(String outcomeId) => "/outcomes/$outcomeId";

  static String deleteOutcome(String outcomeId) => "/outcomes/$outcomeId";

  static const String getFeatureOutcomes = "/outcomes/featured";

  // REVIEWS
  static const String createReview = "/learners/reviews";

  static const String getAllReviews = "/learners/reviews";

  static String getReviewsByCourse(String courseId) =>
      "/learners/reviews/course/$courseId";

  static String updateReview(String reviewId) => "/learners/reviews/$reviewId";

  static String deleteReview(String reviewId) => "/learners/reviews/$reviewId";
  // LEADS
  static const String createLead = "/leads";
}
