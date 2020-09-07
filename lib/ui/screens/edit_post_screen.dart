import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/view_models/post_view_model.dart';
import 'package:fuse/ui/base_widget.dart';
import 'package:fuse/ui/widgets/post_grid_view.dart';
import 'package:fuse/ui/widgets/post_text_input.dart';
import 'package:fuse/utils/utilities.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

class EditPostScreen extends StatefulWidget {
  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final _controller = TextEditingController();
  List<dynamic> _images = List<dynamic>();
  List<dynamic> _imagesCopy = List<dynamic>();
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
        _postVm.onInit();
        _imagesCopy = _postVm.selectedPost?.imageList ?? [];
        _controller.text = _postVm.selectedPost?.message;
      },
      builder: (context, model, child) {
        _images = _postVm.selectedImages;
        return Scaffold(
          appBar: AppBar(
            title: Text('Edit post'),
            centerTitle: true,
            actions: [
              FlatButton(
                child: Text(
                  'Update',
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
    if (resultList.isNotEmpty) {
      _images.addAll(resultList);
      _postVm.addSelectedImages([]..addAll(networkImages)..addAll(resultList));
      _updateEnabledStatusOnListChange();
    }
  }

  void _handlePost() {
    Post _post = Post(message: _controller.text);
    _postVm.updatePost(_post);
    _postVm.goBack();
  }

  void _handleRemoveAsset(int index) {
    _postVm.removeSelectedImage(index);
    _updateEnabledStatusOnListChange();
  }

  void _updateEnabledStatusOnInputChange(value) {
    if (value.trim() != _postVm.selectedPost?.message) {
      setState(() {
        _enablePostingList =
            !areListsEqual(_imagesCopy, _images) && _images.length > 0;
        _enablePosting = value.trim().isNotEmpty || _images.length > 0;
      });
    } else {
      setState(() {
        _enablePosting = false;
        _enablePostingList =
            !areListsEqual(_imagesCopy, _images) && _images.length > 0;
      });
    }
  }

  void _updateEnabledStatusOnListChange() {
    if (areListsEqual(_imagesCopy, _images)) {
      setState(() {
        _enablePostingList = false;
        _enablePosting = _controller.text.trim().isNotEmpty &&
            _controller.text.trim() != _postVm.selectedPost?.message;
      });
    } else {
      setState(() {
        _enablePosting = _controller.text.trim().isNotEmpty &&
            _controller.text.trim() != _postVm.selectedPost?.message;
        _enablePostingList = _controller.text.trim().isNotEmpty
            ? true
            : _images.length > 0 ? true : false; // _enablePostingList = true;
      });
    }
  }
}
