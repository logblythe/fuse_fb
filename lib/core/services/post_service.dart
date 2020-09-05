import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/models/quote_model.dart';
import 'package:fuse/core/services/api_service.dart';
import 'package:fuse/utils/utilities.dart';

class PostService {
  final ApiService _apiService;

  PostService({@required ApiService api}) : this._apiService = api;

  final StreamController _streamController = StreamController<List<Post>>();

  List<Post> _allPosts = [];
  List<Post> _paginatedPosts = [];
  List<Quote> _quotes;
  Post _selectedPost;
  int _startIndex = 0;
  int _lotSize = 50;

  get posts => _paginatedPosts;

  get selectedPost => _selectedPost;

  get postStream => _streamController.stream;

  fetchQuotes() {
    _apiService.get().then((value) {
      _quotes = List.from(value.map((it) => Quote.fromJson(it)));
      _allPosts = _quotes
          .asMap()
          .entries
          .map(
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
          )
          .toList()
          .sublist(0, TOTAL_SIZE);
      _paginatedPosts
          .addAll(_allPosts.sublist(_startIndex, _startIndex + _lotSize));
      _startIndex = _startIndex + _lotSize;
      _streamController.sink.add(_paginatedPosts);
    });
  }

  loadPostFromCache() {
    if (_startIndex < TOTAL_SIZE) {
      _paginatedPosts
          .addAll(_allPosts.sublist(_startIndex, _startIndex + _lotSize));
      _startIndex = _startIndex + _lotSize;
      _streamController.sink.add(_paginatedPosts);
    }
  }

  addPost(Post post) {
    _paginatedPosts.insert(0, post);
    _streamController.sink.add(_paginatedPosts);
  }

  selectPost(post) {
    _selectedPost = post;
  }

  updatePost(Post updatedPost) {
    int index = _paginatedPosts.indexOf(_selectedPost);
    _paginatedPosts[index] = updatedPost;
    _streamController.sink.add(_paginatedPosts);
  }

  dispose() {
    _streamController.close();
  }

  clearSelectedPost() {
    _selectedPost = null;
  }
}
