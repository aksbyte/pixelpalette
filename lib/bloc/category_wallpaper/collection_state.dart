import 'package:equatable/equatable.dart';




abstract class CollectionState extends Equatable {
  const CollectionState();

  @override
  List<Object> get props => [];
}

class CollectionInitial extends CollectionState {}

class CollectionLoading extends CollectionState {}

class CollectionLoaded extends CollectionState {
  final List<dynamic> collections;

  const CollectionLoaded(this.collections);

  @override
  List<Object> get props => [collections];
}

class CollectionPhotosLoaded extends CollectionState {
  final List<dynamic> photos;

  const CollectionPhotosLoaded(this.photos);

  @override
  List<Object> get props => [photos];
}

class CollectionError extends CollectionState {
  final String message;

  const CollectionError(this.message);

  @override
  List<Object> get props => [message];
}
