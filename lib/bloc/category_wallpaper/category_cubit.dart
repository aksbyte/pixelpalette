// collection_cubit.dart
import 'package:bloc/bloc.dart';

import '../../domain/repositories/category_repository.dart';
import 'collection_state.dart';


class CollectionCubit extends Cubit<CollectionState> {
  final CollectionRepository repository;

  CollectionCubit(this.repository) : super(CollectionInitial());

  Future<void> getCollections() async {
    try {
      emit(CollectionLoading());
      final collections = await repository.fetchCollections();
      emit(CollectionLoaded(collections));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }

  Future<void> getCollectionPhotos(String collectionId) async {
    try {
      emit(CollectionLoading());
      final photos = await repository.fetchCollectionPhotos(collectionId);
      emit(CollectionPhotosLoaded(photos));
    } catch (e) {
      emit(CollectionError(e.toString()));
    }
  }
}
