import 'dart:math';

import 'package:flutter/gestures.dart';

class PaintManager {
  static final _instance = PaintManager._create();

  final double circleRadius = 15;

  Offset fingerOffset = Offset.zero;
  Offset circleOffset = Offset.zero;
  bool canDragTheCircle = false;

  bool get isCircleOffsetInitialized => circleOffset != Offset.zero;

  PaintManager._create();
  factory PaintManager() => _instance;

  void startDragging() => canDragTheCircle = isCircleOffsetInitialized &&
      (pow(circleOffset.dx - fingerOffset.dx, 2) +
              pow(circleOffset.dy - fingerOffset.dy, 2)) <
          pow(circleRadius, 2);

  void stopDragging() {
    canDragTheCircle = false;
  }

  void tryDraggingTheCircleWithFinger() {
    if (isCircleOffsetInitialized && canDragTheCircle) {
      circleOffset = fingerOffset;
    }
  }
}
