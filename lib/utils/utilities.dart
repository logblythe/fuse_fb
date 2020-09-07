import 'package:multi_image_picker/multi_image_picker.dart';

const int TOTAL_SIZE = 200;

bool areListsEqual(var list1, var list2) {
  if (!(list1 is List && list2 is List) || list1.length != list2.length) {
    return false;
  }
  if (list1.length == 0 && list2.length == 0) {
    return false;
  }

  bool equals = true;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i].runtimeType != list2[i].runtimeType) {
      equals = false;
      break;
    } else if (list1[i] is Asset) {
      if (list1[i].identifier != list2[i].identifier) {
        equals = false;
        break;
      }
    } else if (list1[i] is String) {
      if (list1[i] != list2[i]) {
        equals = false;
        break;
      }
    } else {
      equals = true;
    }
  }
  return equals;
}
