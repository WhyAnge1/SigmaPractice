import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/states/spider_stars_state.dart';
import 'package:flutter_practice/event_bus_events/open_drawer_event.dart';
import 'package:flutter_practice/misc/injection_configurator.dart';

class SpiderStarsCubit extends Cubit<SpiderStarsState> {
  final _eventBus = getIt<EventBus>();

  SpiderStarsCubit() : super(InitialSpiderStarsState());

  void sendOpenDrawerEvent() {
    _eventBus.fire(OpenDrawerEvent());
  }
}
