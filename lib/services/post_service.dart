import 'dart:async';

import 'package:fuse/models/post_model.dart';

class PostService {
  PostService();

  final List<Post> _posts = [];
  final StreamController _streamController = StreamController<List<Post>>();

  Post _selectedPost;

  get posts => _posts;

  get selectedPost => _selectedPost;

  get postStream => _streamController.stream;

  addPost(Post post) {
    _posts.add(post);
    _streamController.sink.add(_posts);
    print('Posts length ${_posts.length}');
  }

  selectPost(post) {
    _selectedPost = post;
  }

  updatePost(Post updatedPost) {
    int index = _posts.indexOf(_selectedPost);
    _posts[index] = updatedPost;
    _streamController.sink.add(_posts);
  }

  dispose() {
    _streamController.close();
  }

  clearSelectedPost() {
    _selectedPost = null;
  }
}
