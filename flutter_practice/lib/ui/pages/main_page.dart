import 'package:flutter/material.dart';
import 'package:flutter_practice/ui/pages/comments_page.dart';
import 'package:flutter_practice/ui/pages/spider_starts_page.dart';
import 'package:flutter_practice/ui/pages/text_to_speach_page.dart';

import '../../misc/app_colors.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundWhite,
            border: Border.all(color: AppColors.unselectedGrey),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: TabBar(
            indicatorColor: Colors.transparent,
            labelColor: AppColors.textBlack,
            unselectedLabelColor: AppColors.unselectedGrey,
            controller: _tabController,
            tabs: const [
              Tab(icon: Icon(Icons.speaker)),
              Tab(icon: Icon(Icons.rate_review)),
              Tab(icon: Icon(Icons.brush_outlined)),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: const [
            TextToSpeachPage(),
            CommentsPage(),
            SpiderStarsPage()
          ],
        ),
      );
}
