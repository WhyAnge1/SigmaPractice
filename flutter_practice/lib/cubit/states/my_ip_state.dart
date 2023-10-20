abstract class MyIpState {}

class InitialMyIpState extends MyIpState {}

class ErrorMyIpState extends MyIpState {
  final String errorMesage;

  ErrorMyIpState({required this.errorMesage});
}

class DataMyIpState extends MyIpState {
  final String ip;

  DataMyIpState({required this.ip});
}

class LoadingMyIpState extends MyIpState {}
