import 'package:golden_rush3/components/Character.dart';

class CharacterEnemy extends Character {
  CharacterEnemy(
      {required super.position, required super.size, required super.speed});

/*@override
  void changeDirection() {
    Random random = Random();
    int newDirection = random.nextInt(4);
    switch (newDirection) {
      case Character.down:
        animation = downAnimation;
        break;
      case Character.left:
        animation = leftAnimation;
        break;
      case Character.up:
        animation = upAnimation;
        break;
      case Character.right:
        animation = rightAnimation;
        break;
    }
    currentDirection = newDirection;
  }

  @override
  void update(double dt) {
    super.update(dt);
    elapsedTime += dt;
    if (elapsedTime > 3.0) {
      changeDirection();
      elapsedTime = 0.0;
    }
    switch (currentDirection) {
      case Character.down:
        position.y += speed * dt;
        break;
      case Character.left:
        position.x -= speed * dt;
        break;
      case Character.up:
        position.y -= speed * dt;
        break;
      case Character.right:
        position.x += speed * dt;
        break;
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    if (other is ScreenCollidable) {
      switch (currentDirection) {
        case Character.down:
          currentDirection = Character.up;
          animation = upAnimation;
          break;
        case Character.left:
          currentDirection = Character.right;
          animation = rightAnimation;
          break;
        case Character.up:
          currentDirection = Character.down;
          animation = downAnimation;
          break;
        case Character.right:
          currentDirection = Character.left;
          animation = leftAnimation;
          break;
      }
      elapsedTime = 0.0;
    }
  }*/
}
