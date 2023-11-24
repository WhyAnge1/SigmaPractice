import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_practice/cubit/cubits/home_cubit.dart';
import 'package:flutter_practice/cubit/states/home_state.dart';
import 'package:flutter_practice/misc/app_fonts.dart';
import 'package:flutter_practice/ui/pages/account_settings_page.dart';
import 'package:flutter_practice/ui/pages/bouncing_tab_bar_page.dart';
import 'package:flutter_practice/ui/pages/comments_page.dart';
import 'package:flutter_practice/ui/pages/my_ip_page.dart';
import 'package:flutter_practice/ui/pages/spider_starts_page.dart';
import 'package:flutter_practice/ui/pages/text_to_speach_page.dart';
import 'package:get/get.dart';

import '../../misc/app_colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AfterLayoutMixin<HomePage>, TickerProviderStateMixin {
  final _cubit = HomeCubit();
  final _pageController = PageController();
  final drawerPages = const [
    TextToSpeachPage(),
    CommentsPage(),
    SpiderStarsPage(),
    MyIpPage(),
    BouncingTabBarPage(),
    AccountSettingsPage(),
  ];
  final drawerListCells = [
    (
      title: 'convertAnyTextToAudio'.tr,
      icon: Icons.speaker,
      type: TextToSpeachPage
    ),
    (title: 'comments'.tr, icon: Icons.rate_review, type: CommentsPage),
    (
      title: 'moveBlackCircle'.tr,
      icon: Icons.brush_outlined,
      type: SpiderStarsPage
    ),
    (title: 'myIp'.tr, icon: Icons.settings_input_antenna, type: MyIpPage),
    (title: 'bouncingTabBar'.tr, icon: Icons.circle, type: BouncingTabBarPage),
    (
      title: 'accountSettings'.tr,
      icon: Icons.person,
      type: AccountSettingsPage
    ),
  ];
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  int _selectedPageIndex = 0;

  @override
  void afterFirstLayout(BuildContext context) {
    _cubit.loadCurrentUserData();
  }

  @override
  void initState() {
    _cubit.subscribeToEventBus().listen((event) {
      _openDrawer();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      bloc: _cubit,
      listener: _homePageConsumerListener,
      child: Scaffold(
        key: _key,
        backgroundColor: AppColors.backgroundPrimary,
        body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            children: drawerPages),
        drawer: Drawer(
          backgroundColor: AppColors.backgroundPrimary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundSecondary,
                ),
                padding: const EdgeInsets.all(10),
                child: BlocBuilder<HomeCubit, HomeState>(
                  bloc: _cubit,
                  buildWhen: (previous, current) =>
                      current is InitialHomeState ||
                      current is DefaultHomeState,
                  builder: _homePageConsumerBuilder,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  physics: const ClampingScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: drawerListCells.length,
                  itemBuilder: (context, index) => ListTile(
                    selectedTileColor: AppColors.backgroundSelected,
                    selected: _selectedPageIndex == index,
                    title: Text(
                      drawerListCells[index].title,
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontFamily: AppFonts.productSans,
                          fontSize: 16),
                    ),
                    leading: Icon(drawerListCells[index].icon,
                        color: AppColors.textPrimary),
                    onTap: () => openPage(context, drawerListCells[index].type),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _homePageConsumerListener(BuildContext context, HomeState state) {
    if (state is ErrorHomeState) {
      Get.snackbar('error'.tr, state.errorMesage);
    }
  }

  Widget _homePageConsumerBuilder(BuildContext context, HomeState state) {
    return state is DefaultHomeState
        ? Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.username,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: AppFonts.productSans,
                    fontSize: 22),
              ),
              Text(
                state.email,
                style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontFamily: AppFonts.productSans,
                    fontSize: 16),
              ),
            ],
          )
        : Container();
  }

  void openPage(BuildContext context, Type type) {
    var pageIndex =
        drawerPages.indexWhere((element) => element.runtimeType == type);
    _selectedPageIndex = pageIndex;
    _pageController.jumpToPage(pageIndex);

    Navigator.pop(context);
  }

  void _openDrawer() {
    _key.currentState?.openDrawer();
  }
}
