// photos_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category_wallpaper/category_cubit.dart';
import '../bloc/category_wallpaper/collection_state.dart';
import '../domain/repositories/category_repository.dart';
import '../services/get_it.dart';

class PhotosScreen extends StatelessWidget {
  final String collectionId;

  const PhotosScreen({Key? key, required this.collectionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
      ),
      body: BlocProvider(
        create: (context) => CollectionCubit(getIt<CollectionRepository>())
          ..getCollectionPhotos(collectionId),
        child: BlocBuilder<CollectionCubit, CollectionState>(
          builder: (context, state) {
            if (state is CollectionLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CollectionPhotosLoaded) {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: state.photos.length,
                itemBuilder: (context, index) {
                  final photo = state.photos[index];
                  return Card(
                    child: Image.network(photo['urls']['small']),
                  );
                },
              );
            } else if (state is CollectionError) {
              return Center(child: Text(state.message));
            }
            return Center(child: Text('Image not found'));
          },
        ),
      ),
    );
  }
}
