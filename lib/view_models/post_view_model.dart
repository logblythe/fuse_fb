import 'package:flutter/material.dart';
import 'package:fuse/models/post_model.dart';
import 'package:fuse/services/navigation_service.dart';
import 'package:fuse/services/post_service.dart';
import 'package:fuse/view_models/base_view_model.dart';

class PostViewModel extends BaseViewModel {
  final PostService postService;
  final NavigationService navigationService;

  PostViewModel({@required this.postService, @required this.navigationService});

  List<Post> get posts => postService.posts;

  Post get selectedPost => postService.selectedPost;

  Stream<List<Post>> get postsStream => postService.postStream;

  void addPost(Post post) {
    postService.addPost(post);
    navigationService.goBack();
  }

  void selectPost(Post post) {
    postService.selectPost(post);
  }

  void updatePost(Post updatedPost) {
    postService.updatePost(updatedPost);
  }

  void goBack() => navigationService.goBack();

  void fetchQuotes() => postService.fetchQuotes();

  @override
  void dispose() {
    postService.clearSelectedPost();
    super.dispose();
  }
}
