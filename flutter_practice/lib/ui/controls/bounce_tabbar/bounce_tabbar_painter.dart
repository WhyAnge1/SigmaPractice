import 'package:flutter/material.dart';

class BounceTabBarPainter extends CustomPainter {
  final mainPainter = Paint()
    ..strokeWidth = 0.5
    ..style = PaintingStyle.fill;

  final int tabsLength;
  final int toIndex;
  final int fromIndex;
  final double movingCirclePersent;
  final Color mainColor;

  BounceTabBarPainter(this.tabsLength, this.toIndex, this.fromIndex,
      this.movingCirclePersent, this.mainColor);

  @override
  void paint(Canvas canvas, Size size) {
    final circleCenters = List<Offset>.empty(growable: true);
    final tabWidth = size.width / tabsLength;
    final circleRadius = tabWidth / 7;
    final tabCenterY = circleRadius * 1.2;

    mainPainter.color = mainColor;

    for (int i = 1; i <= tabsLength; i++) {
      var x = tabWidth * i - tabWidth / 2;
      circleCenters.add(Offset(x, tabCenterY));
    }

    final mainCircleOffset =
        _drawCircle(circleCenters, fromIndex, toIndex, circleRadius, canvas);

    _drawBackground(size, mainCircleOffset, tabWidth, circleRadius, tabCenterY,
        circleCenters, canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Offset _drawCircle(List<Offset> circleCenters, int fromIndex, int toIndex,
      double circleRadius, Canvas canvas) {
    final fromPoint = circleCenters[fromIndex];
    final toPoint = circleCenters[toIndex];
    var mainCircleOffset = fromPoint;

    if (fromIndex != toIndex) {
      final bouncePath = Path();
      bouncePath.moveTo(fromPoint.dx, fromPoint.dy);

      final mainCirclePathAnglePoint = Offset(
          (-(fromPoint.dx - toPoint.dx) / 2) + fromPoint.dx,
          -(circleRadius * 10));
      bouncePath.quadraticBezierTo(mainCirclePathAnglePoint.dx,
          mainCirclePathAnglePoint.dy, toPoint.dx, toPoint.dy);

      final pathMetric = bouncePath.computeMetrics().elementAt(0);
      final distance = pathMetric.length * movingCirclePersent;
      mainCircleOffset = pathMetric.getTangentForOffset(distance)!.position;
    }

    canvas.drawCircle(mainCircleOffset, circleRadius, mainPainter);

    return mainCircleOffset;
  }

  void _drawBackground(
      Size canvasSize,
      Offset mainCircleOffset,
      double tabWidth,
      double circleRadius,
      double tabCenterY,
      List<Offset> circleCenters,
      Canvas canvas) {
    final backgroundPath = Path();
    backgroundPath.moveTo(0, 0);

    final isInRangeOfFrom = mainCircleOffset.dx > (tabWidth * fromIndex) &&
        mainCircleOffset.dx < tabWidth * (fromIndex + 1);
    final isInRangeOfTo = mainCircleOffset.dx > (tabWidth * toIndex) &&
        mainCircleOffset.dx < tabWidth * (toIndex + 1);

    if (isInRangeOfFrom || isInRangeOfTo) {
      final curentIndex = isInRangeOfFrom ? fromIndex : toIndex;
      final currentTabPosition = circleCenters[curentIndex];
      final leftTabX = tabWidth * curentIndex;
      final rightTabX = tabWidth * (curentIndex + 1);

      final circleLowerY = mainCircleOffset.dy + circleRadius;
      final deflectionCenterY = circleLowerY >= -(circleRadius * 1.6)
          ? circleLowerY + (circleRadius * 1.6)
          : 0.0;

      final deflectionSidesMaxY = tabCenterY - 5;
      final deflectionSidesY = circleLowerY <= deflectionSidesMaxY
          ? (circleLowerY >= 0.0 ? circleLowerY : 0.0)
          : deflectionSidesMaxY;

      final leftStartPoint = Offset(tabWidth * curentIndex, 0);
      final leftAnglePoint = Offset(leftTabX + (tabWidth / 6), 0);
      final middleAnglePoint = Offset(currentTabPosition.dx, deflectionCenterY);
      final leftPathPoint = Offset(leftTabX + (tabWidth / 4), deflectionSidesY);
      final rightPathPoint =
          Offset(rightTabX - (tabWidth / 4), deflectionSidesY);
      final rightAnglePoint = Offset(rightTabX - (tabWidth / 6), 0);
      final rightEndPoint = Offset(rightTabX, 0);

      backgroundPath.lineTo(leftStartPoint.dx, leftStartPoint.dy);
      backgroundPath.quadraticBezierTo(leftAnglePoint.dx, leftAnglePoint.dy,
          leftPathPoint.dx, leftPathPoint.dy);
      backgroundPath.quadraticBezierTo(middleAnglePoint.dx, middleAnglePoint.dy,
          rightPathPoint.dx, rightPathPoint.dy);
      backgroundPath.quadraticBezierTo(rightAnglePoint.dx, rightAnglePoint.dy,
          rightEndPoint.dx, rightEndPoint.dy);
    }

    backgroundPath.lineTo(canvasSize.width, 0);
    backgroundPath.lineTo(canvasSize.width, canvasSize.height);
    backgroundPath.lineTo(0, canvasSize.height);

    canvas.drawPath(backgroundPath, mainPainter);
  }
}
