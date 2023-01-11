import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:golden_rush3/components/George.dart';

class Background extends PositionComponent with Tappable {
  static final backgroundPaint = BasicPalette.white.paint();
  late final George george;
  late double screenWidth, screenHeight;

  Background(this.george);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    position = Vector2(0, 0);
    size = Vector2(screenWidth, screenHeight);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(
        Rect.fromPoints(position.toOffset(), size.toOffset()), backgroundPaint);
  }

  @override
  bool onTapUp(TapUpInfo info) {
    george.moveToLocation(info);
    return true;
  }
}
