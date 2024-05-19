import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixel_palette/bloc/wallpaper_cubit.dart';
import 'package:pixel_palette/bloc/wallpaper_state.dart';
import 'package:pixel_palette/screen/wallpaper_detail_screen.dart';

import '../bloc/theme_cubit.dart';
import '../services/theme_manager.dart';

class HomePage extends StatefulWidget {
  final Dio dio;

  const HomePage({super.key, required this.dio});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String appBarTitle = 'Pixel Palette';
  final ScrollController _scrollController = ScrollController();
  final int _perPage = 15;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<WallpaperCubit>().fetchPhotos(_perPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<WallpaperCubit>().fetchPhotos(_perPage);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outlined),
            onPressed: () {},
          ),
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
                activeColor: Theme.of(context).colorScheme.secondary,
              );
            },
          ),
        ],
      ),
      //backgroundColor: Colors.grey[200],
      //backgroundColor: Colors.black45,
      body: BlocBuilder<WallpaperCubit, WallpaperState>(
        builder: (context, state) {
          if (state is WallpaperLoading) {
            return const Center(child: CupertinoActivityIndicator());
          } else if (state is WallpaperLoaded) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.custom(
                controller: _scrollController,
                gridDelegate: SliverQuiltedGridDelegate(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  repeatPattern: QuiltedGridRepeatPattern.inverted,
                  pattern: [
                    const QuiltedGridTile(2, 2),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 1),
                    const QuiltedGridTile(1, 2),
                  ],
                ),
                childrenDelegate: SliverChildBuilderDelegate(
                  // childCount: state.wallpaper.length,
                  childCount: state.wallpaper.length + 1,
                  (context, index) {
                    if (index < state.wallpaper.length) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => WallpaperDetailScreen(
                                    wallpaperModel: state.wallpaper[index]),
                              ));
                        },
                        child: Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                //      color: Colors.pink,
                                borderRadius: BorderRadius.circular(12)),
                            child: CachedNetworkImage(
                              imageUrl: state.wallpaper[index].smallUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              placeholder: (context, url) => const Center(
                                  child: CupertinoActivityIndicator()),
                              //const Center(child: WallpaperSkeleton(itemCount: 1)),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            );
          } else if (state is WallpaperError) {
            return Center(child: Text(state.errorMsg));
          } else {
            return const Center(child: Text('No Photos'));
          }
        },
      ),
    );
  }
}
