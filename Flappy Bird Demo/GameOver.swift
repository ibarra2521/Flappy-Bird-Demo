//
//  GameOver.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GameKit

class GameOver: SKScene, GKGameCenterControllerDelegate {
    var bgColor = UIColor(red: 163.0/255, green: 188.0/255, blue: 137.0/255, alpha: 1.0)
    var textGreenColor = UIColor(red: 163.0/255, green: 188.0/255, blue: 137.0/255, alpha: 1.0)
    var playAgainButton = UIButton()
    var playAgainButtonImage = UIImage(named: "PlayAgainButton") as UIImage!
    
    var scoreLabel = UILabel()
    var scoreLabelImage = UIImage(named: "ScoreBG") as UIImage!
    var scoreLabelImageView = UIImageView()
    
    var leaderboardButton = UIButton()
    var leaderboardButtonImage = UIImage(named: "LeaderboardButton") as UIImage!
    
    var gameOverSceneAudioPlayer = AVAudioPlayer()
    var gameOverSceneSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Course-Demo-Game-Over", ofType: "mp3")!)

    var muteButton = UIButton()
    var audioMutedButtonImage = UIImage(named: "AudioMutedButton")  as UIImage!
    var audioUnMutedButtonImage = UIImage(named: "AudioUnMutedButton")  as UIImage!
    
    var userSettingsDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    var facebookButton = UIButton()
    var facebookButtonImage = UIImage(named: "FaceBookButton") as UIImage!
    
    var newHighScoreLabel = UILabel()
    
    override func didMoveToView(view: SKView) {
        // Show Chartboost ads
        delay(1.0) {
            AdsUtility.chartboostInterstitial()
        }
        
        // Setting the background color to custom UIColor
        backgroundColor = bgColor
        
        // Create the play again button
        self.playAgainButton = UIButton(type: UIButtonType.Custom)
        self.playAgainButton.setImage(playAgainButtonImage, forState: .Normal)
        self.playAgainButton.frame = CGRectMake(self.frame.size.width / 2, self.frame.size.height / 2, 80, 80)
        self.playAgainButton.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.playAgainButton.layer.zPosition = 0
        
        // Make the playAgainButton perform an action when it is touched
        self.playAgainButton.addTarget(self, action: "playAgainButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        delay(0.5) {
            view.addSubview(self.playAgainButton)
        }
//        print("Game over Score: \(kScore)")
        // label to hold the player current score
        self.scoreLabel = UILabel(frame: CGRectMake(self.frame.size.width / 2, 200, 120, 120))
        self.scoreLabel.textAlignment = NSTextAlignment.Center
        self.scoreLabel.textColor = textGreenColor
        self.scoreLabel.text = "\(kScore)"
        self.scoreLabel.font = UIFont(name: scoreLabel.font.fontName, size: 45)
        self.scoreLabel.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.scoreLabel.layer.zPosition = 1
        
        // Set background image for the score label
        self.scoreLabelImageView = UIImageView(image: scoreLabelImage!)
        self.scoreLabelImageView.frame = CGRectMake(self.frame.size.width / 2, 200, 120, 120)
        self.scoreLabelImageView.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.scoreLabelImageView.layer.zPosition = 0
        delay(0.5) {
            view.addSubview(self.scoreLabel)
            view.addSubview(self.scoreLabelImageView)
        }
        
        delay(0.5) {
            // Play de game over scene audio
            self.playGameOverSceneAudio()
        }
        
        // Retrieve MuteState from NSUserDefults
        kMuteState = userSettingsDefaults.boolForKey("MuteState")
        
        // Setup mute and un mute button
        self.muteButton = UIButton(type: UIButtonType.Custom)
        self.muteButton.frame = CGRectMake(self.frame.size.width / 4, 150, 80, 80)
        self.muteButton.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.muteButton.layer.zPosition = 0
        self.muteButton.addTarget(self, action: "muteButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Check to see if retrieve MuteState is either true or false and display the image based the result
        if kMuteState == false {
            // Which means the audio state is currently muted
            self.muteButton.setImage(audioUnMutedButtonImage, forState: .Normal)
        }else if kMuteState == true {
            // Which means the audio state is currently muted
            self.muteButton.setImage(audioMutedButtonImage, forState: .Normal)
        }
        
        // Add to subview with a delay
        delay(0.5) {
            // Add to subview 
            view.addSubview(self.muteButton)
        }
        
        // Create a facebook button
        self.facebookButton = UIButton(type: UIButtonType.Custom)
        self.facebookButton.setImage(facebookButtonImage, forState: .Normal)
        self.facebookButton.frame = CGRectMake(self.frame.size.width / 4, self.frame.size.height / 2, 80, 80)
        self.facebookButton.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.facebookButton.layer.zPosition = 0
        
        // Make a button perform an action
        self.facebookButton.addTarget(self, action: "facebookButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add so subview with a delay
        delay(0.5) {
            view.addSubview(self.facebookButton)
        }
        
        // Create a leaderboard button to call the Game Center View Controller
        self.leaderboardButton = UIButton(type: UIButtonType.Custom)
        self.leaderboardButton.setImage(leaderboardButtonImage, forState: .Normal)
        self.leaderboardButton.frame = CGRectMake(self.frame.size.width - self.frame.size.width / 4, self.frame.size.height / 2, 80, 80)
        self.leaderboardButton.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.leaderboardButton.layer.zPosition = 2
        
        // Make the button perform an action when it is touched
        self.leaderboardButton.addTarget(self, action: "leaderboardButtonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Add to the subView with a delay
        delay(0.5) {
            view.addSubview(self.leaderboardButton)
        }
        
        // Create a newHighScoreLabel to be displayed when a new high score has been reached
        self.newHighScoreLabel = UILabel(frame: CGRectMake(self.frame.size.width / 2, self.frame.size.height  - self.frame.size.height / 4, self.frame.size.width, 120))
        self.newHighScoreLabel.textAlignment = NSTextAlignment.Center
        self.newHighScoreLabel.font = UIFont(name: newHighScoreLabel.font.fontName, size: 35)
        self.newHighScoreLabel.text = "New Highscore!"
        self.newHighScoreLabel.layer.anchorPoint = CGPointMake(1.0, 1.0)
        self.newHighScoreLabel.layer.zPosition = 0
        
        // Check to see if a new high score has been reached
        checkNewHighScore()
        
        // Send the users highest score to the user Game Center Leaderboard
        reportLeaderboardIdentifier("ID of GameCenter on iTunes connect", score: kGameSceneHighScore)
    }
    
    func delay(delay: Double, closure:() -> () ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func playAgainButtonAction(sender: UIButton) {
        delay(0.5) {
            // Play the game again
            self.playAgain()
        }
        
        // Stop the game audio from play when the play again button is press
        gameOverSceneAudioPlayer.stop()
    }
    
    func playGameOverSceneAudio() {
        // Setting up the audio player for the game over scene audio
        do {
            try gameOverSceneAudioPlayer = AVAudioPlayer(contentsOfURL:
            gameOverSceneSound)
            gameOverSceneAudioPlayer.prepareToPlay()
            gameOverSceneAudioPlayer.numberOfLoops = -1
//            gameOverSceneAudioPlayer.play()
            
            // Check to see if MuteState is true of false
            if kMuteState == true {
                // Sound needs to be muted - stopped
                if (gameOverSceneAudioPlayer.playing) {
                    gameOverSceneAudioPlayer.stop()
                }
            }else if kMuteState == false {
                gameOverSceneAudioPlayer.play()
            }
            
            
        } catch {
                print("GameScene. gameSceneAudioPlayer is not available")
        }
        
    }
    
    func muteButtonAction(sender: UIButton) {
        if kMuteState == false {
            // which means the audio state is currently un muted
            userSettingsDefaults.setBool(true, forKey: "MuteState")
            userSettingsDefaults.synchronize()
            gameOverSceneAudioPlayer.stop()
            self.muteButton.setImage(audioMutedButtonImage, forState: .Normal)
            kMuteState = userSettingsDefaults.boolForKey("MuteState")
        }else if kMuteState == true {
            // Which means the audio state is currently muted
            userSettingsDefaults.setBool(false, forKey: "MuteState")
            userSettingsDefaults.synchronize()
            gameOverSceneAudioPlayer.play()
            self.muteButton.setImage(audioUnMutedButtonImage, forState: .Normal)
            kMuteState = userSettingsDefaults.boolForKey("MuteState")
        }
    }
    
    func facebookButtonAction (sender:UIButton) {
        // Call the notification that holds the selector name for the showFacebookSheet func
        NSNotificationCenter.defaultCenter().postNotificationName("FacebookID", object: nil)
    
    }
    
    func leaderboardButtonAction(sender: UIButton) {
        // Call the Game Center Leaderboard
        showLeader()
    }
    
    func showLeader() {
        // Shows the leaderbord view controller
        let vc = self.view?.window?.rootViewController
        let gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController) {
        // Delegate that will dismiss the leaderboard view controller when the done button is pressed
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func reportLeaderboardIdentifier(identifier: String, score: Int) {
        //Chek if the user has signed into Game Center
        if GKLocalPlayer.localPlayer().authenticated {
            // Create a variable to hold the Game Center Leaderboard ID and score we will be sending to that leaderboard
            let scoreObject = GKScore(leaderboardIdentifier: identifier)
            scoreObject.value = Int64(score) // value is a property of GKScore with will be holding our users score
            GKScore.reportScores([scoreObject], withCompletionHandler: {(error) -> Void in
                if error != nil {
                    print("Error in reporting leaderboard score: \(error)")
                }
            })
        }
    }
    
    func checkNewHighScore() {
        // Check to see if kNewHighScore is true
        if kNewHighScore {
            delay(0.5){
                self.view!.addSubview(self.newHighScoreLabel)
            }
        }
    }
    
    func playAgain() {
        // Removes the scoreLabel from de view
        scoreLabel.removeFromSuperview()
        
        // Removes the scoreLabelImageView from the view
        scoreLabelImageView.removeFromSuperview()
        
        // Removes the playAgainButton from the view
        playAgainButton.removeFromSuperview()
            
        // Removes the muteButton from the view
        muteButton.removeFromSuperview()
        
        // Removes the facebookButton from the view
        facebookButton.removeFromSuperview()
        
        // Removes the leaderboardButton from the view
        leaderboardButton.removeFromSuperview()
        
        // Removes the newHighScore label from the view
        newHighScoreLabel.removeFromSuperview()
        
        // Create the new scene to transition too
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true
        
        // Remove scene before transmitioning
        self.scene?.removeFromParent()
        
        // The transition effect
        let transition = SKTransition.fadeWithColor(UIColor.grayColor(), duration: 1.0)
        transition.pausesOutgoingScene = false
        
        // A variable to hold the GameOver scene
        var scene: GameScene!
        scene = GameScene(size: skView.bounds.size)
        
        // Setting the new scene's aspect ration to fill
        scene.scaleMode = .AspectFill
        
        // Presenting the new scene with a transition affect
        skView.presentScene(scene, transition: transition)

    }
    
}


