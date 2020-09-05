import 'package:fuse/utils/utilities.dart';

class Post {
  String message;
  List<dynamic> imageList;

  Post({this.message, this.imageList});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          areListsEqual(imageList, other.imageList);

  @override
  int get hashCode => message.hashCode ^ imageList.hashCode;
}
