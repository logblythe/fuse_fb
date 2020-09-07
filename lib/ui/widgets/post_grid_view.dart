import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostGridView extends StatelessWidget {
  final List<dynamic> images;
  final Function(int) onRemove;

  const PostGridView({Key key, @required this.images, @required this.onRemove})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: List.generate(
          images.length,
          (index) {
            return Stack(
              children: [
                images[index] is String
                    ? CachedNetworkImage(
                        imageUrl: images[index],
                        height: 300,
                        progressIndicatorBuilder: (ctx, url, progress) {
                          return Center(child: CircularProgressIndicator());
                        },
                        errorWidget: (context, url, error) {
                          return Icon(Icons.error);
                        },
                      )
                    : AssetThumb(
                        asset: images[index],
                        width: 300,
                        height: 300,
                        spinner: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    iconSize: 36,
                    icon: Icon(Icons.cancel),
                    color: Colors.red,
                    onPressed: () => onRemove(index),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
