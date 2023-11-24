import 'package:audioplayers/audioplayers.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/text_convertion_service.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../states/text_to_speach_state.dart';

class TextToSpeachCubit extends Cubit<TextToSpeachState> {
  final _textConvertionService = getIt<TextConvertionService>();
  final _internetConnectionChecker = getIt<InternetConnectionChecker>();
  final _player = AudioPlayer();
  final _eventBus = getIt<EventBus>();

  TextToSpeachCubit() : super(InitialTextToSpeachState()) {
    _player.setVolume(1);
    _player.setReleaseMode(ReleaseMode.stop);
    _player.onPlayerComplete.listen((_) {
      emit(AudioTextToSpeachState(isOnPause: true));
    });
  }

  @override
  Future<void> close() {
    _player.dispose();

    return super.close();
  }

  void playAudioFile() {
    _player.resume();

    emit(AudioTextToSpeachState(isOnPause: false));
  }

  void pauseAudioFile() {
    _player.pause();

    emit(AudioTextToSpeachState(isOnPause: true));
  }

  Future convertTextToSpeach(String textToConvert) async {
    _player.stop();

    emit(LoadingTextToSpeachState());

    if (textToConvert.isEmpty) {
      emit(ErrorTextToSpeachState(errorMesage: 'emptyTextError'.tr));
    } else {
      var hasInternetConnection =
          await _internetConnectionChecker.hasConnection;

      if (hasInternetConnection) {
        var convertionResult =
            await _textConvertionService.convertTextToSpeach(textToConvert);

        if (convertionResult.hasResult) {
          _player.setSource(DeviceFileSource(convertionResult.result!));

          emit(AudioTextToSpeachState(isOnPause: true));
        } else if (convertionResult.hasFailedWithoutError) {
          emit(ErrorTextToSpeachState(
              errorMesage: 'textToSpeachConvertionNotAvailableError'.tr));
        } else {
          emit(ErrorTextToSpeachState(
              errorMesage: 'systemErrorPleaseContactUs'.tr));
        }
      } else {
        emit(ErrorTextToSpeachState(
            errorMesage: 'noInternetConnectionError'.tr));
      }
    }
  }

  void sendOpenDrawerEvent() {
    _eventBus.fire(OpenDrawerEvent());
  }
}
