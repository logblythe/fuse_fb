bool areListsEqual(var list1, var list2) {
  // check if both are lists
  if (!(list1 is List && list2 is List)
      // check if both have same length
      ||
      list1.length != list2.length) {
    return false;
  }

  // check if elements are equal
  for (int i = 0; i < list1.length; i++) {
    if (list1[i] != list2[i]) {
      return false;
    }
  }

  return true;
}
