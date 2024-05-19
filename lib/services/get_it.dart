// service_locator.dart

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../domain/repositories/category_repository.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<Dio>(() => Dio());
  getIt.registerLazySingleton<CollectionRepository>(
      () => CollectionRepository(dio: getIt<Dio>()));
}
