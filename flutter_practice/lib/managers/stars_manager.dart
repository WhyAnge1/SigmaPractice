import 'dart:math';

import '../repository/models/star.dart';

class StarsManager {
  static final _instance = StarsManager._create();
  final _random = Random();
  final stars = List<Star>.empty(growable: true);

  StarsManager._create();
  factory StarsManager() => _instance;

  int maxStars = 30;

  void generateStars() {
    stars.clear();

    while (stars.length < maxStars) {
      generateStar();
    }
  }

  void removeStar(Star starToRemove){
    stars.remove(starToRemove);
    generateStar();
  }

  void generateStar() {
    if (stars.length < maxStars) {
      final x = (_random.nextDouble() * 90) + 5;
      final y = (_random.nextDouble() * 90) + 5;
      final light = _random.nextInt(140) + 10;
      stars.add(Star(x, y, light));
    }
  }
}
