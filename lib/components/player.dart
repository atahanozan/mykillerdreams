import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:mykillerdreams/components/collisionblock.dart';
import 'package:mykillerdreams/components/custom_hitbox.dart';
import 'package:mykillerdreams/components/mykillerdreams_game.dart';
import 'package:mykillerdreams/components/utils.dart';

enum PlayerState { idle, run }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<MyKillerDreamsGame>, KeyboardHandler, CollisionCallbacks {
  Player({position, size}) : super(position: position, size: size);
  late SpriteAnimation idleAnimation;
  late SpriteAnimation runAnimation;
  bool isleft = false;
  bool isRight = false;
  bool isUp = false;
  bool isDown = false;
  int moveSpeed = 50;
  Vector2 velocity = Vector2.zero();
  List<CollisionBlock> collisionBlock = [];
  final hitbox = CustomHitbox(
    offsetX: 5,
    offsetY: 5,
    width: 20,
    height: 20,
  );

  @override
  FutureOr<void> onLoad() {
    debugMode = true;
    add(
      RectangleHitbox(
        position: Vector2(hitbox.offsetX, hitbox.offsetY),
        size: Vector2(hitbox.width, hitbox.height),
      ),
    );
    _loadAllAnimations();
    current = PlayerState.idle;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    _updatePlayerState();
    _updateMovement(dt);
    _checkCollisions();

    super.update(dt);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is CollisionBlock) checkCollisions(this, collisionBlock);

    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    isleft = keysPressed.contains(LogicalKeyboardKey.keyA) ||
        keysPressed.contains(LogicalKeyboardKey.arrowLeft);
    isRight = keysPressed.contains(LogicalKeyboardKey.keyD) ||
        keysPressed.contains(LogicalKeyboardKey.arrowRight);
    isUp = keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.arrowUp);
    isDown = keysPressed.contains(LogicalKeyboardKey.keyS) ||
        keysPressed.contains(LogicalKeyboardKey.arrowDown);
    return super.onKeyEvent(event, keysPressed);
  }

  void _loadAllAnimations() {
    idleAnimation = SpriteAnimation.fromFrameData(
      game.images.fromCache("Player/idle.png"),
      SpriteAnimationData.sequenced(
        amount: 1,
        stepTime: 1,
        textureSize: Vector2.all(32),
      ),
    );
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.run: idleAnimation,
    };
  }

  void _updatePlayerState() {
    current = PlayerState.idle;
    if (isleft) {
      flipHorizontallyAroundCenter();
    } else if (isRight) {
      flipHorizontallyAroundCenter();
    }
  }

  void _updateMovement(double dt) {
    if (isleft) {
      velocity.x = moveSpeed * dt;
      position.x -= velocity.x;
    } else if (isRight) {
      velocity.x = moveSpeed * dt;
      position.x += velocity.x;
    } else if (isDown) {
      velocity.y = moveSpeed * dt;
      position.y += velocity.y;
    } else if (isUp) {
      velocity.y = moveSpeed * dt;
      position.y -= velocity.y;
    }
  }

  void _checkCollisions() {
    for (final block in collisionBlock) {
      if (checkCollisions(this, block)) {
        if (velocity.x > 0) {
          velocity.x = 0;
          position.x = block.x - width;
        }
        if (velocity.x < 0) {
          velocity.x = 0;
          position.x = block.x + block.width + width;
        }
      }
    }
  }
}
