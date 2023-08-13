class ApiUrls {
  static String getTextToSpeachUrl(String apiKey, String value) =>
      "https://api.voicerss.org/?key=$apiKey&src=$value&hl=en-us&c=MP3&f=48khz_16bit_stereo";
}
