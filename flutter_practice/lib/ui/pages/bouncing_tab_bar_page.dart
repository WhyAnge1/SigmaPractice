import 'package:flutter/material.dart';
import 'package:flutter_practice/cubit/cubits/bouncing_tab_bar_cubit.dart';
import 'package:flutter_practice/misc/app_colors.dart';
import 'package:flutter_practice/misc/app_fonts.dart';
import 'package:flutter_practice/ui/controls/bounce_tabbar/bounce_tabbar.dart';
import 'package:get/get.dart';

class BouncingTabBarPage extends StatefulWidget {
  const BouncingTabBarPage({super.key});

  @override
  State createState() => _BouncingTabBarPageState();
}

class _BouncingTabBarPageState extends State<BouncingTabBarPage>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final _cubit = BouncingTabBarCubit();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();

    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundSecondary,
        title: Text(
          'bouncingTabBar'.tr,
          style: const TextStyle(
              color: AppColors.textPrimary,
              fontFamily: AppFonts.productSans,
              fontSize: 22,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: _openDrawer,
          icon: const Icon(Icons.menu, color: AppColors.textPrimary),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Container(
            color: AppColors.backgroundPrimary,
            child: const Icon(
              Icons.directions_car,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            color: AppColors.backgroundPrimary,
            child: const Icon(
              Icons.directions_transit,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            color: AppColors.backgroundPrimary,
            child: const Icon(
              Icons.directions_bike,
              color: AppColors.textPrimary,
            ),
          ),
          Container(
            color: AppColors.backgroundPrimary,
            child: const Icon(
              Icons.directions_boat,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          color: AppColors.backgroundPrimary,
          child: BounceTabBar(
            color: AppColors.backgroundSecondary,
            tabBar: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: AppColors.textPrimary,
              tabs: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.directions_car),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.directions_transit),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.directions_bike),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(Icons.directions_boat),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openDrawer() => _cubit.sendOpenDrawerEvent();
}
