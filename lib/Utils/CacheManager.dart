import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class MyCacheManager extends CacheManager {
  static const key = "myCustomCache";

  static final MyCacheManager _instance = MyCacheManager._internal();

  factory MyCacheManager() {
    return _instance;
  }

  MyCacheManager._internal()
    : super(
        Config(
          key,
          stalePeriod: const Duration(days: 1),
          maxNrOfCacheObjects: 100,
          repo: JsonCacheInfoRepository(databaseName: key),
          fileService: HttpFileService(),
        ),
      );
}
