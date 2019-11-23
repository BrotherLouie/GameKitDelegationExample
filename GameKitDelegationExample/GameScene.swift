import SpriteKit

protocol GameSceneDelegate {
	func gameCenterSignInTouched()
	func leaderboardTouched()
}

class GameScene: SKScene {
	var gameSceneDelegate: GameSceneDelegate?

	override func didMove(to view: SKView) {
		/* Setup your scene here */
		let gameCenterSignInLabel = SKLabelNode(fontNamed:"Chalkduster")
		gameCenterSignInLabel.text = "Sign in to Game Center!";
		gameCenterSignInLabel.fontSize = 26;
		gameCenterSignInLabel.fontColor = .black
		gameCenterSignInLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY);
		gameCenterSignInLabel.name = "GameCenterSignIn"
		gameCenterSignInLabel.zPosition = 100

		let leaderboardLabel = SKLabelNode(fontNamed:"Chalkduster")
		leaderboardLabel.text = "View Leaderboard";
		leaderboardLabel.fontSize = 26;
		leaderboardLabel.fontColor = .black
		leaderboardLabel.position = CGPoint(x:self.frame.midX, y:self.frame.midY - 55.0);
		leaderboardLabel.name = "LeaderBoard"
		leaderboardLabel.zPosition = 100

		self.addChild(gameCenterSignInLabel)
		self.addChild(leaderboardLabel)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		/* Called when a touch begins */

		for touch: AnyObject in touches {
			let location = touch.location(in: self)
			let node = self.atPoint(location)

			if let nodeName = node.name {
				switch nodeName {
				case "GameCenterSignIn":
					self.gameSceneDelegate?.gameCenterSignInTouched()
				case "LeaderBoard":
					self.gameSceneDelegate?.leaderboardTouched()
				default:
					print("User tapped some other thing")
				}
			} else {
				let sprite = SKSpriteNode(imageNamed:"Spaceship")
				
				sprite.xScale = 0.5
				sprite.yScale = 0.5
				sprite.position = location
				sprite.zPosition = 1
				
				let action = SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)
				sprite.run(SKAction.repeatForever(action))
				self.addChild(sprite)
			}
		}
	}

	override func update(_ currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
	}
}
