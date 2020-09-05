import 'package:flutter/material.dart';
import 'package:fuse/utils/enums.dart';

class BaseViewModel extends ChangeNotifier {
  bool _isDisposed = false;
  Status status;
  dynamic _error;
  dynamic _dialogContent;

  get dialogContent => _dialogContent;

  get error => _error;

  get loading => status == Status.LOADING;

  setLoading() {
    status = Status.LOADING;
    if (!_isDisposed) notifyListeners();
  }

  setPaginating() {
    status = Status.PAGINATING;
    if (!_isDisposed) notifyListeners();
  }

  setCompleted() {
    status = Status.COMPLETED;
    if (!_isDisposed) notifyListeners();
  }

  setError(error) {
    _error = error;
    status = Status.ERROR;
    if (!_isDisposed) notifyListeners();
  }

  setDialogContent(content) {
    _dialogContent = content;
    status = Status.DIALOG_CONTENT;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
