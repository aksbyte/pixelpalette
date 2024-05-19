import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pixel_palette/bloc/wallpaper_cubit.dart';
import 'package:pixel_palette/bloc/wallpaper_state.dart';
import 'package:pixel_palette/screen/wallpaper_detail_screen.dart';
import 'package:pixel_palette/widgets/category_card.dart';

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

  int _changePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(appBarTitle),
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.search),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(30)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _changePageIndex = 1;
                        });
                      },
                      icon: const Icon(Icons.grid_view_rounded)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _changePageIndex = 0;
                        });
                      },
                      icon: const Icon(Icons.watch_later_rounded)),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          _changePageIndex = 2;
                        });
                      },
                      icon: const Icon(Icons.favorite_outlined)),
                ],
              ),
            ),
          ),
          _changePageIndex == 0 ? buildGridView() : const SizedBox.shrink(),
          _changePageIndex == 1
              ? const CategoryCard() : const SizedBox.shrink(),
              _changePageIndex == 2 ? Container(
                  height: 40,
                  width: 50,
                  color: Colors.green,
                ): const SizedBox.shrink()
        ],
      ),
    );
  }

  Expanded buildGridView() {
    return Expanded(
      child: BlocBuilder<WallpaperCubit, WallpaperState>(
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
