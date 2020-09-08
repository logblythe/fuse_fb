import 'package:multi_image_picker/multi_image_picker.dart';

const int TOTAL_SIZE = 200;
const String QUOTES_URL = "https://type.fit/api/quotes";
const String LOREM_URL = "https://picsum.photos/300";

bool areListsEqual(var list1, var list2) {
  if (!(list1 is List && list2 is List) || list1.length != list2.length) {
    return false;
  }

  bool equals = false;
  for (var i in list1) {
    for (var j in list2) {
      if (i.runtimeType == j.runtimeType) {
        if (i is String && i == j) {
          equals = true;
          break;
        } else if (i is Asset && i.identifier == j.identifier) {
          equals = true;
          break;
        }
      } else {
        equals = false;
      }
    }
  }
  return equals;
}
