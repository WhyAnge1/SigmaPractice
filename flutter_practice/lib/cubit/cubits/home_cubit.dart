import 'package:event_bus_plus/res/res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/states/home_state.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';
import 'package:flutter_practice/services/user_service.dart';
import 'package:get/get.dart';

class HomeCubit extends Cubit<HomeState> {
  final _userService = getIt<UserService>();
  final _eventBus = getIt<EventBus>();

  HomeCubit() : super(InitialHomeState());

  Future loadCurrentUserData() async {
    var user = _userService.currentLoggedInUser;
    var reloadResult = await _userService.reloadUser();

    if (reloadResult.isSucceed && user != null) {
      emit(DefaultHomeState(
          username: user.displayName ?? "", email: user.email!));
    } else {
      emit(ErrorHomeState(errorMesage: 'userNotFoundPleaseReloginAgain'.tr));
    }
  }

//TODO: (Middle) change to emit OpenDrawerState to not to break cubit pattern
  Stream<OpenDrawerEvent> subscribeToEventBus() {
    return _eventBus.on<OpenDrawerEvent>();
  }
}
