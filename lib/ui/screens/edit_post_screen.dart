import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fuse/core/models/post_model.dart';
import 'package:fuse/core/view_models/post_view_model.dart';
import 'package:fuse/ui/base_widget.dart';
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
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: TextField(
          textInputAction: TextInputAction.done,
          minLines: 5,
          maxLines: 10,
          controller: _controller,
          decoration: InputDecoration(
            hintText: "What\'s on your mind?",
            border: const OutlineInputBorder(),
            hintStyle: Theme.of(context).textTheme.headline6,
          ),
          onChanged: (value) {
            if (value.trim() != _postVm.selectedPost?.message) {
              setState(() {
                _enablePostingList =
                    !areListsEqual(_imagesCopy, _images) && _images.length > 0;
                _enablePosting = value.trim().isNotEmpty || _images.length > 0;
              });
              print('inside if $_enablePosting $_enablePostingList');
            } else {
              setState(() {
                _enablePosting = false;
                _enablePostingList =
                    !areListsEqual(_imagesCopy, _images) && _images.length > 0;
              });
              print('inside else $_enablePosting $_enablePostingList');
            }
          },
        ),
      ),
    );
  }

  Widget buildGridView() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: List.generate(
          _images.length,
          (index) {
            return Stack(
              children: [
                _images[index] is String
                    ? CachedNetworkImage(
                        imageUrl: _images[index],
                        height: 300,
                        progressIndicatorBuilder: (ctx, url, progress) {
                          return Center(child: CircularProgressIndicator());
                        },
                        errorWidget: (context, url, error) {
                          return Icon(Icons.error);
                        },
                      )
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
                    color: Colors.red,
                    onPressed: () => _handleRemoveAsset(index),
                  ),
                )
              ],
            );
          },
        ),
      ),
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
      if (areListsEqual(_imagesCopy, _images)) {
        setState(() {
          _enablePostingList = false;
          _enablePosting = _controller.text.trim().isNotEmpty &&
              _controller.text.trim() != _postVm.selectedPost?.message;
        });
        print('for list inside if $_enablePosting $_enablePostingList');
      } else {
        setState(() {
          // _enablePostingList = true && _images.length > 0;
          _enablePosting = _controller.text.trim().isNotEmpty &&
              _controller.text.trim() != _postVm.selectedPost?.message;
          _enablePostingList = _controller.text.trim().isNotEmpty
              ? true
              : _images.length > 0 ? true : false;
          // _enablePostingList = true;
        });
        print('for list inside else $_enablePosting $_enablePostingList');
      }
    }
  }

  void _handlePost() {
    Post _post = Post(message: _controller.text);
    _postVm.updatePost(_post);
    _postVm.goBack();
  }

  void _handleRemoveAsset(int index) {
    _postVm.removeSelectedImage(index);
    if (areListsEqual(_imagesCopy, _images)) {
      setState(() {
        _enablePostingList = false;
        _enablePosting = _controller.text.trim().isNotEmpty &&
            _controller.text.trim() != _postVm.selectedPost?.message;
      });
      print('for list inside if $_enablePosting $_enablePostingList');
    } else {
      setState(() {
        // _enablePostingList = true && _images.length > 0;
        _enablePosting = _controller.text.trim().isNotEmpty &&
            _controller.text.trim() != _postVm.selectedPost?.message;
        _enablePostingList = _controller.text.trim().isNotEmpty
            ? true
            : _images.length > 0 ? true : false; // _enablePostingList = true;
      });
      print('for list inside else $_enablePosting $_enablePostingList');
    }
  }
}
