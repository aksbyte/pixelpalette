import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_palette/bloc/wallpaper_state.dart';
import 'package:pixel_palette/domain/usecases/get_wallpaper.dart';

import '../models/wallpaper_model.dart';

class WallpaperCubit extends Cubit<WallpaperState> {
  final GetWallpaper getWallpaper;

  List<WallpaperModel> wallpaper = [];
  int page = 1;
  bool isLoading = false;

  WallpaperCubit(this.getWallpaper) : super(WallpaperInitial());

  void fetchPhotos(int perPage) async {
    try {
      if (!isLoading) {
        isLoading = true;

        if (page == 1) {
          emit(WallpaperLoading());
        }

        final newWallpaper = await getWallpaper(page, perPage);
        if (page == 1) {
          wallpaper = newWallpaper;
          emit(WallpaperLoaded(wallpaper: wallpaper));
        } else {
          wallpaper.addAll(newWallpaper);
          emit(WallpaperLoaded(wallpaper: wallpaper));
        }

        page++;
        isLoading = false;
      }
    } catch (error) {
      isLoading = false;
      emit(WallpaperError('Failed to fetch photos'));
    }
  }
}
