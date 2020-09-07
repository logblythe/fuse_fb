import 'dart:convert';
import 'dart:io';

import 'package:fuse/utils/utilities.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<dynamic> get() async {
    var responseJson;
    try {
      final response = await http.get(QUOTES_URL);
      responseJson = jsonDecode(response.body.toString());
    } on SocketException {
      throw Exception('No Internet connection');
    }
    return responseJson;
  }
}
