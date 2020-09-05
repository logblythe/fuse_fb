import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/services/navigation_service.dart';
import 'package:fuse/core/services/post_service.dart';
import 'package:fuse/core/view_models/base_view_model.dart';
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
    postService.addPost(post..images = selectedImages);
    navigationService.goBack();
  }

  void selectPost(Post post) {
    postService.selectPost(post);
  }

  void updatePost(Post updatedPost) {
    postService.updatePost(updatedPost..images = selectedImages);
  }

  void goBack() => navigationService.goBack();

  void fetchQuotes() => postService.fetchQuotes();

  addImages(List<Asset> assets) {
    selectedImages.clear();
    selectedImages.addAll(assets);
    notifyListeners();
  }

  void removeSelectedImage(int index) {
    selectedImages.removeAt(index);
    notifyListeners();
  }
}
