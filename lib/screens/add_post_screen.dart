import 'package:flutter/material.dart';
import 'package:fuse/base_widget.dart';
import 'package:fuse/models/post_model.dart';
import 'package:fuse/view_models/post_view_model.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _controller = TextEditingController();
  List<Asset> images = List<Asset>();
  String _error = 'No Error Detected';
  bool _enablePosting = false;
  bool _editMode = false;
  PostViewModel _postVm;

  @override
  Widget build(BuildContext context) {
    return BaseWidget<PostViewModel>(
      model: PostViewModel(
        navigationService: Provider.of(context),
        postService: Provider.of(context),
      ),
      onModelReady: (model) {
        _postVm = model;
        _editMode = _postVm.selectedPost != null;
        if (_editMode) {
          _controller.text = _postVm.selectedPost.message;
          images = _postVm.selectedPost.images;
        }
      },
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('${_editMode ? 'Edit' : 'Add'} post'),
            actions: [
              FlatButton(
                child: Text(
                  "Post",
                  style: TextStyle(color: Colors.white),
                ),
                textColor: Colors.black,
                disabledTextColor: Colors.red,
                disabledColor: Colors.yellow,
                onPressed: _enablePosting ? _handlePost : null,
              ),
            ],
          ),
          body: Column(
            children: [
              buildInput(),
              Expanded(child: buildGridView()),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              loadAssets();
            },
          ),
        );
      },
    );
  }

  buildInput() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        minLines: 5,
        maxLines: 10,
        controller: _controller,
        decoration: InputDecoration(
            hintText: "What\'s on your mind?",
            border: const OutlineInputBorder(),
            hintStyle: Theme.of(context).textTheme.headline6),
        onChanged: (value) {
          if (value.isEmpty && images.length == 0) {
            setState(() {
              _enablePosting = false;
            });
          } else {
            setState(() {
              _enablePosting = true;
            });
          }
        },
      ),
    );
  }

  Widget buildGridView() {
    List<dynamic> _images = []
      ..addAll(_postVm.selectedPost?.images?.toList() ?? [])
      ..addAll(_postVm.selectedPost?.imageUrls?.toList() ?? [])
      ..addAll(_postVm.selectedImages);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: List.generate(
          _images.length,
          (index) {
            return Stack(
              children: [
                _images[index] is String
                    ? Image.network(_images[index])
                    : AssetThumb(
                        asset: _images[index],
                        width: 300,
                        height: 300,
                        spinner: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    iconSize: 36,
                    icon: Icon(Icons.cancel),
                    color: Colors.white,
                    onPressed: () {
                      _handleRemoveAsset(index);
                    },
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2196F3",
          statusBarColor: "#2196F3",
          actionBarTitle: "Fuse",
          allViewTitle: "All Photos",
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
      print(error);
    }

    if (!mounted) return;

    _postVm.addImages(resultList);
    /* setState(
      () {
        images = resultList;
        _error = error;
        _enablePosting =
            resultList.length > 0 ? true : _controller.text.isNotEmpty;
      },
    );*/
  }

  void _handlePost() {
    Post _post = Post(message: _controller.text, images: images);
    if (_editMode) {
      _postVm.updatePost(_post);
      _postVm.goBack();
/*      if (_post != _postVm.selectedPost) {
        _postVm.updatePost(_post);
      }*/
    } else {
      _postVm.addPost(_post);
    }
  }

  _handleRemoveAsset(int index) {
    if (!(images.length == 1 && _controller.text.isEmpty)) {
      setState(
        () {
          images.removeAt(index);
          images = images;
          _error = _error;
          _enablePosting =
              images.length > 0 ? true : _controller.text.isNotEmpty;
        },
      );
      // Post _post = Post(message: _controller.text, images: images);
      // _postVm.updatePost(_post);
    }
  }
}
