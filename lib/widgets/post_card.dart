import 'package:flutter/material.dart';
import 'package:fuse/models/post_model.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'circle_image.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final Function() onPostSelect;

  const PostCard({Key key, this.post, this.onPostSelect}) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
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
                message(context)
              ],
            ),
          ),
          images(),
        ],
      ),
    );
  }

  Widget message(BuildContext context) {
    return widget.post.message.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              widget.post.message,
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
            onPressed: widget.onPostSelect,
          ),
        ],
      ),
    );
  }

  Widget images() {
    List<dynamic> _images = []
      ..addAll(widget.post?.images?.toList() ?? [])
      ..addAll(widget.post?.imageUrls?.toList() ?? []);
    if (_images.length == 0) {
      return SliverToBoxAdapter(
        child: Container(),
      );
    } else if (_images.length == 1) {
      if (_images[0] is String) {
        return SliverToBoxAdapter(child: Image.network(_images[0]));
      } else {
        return SliverToBoxAdapter(
          child: AssetThumb(
            height: 200,
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
              return (_images[index] is String)
                  ? Image.network(_images[index])
                  : AssetThumb(
                      height: 200,
                      width: 300,
                      asset: _images[index],
                      spinner: Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
            },
            childCount: _images.length,
          ),
        ),
      );
    }
  }
}
