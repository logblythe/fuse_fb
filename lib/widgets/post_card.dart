import 'package:flutter/material.dart';
import 'package:fuse/models/post_model.dart';

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
                Padding(
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
                ),
                Divider(color: Colors.grey, thickness: 2),
              ],
            ),
          ),
          // SliverToBoxAdapter(
          //   child: Image.asset('assets/images/placeholder.png'),
          // ),
          SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.all(16),
                    color: Colors.red,
                    height: 150.0);
              },
              childCount: 4,
            ),
          ),
        ],
      ),
    );
  }
}
