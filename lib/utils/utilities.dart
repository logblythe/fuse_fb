import 'package:multi_image_picker/multi_image_picker.dart';

const int TOTAL_SIZE = 300;
const String QUOTES_URL = "https://type.fit/api/quotes";
const String LOREM_URL = "https://picsum.photos/300";

bool areListsEqual(var list1, var list2) {
  if (!(list1 is List && list2 is List) || list1.length != list2.length) {
    return false;
  }

  bool equals = true;
  for (int i = 0; i < list1.length; i++) {
    if (list1[i].runtimeType != list2[i].runtimeType) {
      equals = false;
      break;
    } else if (list1[i] is Asset) {
      for (Asset i in list1) {
        for (Asset j in list2) {
          if (i.identifier == j.identifier) {
            equals = true;
            break;
          } else {
            equals = false;
          }
        }
      }
    } else if (list1[i] is String) {
      for (String i in list1) {
        for (String j in list2) {
          if (i == j) {
            equals = true;
            break;
          } else {
            equals = false;
          }
        }
      }
    } else {
      equals = true;
    }
  }
  return equals;
}
