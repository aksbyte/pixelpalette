import '../models/wallpaper_model.dart';

abstract class WallpaperState {}

class WallpaperInitial extends WallpaperState {}

class WallpaperLoading extends WallpaperState {}

class WallpaperLoaded extends WallpaperState {
  final List<WallpaperModel> wallpaper;

  WallpaperLoaded({required this.wallpaper});
}

class WallpaperError extends WallpaperState {
  final String errorMsg;

  WallpaperError(this.errorMsg);
}
