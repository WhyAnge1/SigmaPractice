import 'package:flutter/cupertino.dart';

import '../../managers/paint_manager.dart';
import '../../managers/stars_manager.dart';
import '../../misc/app_colors.dart';
import '../../repository/models/star.dart';

class StarsPainter extends CustomPainter {
  static const double _maxDistance = 100;
  static const double _starRadius = 2;
  final _starManager = StarsManager();
  final _paintManager = PaintManager();
  bool _isStarsRendered = false;

  final _circlePaint = Paint()
    ..style = PaintingStyle.fill
    ..color = AppColors.backgroundBlack
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
  final _linePaint = Paint()
    ..style = PaintingStyle.stroke
    ..color = AppColors.backgroundBlack
    ..strokeWidth = 1;
  final _starPaint = Paint()
    ..style = PaintingStyle.fill
    ..color = AppColors.starBlack;

  @override
  void paint(Canvas canvas, Size size) {
    if (!_paintManager.isCircleOffsetInitialized) {
      _paintManager.circleOffset = Offset(size.width / 2, size.height / 2);
    }

    if (!_isStarsRendered) {
      _renderStars(canvas, size);
    }

    _setDistanceToThumb(_paintManager.circleOffset);

    for (var star in _getClosestStars()) {
      canvas.drawLine(
          _paintManager.circleOffset, star.renderedOffset, _linePaint);
    }

    _paintManager.tryDraggingTheCircleWithFinger();

    canvas.drawCircle(
        _paintManager.circleOffset, _paintManager.circleRadius, _circlePaint);
  }

  @override
  bool shouldRepaint(StarsPainter oldDelegate) => true;

  void _renderStars(Canvas canvas, Size size) {
    for (var star in _starManager.stars) {
      star.renderedOffset = Offset((star.xPersentage / 100) * size.width,
          (star.yPersentage / 100) * size.height);

      _starPaint.color = AppColors.starBlack.withAlpha(star.light);
      canvas.drawCircle(star.renderedOffset, _starRadius, _starPaint);
    }

    _isStarsRendered = true;
  }

  void _setDistanceToThumb(Offset thumbOffset) {
    for (var star in _starManager.stars) {
      star.setDistanceToThumb(thumbOffset);
    }
  }

  Iterable<Star> _getClosestStars() {
    _starManager.stars
        .sort((a, b) => a.distaceToThumb.compareTo(b.distaceToThumb));
    return _starManager.stars
        .where((element) => element.distaceToThumb <= _maxDistance);
  }
}
