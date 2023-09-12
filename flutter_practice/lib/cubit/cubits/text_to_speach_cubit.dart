import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/misc/constants.dart';
import 'package:flutter_practice/network/api_client.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

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

  @override
  Future<void> close() {
    _apiClient.close();
    _player.dispose();

    return super.close();
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
    _isAudioExist = false;
    _isOnPause = true;
    _player.stop();

    _emit(isLoading: true);

    if (textToConvert.isEmpty) {
      _emit(errorText: 'emptyTextError'.tr);
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

          _emit();
        } else {
          _emit(errorText: 'textToSpeachConvertionNotAvailableError'.tr);
        }
      } catch (ex) {
        _emit(errorText: 'systemErrorPleaseContactUs'.tr);
      }
    }
  }

  void _emit({String? errorText, bool isLoading = false}) {
    emit(TextToSpeachState(
        isLoading: isLoading,
        errorText: errorText,
        isAudioExist: _isAudioExist,
        isOnPause: _isOnPause));
  }
}
