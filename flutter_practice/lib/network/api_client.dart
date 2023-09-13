import 'package:dio/dio.dart';
import 'package:flutter_practice/helpers/result.dart';
import 'package:injectable/injectable.dart';

@singleton
class ApiClient {
  final Dio _dio = Dio();

  Future<Result<Response>> downloadFile(
      String uri, String downloadedFilePath) async {
    Result<Response> result;

    try {
      var response = await _dio.download(uri, downloadedFilePath);

      result = Result.fromResult(response);
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }

  @disposeMethod
  void dispose() {
    _dio.close(force: true);
  }
}
