import 'package:multi_image_picker/multi_image_picker.dart';

class Post {
  String message;
  List<Asset> images;
  List<String> imageUrls;

  Post({this.message, this.images, this.imageUrls});
}
