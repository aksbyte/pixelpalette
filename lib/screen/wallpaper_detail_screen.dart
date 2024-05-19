import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pixel_palette/models/wallpaper_model.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';

enum WallpaperLocation {
  homeScreen,
  lockScreen,
  bothScreens,
}

class WallpaperDetailScreen extends StatefulWidget {
  final WallpaperModel wallpaperModel;

  const WallpaperDetailScreen({super.key, required this.wallpaperModel});

  @override
  State<WallpaperDetailScreen> createState() => _WallpaperDetailScreenState();
}

class _WallpaperDetailScreenState extends State<WallpaperDetailScreen> {
  bool _isLoading = false;

  Future<void> _setWallpaper(WallpaperLocation location) async {
    setState(() {
      _isLoading = true;
    });
    try {
      var file = await DefaultCacheManager()
          .getSingleFile(widget.wallpaperModel.fullUrl);
      if (file == null) {
        showSnackBar(context, 'Failed to set wallpaper');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      int wallpaperLocation;
      switch (location) {
        case WallpaperLocation.homeScreen:
          wallpaperLocation = WallpaperManager.HOME_SCREEN;
          break;
        case WallpaperLocation.lockScreen:
          wallpaperLocation = WallpaperManager.LOCK_SCREEN;
          break;
        case WallpaperLocation.bothScreens:
          wallpaperLocation = WallpaperManager.BOTH_SCREEN;
          break;
      }
      final result = await WallpaperManager.setWallpaperFromFile(
          file.path, wallpaperLocation);
      if (result == true) {
        showSnackBar(context, 'Successfully set wallpaper');
        Navigator.pop(context, 'Home Screen');
      }
      print(result);

      print('Successfull set wallpaper');
    } catch (e) {
      // Handle errors
      print(e.toString());
      showSnackBar(context, "Oops Something went wrong");
    } finally {
      setState(() {
        _isLoading = false;
        Navigator.pop(context, 'Home Screen');
      });
    }
  }

  Future<void> _downloadWallpaper(BuildContext context) async {
    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    // Request permission to save images
    var status = await Permission.storage.request();
    if (status.isGranted) {
      try {
        // Download the image
        var imageStream =
            CachedNetworkImageProvider(widget.wallpaperModel.fullUrl)
                .resolve(const ImageConfiguration());

        // Listen to the image stream
        imageStream.addListener(
          ImageStreamListener(
              (ImageInfo imageInfo, bool synchronousCall) async {
            // Convert the image data to bytes
            ByteData? byteData =
                await imageInfo.image.toByteData(format: ImageByteFormat.png);
            if (byteData != null) {
              Uint8List bytes = byteData.buffer.asUint8List();

              // Save the image to the gallery
              final result = await ImageGallerySaver.saveImage(bytes);

              if (result['isSuccess']) {
                showSnackBar(context, 'Image saved to gallery');
              } else {
                showSnackBar(context, 'Failed to save image');
              }
            } else {
              showSnackBar(context, 'Failed to load image data');
            }

            // Hide loading indicator
            setState(() {
              _isLoading = false;
            });
          }),
        );
      } catch (e) {
        print('Error saving image: $e');
        showSnackBar(context, 'Failed to save image');

        // Hide loading indicator
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      showSnackBar(context, 'Permission denied');

      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.bottomCenter,
        children: [
          Container(
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                  //color: Colors.red,
                  ),
              child: CachedNetworkImage(
                imageUrl: widget.wallpaperModel.fullUrl,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const Center(child: CupertinoActivityIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: _isLoading
                    ? const Center(
                        child: CupertinoActivityIndicator(),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              await showModalBottomSheet(
                                backgroundColor: Colors.white.withOpacity(0.7),
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (BuildContext context,
                                        StateSetter setState) {
                                      return SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.20,
                                        width: double.infinity,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(20),
                                            child: _isLoading
                                                ? const Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Center(
                                                        child:
                                                            CupertinoActivityIndicator(),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text('Please wait'),
                                                    ],
                                                  )
                                                : Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _isLoading =
                                                                    true;
                                                              });
                                                              _setWallpaper(
                                                                  WallpaperLocation
                                                                      .homeScreen);
                                                              //     _downloadAndSetWallpaper(context);
                                                              //   Navigator.pop(context, 'Home Screen');
                                                            },
                                                            child: const Text(
                                                                'Home Screen'),
                                                          ),
                                                          const SizedBox(
                                                              width: 10),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              setState(() {
                                                                _isLoading =
                                                                    true;
                                                              });
                                                              _setWallpaper(
                                                                  WallpaperLocation
                                                                      .lockScreen);
                                                              //  _downloadAndSetWallpaper(context);
                                                              //  Navigator.pop(context, 'Lock Screen');
                                                            },
                                                            child: const Text(
                                                                'Lock Screen'),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                          height: 10),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _isLoading = true;
                                                          });
                                                          _setWallpaper(
                                                              WallpaperLocation
                                                                  .bothScreens);
                                                          //     _downloadAndSetWallpaper(context);
                                                          //  Navigator.pop(context, 'Both');
                                                        },
                                                        child:
                                                            const Text('Both'),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            splashColor: Colors.white,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 12),
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Text('Set Wallpaper'),
                            ),
                          ),
                          InkWell(
                            onTap: () => _downloadWallpaper(context),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.cloud_download_outlined),
                            ),
                          ),
                          InkWell(
                            onTap: () => null,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  borderRadius: BorderRadius.circular(10)),
                              child: const Icon(CupertinoIcons.share_up),
                            ),
                          )
                        ],
                      )),
          )
        ],
      ),
    );
  }
}
