import 'package:flutter/cupertino.dart';
import 'package:flutter_practice/ui/controls/stars_painter.dart';

import '../../managers/paint_manager.dart';
import '../../managers/stars_manager.dart';

class SpiderStar extends StatefulWidget {
  const SpiderStar({super.key});

  @override
  State<StatefulWidget> createState() => SpiderStarState();
}

class SpiderStarState extends State<SpiderStar> {
  final _starManager = StarsManager();
  final _paintManager = PaintManager();

  @override
  void initState() {
    super.initState();

    _starManager.generateStars();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _paintManager.fingerOffset =
            Offset(details.localPosition.dx, details.localPosition.dy);
        _paintManager.startDragging();
        setState(() {});
      },
      onPanEnd: (details) {
        _paintManager.stopDragging();

        setState(() {});
      },
      onPanUpdate: (details) {
        _paintManager.fingerOffset =
            Offset(details.localPosition.dx, details.localPosition.dy);
        setState(() {});
      },
      child: CustomPaint(
        painter: StarsPainter(),
      ),
    );
  }
}
