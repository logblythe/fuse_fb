import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/services/navigation_service.dart';
import 'package:fuse/core/services/post_service.dart';
import 'package:fuse/core/view_models/base_view_model.dart';

class PostViewModel extends BaseViewModel {
  final PostService postService;
  final NavigationService navigationService;

  PostViewModel({@required this.postService, @required this.navigationService});

  List<dynamic> _selectedImages = [];

  List<Post> get posts => postService.posts;

  Post get selectedPost => postService.selectedPost;

  Stream<List<Post>> get postsStream => postService.postStream;

  List<dynamic> get selectedImages => _selectedImages;

  onInit() {
    _selectedImages..addAll(selectedPost?.imageList ?? []);
  }

  void addPost(Post post) {
    postService.addPost(post..imageList = selectedImages);
  }

  void selectPost(Post post) {
    postService.selectPost(post);
  }

  void updatePost(Post updatedPost) {
    updatedPost.imageList = selectedImages;
    if (updatedPost != selectedPost) {
      postService.updatePost(updatedPost);
    }
  }

  void fetchQuotes() => postService.fetchQuotes();

  addSelectedImages(List<dynamic> assets) {
    selectedImages.clear();
    selectedImages.addAll(assets);
    notifyListeners();
  }

  void removeSelectedImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }

  void goBack() => navigationService.goBack();
}
