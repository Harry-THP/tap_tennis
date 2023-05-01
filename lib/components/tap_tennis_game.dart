import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:tap_tennis/components/paddle.dart';
import 'package:tap_tennis/components/ball.dart';
import 'package:tap_tennis/components/score.dart';
import 'package:tap_tennis/data_persistence.dart' as data;

class TapTennisGame extends FlameGame with HasCollisionDetection, TapDetector {
  //Sprites
  Paddle playerPaddle = Paddle();
  Paddle computerPaddle = Paddle();
  Ball ball = Ball();
  Score scoreCounter = Score();

  //Game variables
  String compDirection = "down";
  String playerDirection = "stop";
  String ballXDirection = "right";
  String ballYDirection = "up";
  bool paddleHit = false;
  int score = 0;
  bool _cooldown = false;

  //Method to show whether a paddle has hit the ball
  paddleHitBall(bool hitBall) {
    paddleHit = hitBall;
  }

  //Method that updates the player's score
  updateScore() {
    if (_cooldown == false) {
      score += 1;
    }
    /*Cooldown of 1 second to prevent it triggering more than once when the ball
		hits the paddle*/
    _cooldown = true;
    Future.delayed(const Duration(seconds: 1), () {
      _cooldown = false;
    });
  }

  //Load game assets
  @override
  Future<void> onLoad() async {
    await super.onLoad();

    playerPaddle.position = Vector2(size[0] - 50, 150);
    add(playerPaddle);

    computerPaddle.position = Vector2(50, 150);
    add(computerPaddle);

    ball.position = Vector2(size[0] / 2, size[1] / 2);
    add(ball);

    scoreCounter.position = Vector2(size[0] / 2, 20);
    add(scoreCounter);

    //Paddle placement reflects screen size, but only on refresh-
    //Need to implement an auto refresh - 09/02/2023
    // @override
    // update(double dt) {
    //   super.update(dt);
    //   playerPaddle.position = Vector2(size[0] - 75, 150);
    // }
  }

  //Main game controls
  @override
  update(double dt) async {
    super.update(dt);
		double ballSpeed = await data.getBallSpeed();
		double paddleSpeed = await data.getPaddleSpeed();

    //Movement X options for ball
    switch (ballXDirection) {
      case "right":
        ball.x += ballSpeed;
        break;
      case "left":
        ball.x -= ballSpeed;
        break;
    }

    //Movement Y options for ball
    switch (ballYDirection) {
      case "down":
        ball.y += ballSpeed;
        break;
      case "up":
        ball.y -= ballSpeed;
        break;
    }

    //Ball movement code
    if (ball.x <= 75 && paddleHit == true) {
      ballXDirection = "right";
    }
    if (ball.x >= size[0] - 75 && paddleHit == true) {
      ballXDirection = "left";
      updateScore();
    }
    if (ball.x < -25 || ball.x > size[0] + 25) {
      pauseEngine();
    }

    if (ball.y > size[1] - 25) {
      ballYDirection = "up";
    }
    if (ball.y < 0) {
      ballYDirection = "down";
    }

    /*Returns paddleHit back to false after the ball has hit the paddle so that
		the game can detect when the ball has passed a paddle after the first move.*/
    paddleHit = false;

    //Movement options for computer paddle
    switch (compDirection) {
      case "down":
        computerPaddle.y += 5;
        break;
      case "up":
        computerPaddle.y -= 5;
        break;
    }

    //TEMPORARY computer movement code
    if (computerPaddle.y > size[1] - 100) {
      compDirection = "up";
    }
    if (computerPaddle.y < 0) {
      compDirection = "down";
    }

    //Movement options for player paddle
    switch (playerDirection) {
      case "down":
        playerPaddle.y += paddleSpeed;
        break;
      case "up":
        playerPaddle.y -= paddleSpeed;
        break;
      case "stop":
        playerPaddle.y += 0;
        break;
    }

    //Player edge detection
    if (playerPaddle.y > size[1] - 100) {
      playerDirection = "stop";
    }
    if (playerPaddle.y < 0) {
      playerDirection = "stop";
    }
  }

  //Player movement code
  @override
  void onTapDown(TapDownInfo info) {
    var tapCoordinates = info.eventPosition.game;

    if (tapCoordinates.y > size[1] / 2) {
      playerDirection = "down";
    }
    if (tapCoordinates.y <= size[1] / 2) {
      playerDirection = "up";
    }
  }

  //Player stop code
  @override
  void onTapUp(TapUpInfo info) {
    playerDirection = "stop";
  }
}
