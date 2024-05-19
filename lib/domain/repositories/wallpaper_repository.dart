import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pixel_palette/domain/entities/wallpaper_entities.dart';
import 'package:pixel_palette/models/wallpaper_model.dart';

class WallpaperRepositoryImpl implements WallpaperRepository {
  final String baseUrl = 'https://api.unsplash.com';
  final String accessKey = 'PcsF24zwl66NyMiuZMnOnz2z9fY4R6venlIM68fhNNs';
  final Dio dio;

  WallpaperRepositoryImpl({required this.dio});

  @override
  Future<List<WallpaperModel>> fetchPhotos(int page, int perPage) async {
    //final response = await _dio.get('$baseUrl/photos?page=$page&per_page=$perPage&client_id=$accessKey');
    final response = await dio.get('$baseUrl/photos', queryParameters: {
      'page': page,
      'per_page': perPage,
      'client_id': accessKey,
    });

    if (response.statusCode == 200) {
      //List jsonResponse = json.decode(response.data);
      List<dynamic> jsonResponse = response.data;

      print(jsonResponse);
      return jsonResponse
          .map((photos) => WallpaperModel.fromJson(photos))
          .toList();
    } else {
      throw Exception('Failed to load photos');
    }
  }
}
