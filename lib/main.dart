import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_palette/bloc/theme_cubit.dart';
import 'package:pixel_palette/bloc/wallpaper_cubit.dart';
import 'package:pixel_palette/domain/repositories/wallpaper_repository.dart';
import 'package:pixel_palette/domain/usecases/get_wallpaper.dart';
import 'package:pixel_palette/screen/home_screen.dart';
import 'package:pixel_palette/services/theme_manager.dart';

void main() {
  final Dio dio = Dio();

  runApp(MyApp(dio: dio));
}

class MyApp extends StatelessWidget {
  final Dio dio;

  const MyApp({super.key, required this.dio});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => WallpaperCubit(
                GetWallpaper(WallpaperRepositoryImpl(dio: dio)))),
        BlocProvider<ThemeCubit>(
          create: (context) => ThemeCubit(),
        )
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeManager.lightTheme,
            darkTheme: ThemeManager.darkTheme,
            themeMode: themeMode,
            home: HomePage(
              dio: dio,
            ),
          );
        },
      ),
    );
  }
}
