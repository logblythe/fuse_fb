import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'circle_image.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function() onPostSelect;

  const PostCard({Key key, this.post, this.onPostSelect}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 16),
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: CustomScrollView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(
              [
                topRow(context),
                Divider(color: Colors.grey, thickness: 2),
                message(context),
              ],
            ),
          ),
          imagesGridView(),
        ],
      ),
    );
  }

  Widget message(BuildContext context) {
    return post.message.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              post.message,
              style:
                  Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
            ),
          )
        : Container();
  }

  Padding topRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                CircleImage(),
                SizedBox(width: 24),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: onPostSelect,
          ),
        ],
      ),
    );
  }

  Widget imagesGridView() {
    List<dynamic> _images = post.imageList ?? [];
    if (_images.length == 0) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    } else if (_images.length == 1) {
      if (_images[0] is String) {
        return SliverToBoxAdapter(
          child: CachedNetworkImage(
            imageUrl: _images[0],
            height: 300,
            progressIndicatorBuilder: (ctx, url, progress) {
              return Center(child: CircularProgressIndicator());
            },
            errorWidget: (context, url, error) {
              return Icon(Icons.error);
            },
          ),
        );
      } else {
        return SliverToBoxAdapter(
          child: AssetThumb(
            height: 300,
            width: 300,
            asset: _images[0],
            spinner: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        );
      }
    } else {
      return SliverPadding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
          ),
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return Stack(
                children: [
                  (_images[index] is String)
                      ? CachedNetworkImage(
                          imageUrl: _images[index],
                          height: 300,
                          progressIndicatorBuilder: (ctx, url, progress) {
                            return Center(child: CircularProgressIndicator());
                          },
                          errorWidget: (context, url, error) {
                            return Icon(Icons.error);
                          },
                        )
                      : AssetThumb(
                          height: 300,
                          width: 300,
                          asset: _images[index],
                          spinner: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                  _images.length > 4 && index == 3
                      ? InkWell(
                          onTap: onPostSelect,
                          child: Container(
                            color: Colors.black.withOpacity(0.5),
                            child: Center(
                              child: Text(
                                'View more',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              );
            },
            childCount: _images.length > 4 ? 4 : _images.length,
          ),
        ),
      );
    }
  }
}
