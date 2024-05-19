import 'package:pixel_palette/domain/repositories/wallpaper_repository.dart';
import 'package:pixel_palette/models/wallpaper_model.dart';

import '../entities/wallpaper_entities.dart';

class GetWallpaper {
  final WallpaperRepository wallpaperRepository;

  GetWallpaper(this.wallpaperRepository);

  Future<List<WallpaperModel>> call(int page, int perPage) {
    return wallpaperRepository.fetchPhotos(page, perPage);
  }
}
