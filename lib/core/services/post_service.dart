import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/models/quote_model.dart';
import 'package:fuse/core/services/api_service.dart';

class PostService {
  final ApiService _apiService;

  PostService({@required ApiService api}) : this._apiService = api;

  final StreamController _streamController = StreamController<List<Post>>();

  List<Post> _posts = [];
  List<Quote> _quotes;
  Post _selectedPost;

  get posts => _posts;

  get selectedPost => _selectedPost;

  get postStream => _streamController.stream;

  fetchQuotes() {
    _apiService.get().then((value) {
      List<Quote> quotes = List.from(value.map((it) => Quote.fromJson(it)));
      _quotes = quotes.sublist(0, 50);
      _posts = _quotes.asMap().entries.map(
        (e) {
          int index = e.key;
          Quote quote = e.value;
          List<dynamic> imageUrls = [];
          if (index <= 8) {
            for (int i = 0; i < index; i++) {
              imageUrls.add("https://picsum.photos/300");
            }
          } else {
            for (int i = 0; i < index % 4; i++) {
              imageUrls.add("https://picsum.photos/300");
            }
          }
          return Post(message: quote.quote, imageList: imageUrls);
        },
      ).toList();
      _streamController.sink.add(_posts);
    });
  }

  addPost(Post post) {
    _posts.add(post);
    _streamController.sink.add(_posts);
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
