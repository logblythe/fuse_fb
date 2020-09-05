import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fuse/models/post_model.dart';
import 'package:fuse/screens/add_post_screen.dart';
import 'package:fuse/screens/post_details_screen.dart';
import 'package:fuse/widgets/circle_image.dart';
import 'package:fuse/widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Facebook')),
      body: _body(),
    );
  }

  Widget _body() {
    return Container(
      color: Colors.grey.withOpacity(0.2),
      padding: const EdgeInsets.all(12),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: addCard()),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return PostCard(
                  post: _posts.elementAt(index),
                  onPostSelect: _handlePostSelect,
                );
              },
              childCount: _posts.length,
            ),
          )
        ],
      ),
    );
  }

  addCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey, width: 2),
      ),
      child: Row(
        children: [
          CircleImage(),
          SizedBox(width: 24),
          Expanded(
            child: InkWell(
              onTap: _handleCreatePost,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                    disabledBorder: const OutlineInputBorder(),
                    hintText: "What\'s on your mind?",
                    border: const OutlineInputBorder(),
                    hintStyle: Theme.of(context).textTheme.headline6),
              ),
            ),
          )
        ],
      ),
    );
  }

  _handleCreatePost() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddPostScreen();
    }));
  }

  _handlePostSelect() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return PostDetailsScreen();
    }));
  }
}
