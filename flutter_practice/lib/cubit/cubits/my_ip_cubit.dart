import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/states/my_ip_state.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/ip_service.dart';
import 'package:get/get.dart';

class MyIpCubit extends Cubit<MyIpState> {
  final _ipService = getIt<IpService>();

  MyIpCubit() : super(InitialMyIpState());

  Future getMyIp() async {
    emit(LoadingMyIpState());

    var ipResult = await _ipService.getIp();

    if (!(ipResult.result?.isBlank ?? true)) {
      emit(DataMyIpState(ip: ipResult.result!));
    } else {
      emit(ErrorMyIpState(errorMesage: 'systemErrorPleaseContactUs'.tr));
    }
  }
}