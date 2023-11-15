import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:mykillerdreams/components/level.dart';

class MyKillerDreamsGame extends FlameGame
    with DragCallbacks, HasCollisionDetection, HasKeyboardHandlerComponents {
  late CameraComponent cam;
  late Level worlds;

  @override
  FutureOr<void> onLoad() async {
    await images.loadAllImages();
    worlds = Level();
    cam = CameraComponent.withFixedResolution(
      width: 640,
      height: 368,
      world: worlds,
    );
    cam.viewfinder.anchor = Anchor.topLeft;

    addAll([worlds, cam]);
    return super.onLoad();
  }
}
