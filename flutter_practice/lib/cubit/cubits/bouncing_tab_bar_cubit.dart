import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/states/bouncing_tab_bar_state.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';

class BouncingTabBarCubit extends Cubit<BouncingTabBarState> {
  final _eventBus = getIt<EventBus>();

  BouncingTabBarCubit() : super(InitialBouncingTabBarState());

  void sendOpenDrawerEvent() {
    _eventBus.fire(OpenDrawerEvent());
  }
}
