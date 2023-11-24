import 'package:flutter/material.dart';
import 'package:flutter_practice/ui/controls/bounce_tabbar/bounce_tabbar_painter.dart';

class BounceTabBar extends StatefulWidget {
  final TabBar tabBar;
  final Color color;
  final Duration ballAnimationDuration;

  const BounceTabBar({
    super.key,
    required this.tabBar,
    required this.color,
    this.ballAnimationDuration = const Duration(milliseconds: 450),
  });

  @override
  State<StatefulWidget> createState() => _BounceTabBarState();
}

class _BounceTabBarState extends State<BounceTabBar>
    with TickerProviderStateMixin {
  late AnimationController _drawingAnimationController;
  late Animation<double> _drawingAnimation;
  late AnimationController _fadeInAnimationController;
  late Animation<double> _fadeInAnimation;
  late AnimationController _fadeOutAnimationController;
  late Animation<double> _fadeOutAnimation;
  var currentIndex = 0;
  var oldIndex = 0;
  var isAnimationInProgress = false;

  @override
  void dispose() {
    _drawingAnimationController.dispose();
    _fadeInAnimationController.dispose();
    _fadeOutAnimationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    widget.tabBar.controller?.addListener(_tabBarControllerListener);

    _drawingAnimationController = AnimationController(
      duration: widget.ballAnimationDuration,
      vsync: this,
    );
    _drawingAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: _drawingAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    final fadeAnimationDuration = Duration(
        milliseconds:
            (widget.ballAnimationDuration.inMilliseconds * 0.8).round());
    _fadeInAnimationController = AnimationController(
      duration: fadeAnimationDuration,
      vsync: this,
    );
    _fadeInAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(_fadeInAnimationController);

    _fadeOutAnimationController = AnimationController(
      duration: fadeAnimationDuration,
      vsync: this,
    );
    _fadeOutAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_fadeOutAnimationController);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _drawingAnimation,
      builder: (BuildContext context, Widget? child) {
        return IgnorePointer(
          ignoring: isAnimationInProgress,
          child: CustomPaint(
            painter: BounceTabBarPainter(widget.tabBar.tabs.length,
                currentIndex, oldIndex, _drawingAnimation.value, widget.color),
            child: TabBar(
              labelColor: widget.tabBar.labelColor,
              indicatorColor: widget.tabBar.indicatorColor,
              unselectedLabelColor: widget.tabBar.unselectedLabelColor,
              controller: widget.tabBar.controller,
              tabAlignment: widget.tabBar.tabAlignment,
              splashBorderRadius: widget.tabBar.splashBorderRadius,
              enableFeedback: widget.tabBar.enableFeedback,
              dividerColor: widget.tabBar.dividerColor,
              splashFactory: widget.tabBar.splashFactory,
              dragStartBehavior: widget.tabBar.dragStartBehavior,
              isScrollable: widget.tabBar.isScrollable,
              indicator: widget.tabBar.indicator,
              indicatorPadding: widget.tabBar.indicatorPadding,
              indicatorSize: widget.tabBar.indicatorSize,
              indicatorWeight: widget.tabBar.indicatorWeight,
              labelStyle: widget.tabBar.labelStyle,
              labelPadding: widget.tabBar.labelPadding,
              unselectedLabelStyle: widget.tabBar.unselectedLabelStyle,
              key: widget.tabBar.key,
              mouseCursor: widget.tabBar.mouseCursor,
              overlayColor: widget.tabBar.overlayColor,
              padding: widget.tabBar.padding,
              physics: widget.tabBar.physics,
              onTap: widget.tabBar.onTap,
              automaticIndicatorColorAdjustment:
                  widget.tabBar.automaticIndicatorColorAdjustment,
              tabs: _createOpacityTabs(),
            ),
          ),
        );
      },
    );
  }

  void _tabBarControllerListener() {
    currentIndex = widget.tabBar.controller?.index ?? 0;

    if (!_drawingAnimationController.isAnimating) {
      isAnimationInProgress = true;
      _drawingAnimationController.reset();
      _drawingAnimationController.forward().whenComplete(() {
        oldIndex = currentIndex;
        isAnimationInProgress = false;
      });

      _fadeOutAnimationController.reset();
      _fadeOutAnimationController.forward();

      _fadeInAnimationController.reset();
      _fadeInAnimationController.forward();
    }
  }

  List<Widget> _createOpacityTabs() {
    var tabs = List<Widget>.from(widget.tabBar.tabs, growable: true);

    var opacityCurrentTab = tabs.removeAt(currentIndex);
    tabs.insert(currentIndex,
        FadeTransition(opacity: _fadeInAnimation, child: opacityCurrentTab));

    var opacityOldTab = tabs.removeAt(oldIndex);
    tabs.insert(oldIndex,
        FadeTransition(opacity: _fadeOutAnimation, child: opacityOldTab));

    return tabs;
  }
}
