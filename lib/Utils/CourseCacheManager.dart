import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CourseCacheManager extends CacheManager {
  static const key = "courseImageCache";

  static final CourseCacheManager _instance = CourseCacheManager._internal();

  factory CourseCacheManager() {
    return _instance;
  }

  CourseCacheManager._internal()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 7), // 🟢 longer cache
          maxNrOfCacheObjects: 300, // 🟢 more images
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
}
