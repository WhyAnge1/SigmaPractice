import 'package:dio/dio.dart';
import 'package:flutter_practice/helpers/result.dart';

class ApiClient {
  final Dio _dio = Dio();

  Future<Result<Response>> downloadFile(
      String uri, String downloadedFilePath) async {
    try {
      var response = await _dio.download(uri, downloadedFilePath);

      return Result<Response>(result: response);
    } catch (ex) {
      return Result(occurredError: ex);
    }
  }

  void close() => _dio.close(force: true);
}
