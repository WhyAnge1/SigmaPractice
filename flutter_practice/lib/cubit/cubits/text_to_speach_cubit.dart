import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/constants.dart';
import 'package:flutter_practice/misc/user_info.dart';
import 'package:flutter_practice/network/api_client.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../misc/api_urls.dart';
import '../states/text_to_speach_state.dart';

class TextToSpeachCubit extends Cubit<TextToSpeachState> {
  final _apiClient = ApiClient();
  final _player = AudioPlayer();
  bool _isAudioExist = false;
  bool _isOnPause = true;

  TextToSpeachCubit() : super(TextToSpeachState()) {
    _player.setVolume(1);
    _player.setReleaseMode(ReleaseMode.stop);
    _player.onPlayerComplete.listen((_) {
      _isOnPause = true;
      _emit();
    });
  }

  void dispose() {
    _apiClient.close();
    _player.dispose();
  }

  Future logout() async {
    final prefferences = await SharedPreferences.getInstance();
    prefferences.remove(Constants.autoLoginEmailPreffName);
    UserInfo.clearLoggenInUser();

    _emit(shouldLogout: true);
  }

  void playAudioFile() {
    _player.resume();
    _isOnPause = false;

    _emit();
  }

  void pauseAudioFile() {
    _player.pause();
    _isOnPause = true;

    _emit();
  }

  Future convertTextToSpeach(String textToConvert) async {
    String? errorText;
    _isAudioExist = false;
    _isOnPause = true;
    _player.stop();

    _emit(isLoading: true);

    if (textToConvert.isEmpty) {
      errorText = 'emptyTextError'.tr;
    } else {
      try {
        final downloadedFileDirectory = await getTemporaryDirectory();
        final downloadedFilePath = "${downloadedFileDirectory.path}tts.mp3";

        final downloadResult = await _apiClient.downloadFile(
            ApiUrls.getTextToSpeachUrl(
                Constants.textToSpeachApiKey, textToConvert),
            downloadedFilePath);

        if (downloadResult.isSucceed &&
            downloadResult.result?.statusCode == 200) {
          _player.setSource(DeviceFileSource(downloadedFilePath));

          _isAudioExist = true;
        } else {
          errorText = 'textToSpeachConvertionNotAvailableError'.tr;
        }
      } catch (ex) {
        errorText = 'systemErrorPleaseContactUs'.tr;
      }
    }

    _emit(errorText: errorText);
  }

  void _emit(
      {String? errorText, bool shouldLogout = false, bool isLoading = false}) {
    emit(TextToSpeachState(
        isLoading: isLoading,
        errorText: errorText,
        isAudioExist: _isAudioExist,
        isOnPause: _isOnPause,
        shouldLogout: shouldLogout));
  }
}
