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
    return Scaffold(
      appBar: AppBar(
        title: Text('Add post'),
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
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          loadAssets();
        },
      ),
    );
  }

  Widget _buildBody() {
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
        }
      },
      builder: (context, model, child) {
        return Column(
          children: [
            buildInput(),
            Expanded(child: buildGridView()),
          ],
        );
      },
    );
  }

  Widget buildGridView() {
    return GridView.count(
      padding: EdgeInsets.all(16),
      crossAxisCount: 3,
      children: List.generate(
        images.length,
        (index) {
          Asset asset = images[index];
          return AssetThumb(
            spinner: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            asset: asset,
            width: 300,
            height: 300,
          );
        },
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

    setState(
      () {
        images = resultList;
        _error = error;
        _enablePosting =
            resultList.length > 0 ? true : _controller.text.isNotEmpty;
      },
    );
  }

  void _handlePost() {
    Post _post = Post(message: _controller.text, images: images);
    if (_editMode) {
      _postVm.updatePost(_post);

/*      if (_post != _postVm.selectedPost) {
        _postVm.updatePost(_post);
      }*/
    } else {
      _postVm.addPost(_post);
    }

    // Navigator.pop(context);
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
}
