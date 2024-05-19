  class CategoryCollection {
  final String id;
  final String title;
  final String description;
  final String coverPhoto;
  final List<String> photoUrls;

  CategoryCollection({
    required this.id,
    required this.title,
    required this.description,
    required this.coverPhoto,
    required this.photoUrls,
  });

  factory CategoryCollection.fromJson(Map<String, dynamic> json) {
    List<String> photoUrls = (json['photos'] as List)
        .map((photo) => photo['urls']['regular'] as String)
        .toList();

    return CategoryCollection(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      coverPhoto: json['cover_photo']['urls']['small'],
      photoUrls: photoUrls,
    );
  }
}
