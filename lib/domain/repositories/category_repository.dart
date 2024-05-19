// collection_repository.dart
import 'package:dio/dio.dart';
import 'package:pixel_palette/domain/api_list/api_list.dart';

class CollectionRepository {
  final Dio dio;

  CollectionRepository({required this.dio});

  Future<List<dynamic>> fetchCollections() async {
    final response = await dio.get('${ApiList.baseUrl}/${ApiList.collection}', queryParameters: {
      'client_id': ApiList.accessKey,
    });
    print(response.data);
    return response.data;

  }

  Future<List<dynamic>> fetchCollectionPhotos(String collectionId) async {
    final response = await dio.get('${ApiList.baseUrl}/${ApiList.collection}/$collectionId/photos', queryParameters: {
      'client_id':ApiList.accessKey,
    });
    return response.data;
  }
}
