import 'package:flutter/material.dart';
import 'package:flutter_practice/cubit/cubits/spider_stars_cubit.dart';
import 'package:flutter_practice/ui/controls/spider_star.dart';
import 'package:get/get.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';

class SpiderStarsPage extends StatefulWidget {
  const SpiderStarsPage({super.key});

  @override
  State createState() => _SpiderStarsPageState();
}

class _SpiderStarsPageState extends State<SpiderStarsPage>
    with AutomaticKeepAliveClientMixin {
  final _cubit = SpiderStarsCubit();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundSecondary,
          title: Text(
            'moveBlackCircle'.tr,
            style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: AppFonts.productSans,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            onPressed: _openDrawer,
            icon: const Icon(
              Icons.menu,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (_, constraints) => Container(
            width: constraints.widthConstraints().maxWidth,
            height: constraints.heightConstraints().maxHeight,
            color: AppColors.backgroundPrimary,
            child: const SpiderStar(),
          ),
        ),
      ),
    );
  }

  void _openDrawer() => _cubit.sendOpenDrawerEvent();
}
