import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fuse/base_widget.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/view_models/post_view_model.dart';
import 'package:fuse/ui/screens/add_post_screen.dart';
import 'package:fuse/ui/widgets/circle_image.dart';
import 'package:fuse/ui/widgets/post_card.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PostViewModel _postVm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Facebook')),
      body: _body(),
    );
  }

  Widget _body() {
    return BaseWidget<PostViewModel>(
      model: PostViewModel(
        navigationService: Provider.of(context),
        postService: Provider.of(context),
      ),
      onModelReady: (model) {
        _postVm = model;
        _postVm.fetchQuotes();
      },
      builder: (context, model, child) {
        return Container(
          color: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.all(12),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: createPostContainer()),
              StreamBuilder<List<Post>>(
                stream: model.postsStream,
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data;
                    List<Post> _posts = data.reversed.toList();
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return PostCard(
                            post: _posts.elementAt(index),
                            onPostSelect: () =>
                                _handlePostSelect(_posts.elementAt(index)),
                          );
                        },
                        childCount: _posts.length,
                      ),
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget createPostContainer() {
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
    _postVm.selectPost(null);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddPostScreen();
    }));
  }

  _handlePostSelect(Post post) {
    _postVm.selectPost(post);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return AddPostScreen();
    }));
  }
}