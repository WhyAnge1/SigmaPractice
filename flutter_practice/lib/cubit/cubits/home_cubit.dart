import 'package:event_bus_plus/res/res.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/states/home_state.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/event_bus_events/update_current_user_data_event.dart';
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
      emit(UserDataHomeState(
          username: user.displayName ?? "",
          email: user.email!,
          imageUrl: user.photoURL));
    } else {
      emit(ErrorHomeState(errorMesage: 'userNotFoundPleaseReloginAgain'.tr));
    }
  }

  void subscribeToEvents() async {
    _eventBus.on<OpenDrawerEvent>().listen((event) {
      emit(OpenDrawerState());
    });
    _eventBus.on<UpdateCurrentUserDataEvent>().listen((event) {
      _updateCurrentUserData();
    });
  }

  void _updateCurrentUserData() {
    var user = _userService.currentLoggedInUser!;

    emit(UserDataHomeState(
        username: user.displayName ?? "",
        email: user.email!,
        imageUrl: user.photoURL));
  }
}
