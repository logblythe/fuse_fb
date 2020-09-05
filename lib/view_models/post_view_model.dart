import 'package:flutter/material.dart';
import 'package:fuse/models/post_model.dart';
import 'package:fuse/services/navigation_service.dart';
import 'package:fuse/services/post_service.dart';
import 'package:fuse/view_models/base_view_model.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PostViewModel extends BaseViewModel {
  final PostService postService;
  final NavigationService navigationService;

  PostViewModel({@required this.postService, @required this.navigationService});

  List<Asset> _selectedImages = [];

  List<Post> get posts => postService.posts;

  Post get selectedPost => postService.selectedPost;

  Stream<List<Post>> get postsStream => postService.postStream;

  List<Asset> get selectedImages => _selectedImages;

  void addPost(Post post) {
    post.images = selectedImages;
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

  addImages(List<Asset> assets) {
    selectedImages.addAll(assets);
    notifyListeners();
  }

// @override
// void dispose() {
//   postService.clearSelectedPost();
//   super.dispose();
// }
}
