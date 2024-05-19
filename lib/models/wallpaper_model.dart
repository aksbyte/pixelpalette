class WallpaperModel {
  final String id;
  final String smallUrl;
  final String fullUrl;
  final String authorName;
  final DateTime creationDate;
  final String imageSize;
  final String orientation;

  WallpaperModel({
    required this.id,
    required this.smallUrl,
    required this.fullUrl,
    required this.authorName,
    required this.creationDate,
    required this.imageSize,
    required this.orientation,
  });

  factory WallpaperModel.fromJson(Map<String, dynamic> json) {
    return WallpaperModel(
      id: json['id'],
      smallUrl: json['urls']['small'],
      fullUrl: json['urls']['full'],
      authorName: json['user']['name'],
      creationDate: DateTime.parse(json['created_at']),
      imageSize: '${json['width']}x${json['height']}',
      orientation: json['width'] > json['height'] ? 'Landscape' : 'Portrait',
    );
  }
}
