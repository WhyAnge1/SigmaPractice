import 'dart:math';
import 'dart:ui';

class Star {
  double xPersentage;
  double yPersentage;
  int light;
  late Offset renderedOffset;
  late double distaceToThumb;

  Star(this.xPersentage, this.yPersentage, this.light);

  void setDistanceToThumb(Offset thumbOffset){
    distaceToThumb = sqrt(
          pow((renderedOffset.dx - thumbOffset.dx), 2) +
              pow((renderedOffset.dy - thumbOffset.dy), 2));
  }
}
