class ApiEndpoints {
  // AUTH
  static const String login = '/users/login';
  static const String register = '/users';

  // COURSES
  static const String getCourses = "/users/getCourses";

  static String getRecommendedCourses(String userId) =>
      "/users/getRecommendedCourses/$userId";

  // POSTS
  static const String createPost = "/posts";
  static const String getAllPosts = "/posts";

  static String likePost(String postId) => "/posts/like/$postId";
  static String updatePost(String postId) => "/posts/$postId";
  static String deletePost(String postId) => "/posts/$postId";

  static String getPostsByUser(String userId) => "/posts/user/$userId";
  static String getPostsByCategory(String category) =>
      "/posts/category/$category";
}
