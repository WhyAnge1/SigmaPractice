class TextToSpeachState{
  bool isLoading = false;
  String? errorText;
  bool isAudioExist = false;
  bool isOnPause = true;
  bool shouldLogout = false;

  TextToSpeachState({this.isLoading = false, this.errorText, this.isAudioExist = false, this.isOnPause = true, this.shouldLogout = false});
}