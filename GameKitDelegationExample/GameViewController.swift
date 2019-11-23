import UIKit
import SpriteKit
import GameKit

class GameViewController: UIViewController, GameSceneDelegate, GKGameCenterControllerDelegate {

	override func viewDidLoad() {
		super.viewDidLoad()

		if let scene = GameScene.init(fileNamed: "GameScene") {
			// Configure the view.
			let skView = self.view as! SKView
			skView.showsFPS = true
			skView.showsNodeCount = true

			/* Sprite Kit applies additional optimizations to improve rendering performance */
			skView.ignoresSiblingOrder = true

			/* Set the scale mode to scale to fit the window */
			scene.scaleMode = .aspectFill
			scene.gameSceneDelegate = self
			
			skView.presentScene(scene)
		}
	}

	func gameCenterSignInTouched() {
		authenticateLocalPlayer()
	}

	func leaderboardTouched() {
		authenticateLocalPlayer()
		showLeaderboard()
	}

	func prefersStatusBarHidden() -> Bool {
		return true
	}

	var gameCenterEnabled: Bool = false
	var leaderboardIdentifier = "lots.points" // This should actually probably be assigned only by the loadDefaultLeaderboardIdentifierWithCompletionHandler method below in your authenticatLocalPlayer() function

	func authenticateLocalPlayer() {
		let localPlayer = GKLocalPlayer.local
		localPlayer.authenticateHandler = {(viewController, error) -> Void in
			if (viewController != nil) {
				self.present(viewController!, animated: true, completion: nil)
			} else {
				if (localPlayer.isAuthenticated) {
					self.gameCenterEnabled = true
					localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifier : String!, error : NSError!) -> Void in
							if error != nil {
								print(error.localizedDescription)
							} else {
								self.leaderboardIdentifier = leaderboardIdentifier
							}
						} as? (String?, Error?) -> Void)
				} else {
					self.gameCenterEnabled = false
				}
			}
		}
		print(localPlayer)
		print(leaderboardIdentifier)
	}

	func showLeaderboard() {
		// only show the leaderboard if game center is enabled
		if self.gameCenterEnabled {
			let gameCenterViewController = GKGameCenterViewController()
			gameCenterViewController.gameCenterDelegate = self
			
			gameCenterViewController.viewState = GKGameCenterViewControllerState.leaderboards
			gameCenterViewController.leaderboardIdentifier = self.leaderboardIdentifier
			
			self.present(gameCenterViewController, animated: true, completion: nil)
		} else {
			// Tell the user something useful about the fact that game center isn't enabled on their device
		}
		
	}

	// MARK: GKGameCenterControllerDelegate Method
	func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
		gameCenterViewController.dismiss(animated: true, completion: nil)
	}
}
