import 'package:pixel_palette/models/wallpaper_model.dart';

abstract class WallpaperRepository {
  Future<List<WallpaperModel>> fetchPhotos(int page, int perPage);
}
