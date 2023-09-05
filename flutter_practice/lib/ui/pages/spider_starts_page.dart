import 'package:flutter/material.dart';
import 'package:flutter_practice/ui/controls/spider_star.dart';
import 'package:get/get.dart';

import '../../misc/app_colors.dart';
import '../../misc/app_fonts.dart';
import 'account_settings_page.dart';

class SpiderStarsPage extends StatefulWidget {
  const SpiderStarsPage({super.key});

  @override
  State createState() => _SpiderStarsPageState();
}

class _SpiderStarsPageState extends State<SpiderStarsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.backgroundWhite,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundWhite,
          shadowColor: Colors.transparent,
          title: Text('moveBlackCircle'.tr,
              style: const TextStyle(
                  color: AppColors.textBlack,
                  fontFamily: AppFonts.productSans,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
              onPressed: _onAccountPressed,
              icon: const Icon(
                Icons.person,
                color: AppColors.textBlack,
              )),
        ),
        body: LayoutBuilder(
          builder: (_, constraints) => Container(
            width: constraints.widthConstraints().maxWidth,
            height: constraints.heightConstraints().maxHeight,
            color: AppColors.backgroundWhite,
            child: const SpiderStar(),
          ),
        ),
      );

  Future _onAccountPressed() async => await Get.to(const AccountSettingsPage());
}
