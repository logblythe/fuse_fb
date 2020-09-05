import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fuse/base_widget.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/view_models/post_view_model.dart';
import 'package:fuse/ui/widgets/circle_image.dart';
import 'package:fuse/ui/widgets/post_card.dart';
import 'package:fuse/utils/utilities.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Facebook')),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) {
    return BaseWidget<PostViewModel>(
      model: PostViewModel(
        navigationService: Provider.of(context),
        postService: Provider.of(context),
      ),
      onModelReady: (model) {
        model.fetchQuotes();
        initListener(model);
      },
      builder: (context, model, child) {
        return Container(
          color: Colors.grey.withOpacity(0.2),
          padding: const EdgeInsets.all(12),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(child: createPostContainer(context, model)),
              StreamBuilder<List<Post>>(
                stream: model.postsStream,
                initialData: [],
                builder: (context, snapshot) {
                  if (snapshot.data.isNotEmpty) {
                    var data = snapshot.data;
                    List<Post> _posts = data;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Column(
                            children: [
                              PostCard(
                                post: _posts.elementAt(index),
                                onPostSelect: () => _handlePostSelect(
                                    model, _posts.elementAt(index)),
                              ),
                              index == _posts.length - 1
                                  ? Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16.0),
                                      child: index == 199
                                          ? Text(
                                              "Reached end of the list i.e $TOTAL_SIZE items")
                                          : CircularProgressIndicator(),
                                    )
                                  : Container(),
                            ],
                          );
                        },
                        childCount: _posts.length,
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildListDelegate([
                        SizedBox(height: 24),
                        Center(child: CircularProgressIndicator()),
                        SizedBox(height: 24),
                        Center(child: Text('Please wait, fetching the posts')),
                      ]),
                    );
                  }
                },
              )
            ],
          ),
        );
      },
    );
  }

  Widget createPostContainer(BuildContext context, PostViewModel model) {
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
              onTap: () => _handleCreatePost(model),
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

  _handleCreatePost(PostViewModel model) {
    model.selectPost(null);
  }

  _handlePostSelect(PostViewModel model, Post post) {
    model.selectPost(post);
  }

  void initListener(PostViewModel model) {
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          Future.delayed(Duration(seconds: 3))
              .then((value) => model.loadPostFromCache());
        }
      },
    );
  }
}
