import 'package:flutter_practice/helpers/result.dart';
import 'package:flutter_practice/misc/api_urls.dart';
import 'package:flutter_practice/misc/constants.dart';
import 'package:flutter_practice/network/api_client.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';

@injectable
class TextConvertionService {
  final ApiClient _apiClient;

  TextConvertionService(ApiClient apiClient) : _apiClient = apiClient;

  Future<Result<String>> convertTextToSpeach(String textToConvert) async {
    Result<String> result;

    try {
      final downloadedFileDirectory = await getTemporaryDirectory();
      final downloadedFilePath = "${downloadedFileDirectory.path}tts.mp3";

      final downloadResult = await _apiClient.downloadFile(
          ApiUrls.getTextToSpeachUrl(
              Constants.textToSpeachApiKey, textToConvert),
          downloadedFilePath);

      if (downloadResult.hasResult &&
          downloadResult.result?.statusCode == 200) {
        result = Result.fromResult(downloadedFilePath);
      } else {
        result = Result.fromFailur();
      }
    } catch (ex) {
      result = Result.fromError(ex);
    }

    return result;
  }
}
