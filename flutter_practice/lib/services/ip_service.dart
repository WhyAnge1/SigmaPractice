import 'package:flutter_practice/helpers/result.dart';
import 'package:flutter_practice/misc/api_urls.dart';
import 'package:flutter_practice/network/api_client.dart';
import 'package:flutter_practice/repository/models/ip_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class IpService {
  final ApiClient _apiClient;

  IpService(ApiClient apiClient) : _apiClient = apiClient;

  Future<Result<String>> getIp() async {
    Result<String> result;

    try {
      final apiResult = await _apiClient.get(ApiUrls.getIpUrl());

      if (apiResult.isSucceed && apiResult.result?.data != null) {
        var ip = IpModel.fromJson(apiResult.result!.data);

        result = Result.fromResult(ip.ip);
      } else {
        result = Result.fromFailur();
      }
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }
}
