import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/geometry.dart';
import 'package:flame/sprite.dart';
import 'package:flame/src/gestures/events.dart';
import 'package:flutter/widgets.dart';
import 'package:golden_rush3/components/Character.dart';

import '../HUD/hud.dart';
import '../utils/math_utils.dart';
import 'Skeleton.dart';
import 'Zombie.dart';

class George extends Character {
  late double screenWidth, screenHeight, centerX, centerY;
  late double georgeSizeWidth = 48.0, georgeSizeHeight = 48.0;
  late double walkingSpeed, runningSpeed;
  late SpriteAnimation georgeDownAnimation,
      georgeLeftAnimation,
      georgeUpAnimation,
      georgeRightAnimation;
  static const int down = 0, left = 1, up = 2, right = 3;
  final HudComponent hud;

  George(
      {required this.hud,
      required Vector2 position,
      required Vector2 size,
      required double speed})
      : super(position: position, size: size, speed: speed);

  late Vector2 targetLocation;
  bool movingToTouchedLocation = false;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    screenWidth = MediaQueryData.fromWindow(window).size.width;
    screenHeight = MediaQueryData.fromWindow(window).size.height;
    centerX = (screenWidth / 2) - (georgeSizeWidth / 2);
    centerY = (screenHeight / 2) - (georgeSizeHeight / 2);
    walkingSpeed = speed;
    runningSpeed = speed * 2;

    var spriteImages = await Flame.images.load('george.png');
    final spriteSheet = SpriteSheet(
        image: spriteImages,
        srcSize: Vector2(georgeSizeWidth, georgeSizeHeight));

    downAnimation =
        spriteSheet.createAnimationByColumn(column: 0, stepTime: 0.2);
    leftAnimation =
        spriteSheet.createAnimationByColumn(column: 1, stepTime: 0.2);
    upAnimation = spriteSheet.createAnimationByColumn(column: 2, stepTime: 0.2);
    rightAnimation =
        spriteSheet.createAnimationByColumn(column: 3, stepTime: 0.2);
    addHitbox(HitboxRectangle());
    animation = downAnimation;
    playing = false;
    anchor = Anchor.center;

    addHitbox(HitboxRectangle());
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    if (other is Zombie || other is Skeleton) {
      other.removeFromParent();
      hud.scoreText.setScore(10);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    speed = hud.runButton.buttonPressed ? runningSpeed : walkingSpeed;

    if (!hud.joystick.delta.isZero()) {
      position.add(hud.joystick.relativeDelta * speed * dt);

      playing = true;

      switch (hud.joystick.direction) {
        case JoystickDirection.up:
        case JoystickDirection.upRight:
        case JoystickDirection.upLeft:
          animation = upAnimation;
          currentDirection = Character.up;
          break;

        case JoystickDirection.down:
        case JoystickDirection.downRight:
        case JoystickDirection.downLeft:
          animation = downAnimation;
          currentDirection = Character.down;
          break;
        case JoystickDirection.left:
          animation = leftAnimation;
          currentDirection = Character.left;
          break;
        case JoystickDirection.right:
          animation = rightAnimation;
          currentDirection = Character.right;
          break;
        case JoystickDirection.idle:
          animation = null;
          break;
      }
    } else {
      if (movingToTouchedLocation) {
        position += (targetLocation - position).normalized() * (speed * dt);
      } else {
        if (playing) {
          double threshold = 1.0;
          var difference = targetLocation - position;
          if (difference.x.abs() < threshold &&
              difference.y.abs() < threshold) {
            stopAnimations();
            movingToTouchedLocation = false;
            playing = true;
            var angle = getAngle(position, targetLocation);
            if ((angle > 315 && angle < 360) || (angle > 0 && angle < 45)) {
              // Moving right
              animation = rightAnimation;
              currentDirection = Character.right;
            }
            // Moving down
            else if (angle > 45 && angle < 135) {
              animation = downAnimation;
              currentDirection = Character.down;
            }
            // Moving left
            else if (angle > 135 && angle < 225) {
              animation = leftAnimation;
              currentDirection = Character.left;
            }
            // Moving up
            else if (angle > 225 && angle < 315) {
              animation = upAnimation;
              currentDirection = Character.up;
            }
            return;
          }
        }
      }
    }
  }

  void stopAnimations() {
    animation?.currentIndex = 0;
    playing = false;
  }

  void moveToLocation(TapUpInfo info) {
    targetLocation = info.eventPosition.game;
    movingToTouchedLocation = true;
  }
}
