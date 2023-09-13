abstract class TextToSpeachState {
  final bool shouldBuild;

  TextToSpeachState({this.shouldBuild = true});
}

class InitialTextToSpeachState extends TextToSpeachState {}

class ErrorTextToSpeachState extends TextToSpeachState {
  final String errorMesage;

  ErrorTextToSpeachState({required this.errorMesage})
      : super(shouldBuild: false);
}

class AudioTextToSpeachState extends TextToSpeachState {
  final bool isOnPause;

  AudioTextToSpeachState({required this.isOnPause});
}

class LoadingTextToSpeachState extends TextToSpeachState {
  LoadingTextToSpeachState() : super(shouldBuild: false);
}
