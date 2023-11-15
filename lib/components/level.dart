import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:mykillerdreams/components/collisionblock.dart';
import 'package:mykillerdreams/components/mykillerdreams_game.dart';
import 'package:mykillerdreams/components/player.dart';

class Level extends World with HasGameRef<MyKillerDreamsGame> {
  late TiledComponent level;
  List<CollisionBlock> collisionBlock = [];
  final player = Player();

  @override
  FutureOr<void> onLoad() async {
    debugMode = true;
    level = await TiledComponent.load(
      "level_1.tmx",
      Vector2.all(16),
    );
    add(level);
    _addCollision();
    _addSpawnObjects();
    return super.onLoad();
  }

  void _addCollision() {
    final collisionLayer = level.tileMap.getLayer<ObjectGroup>("Collisions");
    if (collisionLayer != null) {
      for (final collision in collisionLayer.objects) {
        final block = CollisionBlock(
          position: Vector2(collision.x, collision.y),
          size: Vector2(collision.width, collision.height),
        );
        collisionBlock.add(block);
        add(block);
      }
      player.collisionBlock = collisionBlock;
    }
  }

  void _addSpawnObjects() {
    final spawnPointLayer = level.tileMap.getLayer<ObjectGroup>("spawnPoint");
    if (spawnPointLayer != null) {
      for (final spawnpoint in spawnPointLayer.objects) {
        switch (spawnpoint.class_) {
          case "Player":
            final player = Player(
              position: Vector2(spawnpoint.x, spawnpoint.y),
              size: Vector2(spawnpoint.width, spawnpoint.height),
            );
            add(player);
            break;
          default:
        }
      }
    }
  }
}
