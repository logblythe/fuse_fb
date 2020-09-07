import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/view_models/post_view_model.dart';
import 'package:fuse/ui/base_widget.dart';
import 'package:fuse/ui/widgets/post_grid_view.dart';
import 'package:fuse/ui/widgets/post_text_input.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<dynamic> _images = List<dynamic>();
  final _controller = TextEditingController();
  bool _enablePosting = false;
  bool _enablePostingList = false;
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
      },
      builder: (context, model, child) {
        _images = _postVm.selectedImages;
        return Scaffold(
          appBar: AppBar(
            title: Text('Add post'),
            centerTitle: true,
            actions: [
              FlatButton(
                child: Text(
                  'Post',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed:
                    _enablePosting || _enablePostingList ? _handlePost : null,
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: CustomScrollView(
              slivers: [
                buildInput(),
                buildGridView(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            label: Text('Select Images'),
            icon: Icon(Icons.add),
            onPressed: _loadAssets,
          ),
        );
      },
    );
  }

  Widget buildInput() {
    return PostTextInput(
      controller: _controller,
      onChanged: _updateEnabledStatusOnInputChange,
    );
  }

  Widget buildGridView() {
    return PostGridView(
      images: _images,
      onRemove: _handleRemoveAsset,
    );
  }

  Future<void> _loadAssets() async {
    List<Asset> resultList = List<Asset>();
    List<Asset> pickedImages =
        List.from(_images.where((element) => element is Asset).toList());
    List<String> networkImages =
        List.from(_images.where((element) => element is String).toList());
    String error = 'No Error Detected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: pickedImages,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#2196F3",
          statusBarColor: "#2196F3",
          actionBarTitle: "Select images",
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
    if (resultList.isNotEmpty) {
      _images.addAll(resultList);
      _postVm.addSelectedImages([]..addAll(networkImages)..addAll(resultList));
      setState(() {
        _enablePostingList = true;
      });
    }
  }

  void _handlePost() {
    Post _post = Post(message: _controller.text);
    _postVm.addPost(_post);
    _postVm.goBack();
  }

  void _handleRemoveAsset(int index) {
    _postVm.removeSelectedImage(index);
    _updateEnabledStatusOnListChange();
  }

  void _updateEnabledStatusOnInputChange(value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        _enablePosting = true;
        _enablePostingList = _images.length > 0;
      });
      print('inside if $_enablePosting $_enablePostingList');
    } else {
      setState(() {
        _enablePosting = false;
        _enablePostingList = _images.length > 0;
      });
      print('inside else $_enablePosting $_enablePostingList');
    }
  }

  void _updateEnabledStatusOnListChange() {
    if (_images.length > 0) {
      setState(() {
        _enablePostingList = true;
        _enablePosting = _controller.text.trim().isNotEmpty;
      });
    } else {
      setState(() {
        _enablePostingList = false;
        _enablePosting = _controller.text.trim().isNotEmpty;
      });
    }
  }
}
