//
//  GameScene.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright (c) 2016 Nivardo Ibarra. All rights reserved.
//

import SpriteKit
import UIKit
import AVFoundation
import Social

class GameScene: SKScene, SKPhysicsContactDelegate {
    var movingGround: MovingGround!
    var movingBackground: MovingBackground!
    var movingMidGround: MovingMidGround!
    var movingForeground: MovingForeground!
    var birdy: Birdy!
    var dumby: Dumby!
    
    let movingGroundTexture = SKTexture(imageNamed: "MovingGround")
    let movingBackgroundTexture = SKTexture(imageNamed: "MovingBackground")
    let movingMidgroundTexture = SKTexture(imageNamed: "MovingMidground")
    let movingForegroundTexture = SKTexture(imageNamed: "MovingForeground")
    let Pipe1Texture = SKTexture(imageNamed: "Pipe1")
    let Pipe2Texture = SKTexture(imageNamed: "Pipe2")
    let MovingBirdyTexture = SKTexture(imageNamed: "Birdy1")
    let DumbyTexture = SKTexture(imageNamed: "Birdy1")
    
    var skyColor = UIColor(red: 133.0/255.0, green: 197.0/255.0, blue: 207.0/255.0, alpha: 1.0)
    var moving = SKNode()
    let pipePair = SKNode()
    let pipes = SKNode()
    let groundLevel = SKNode()
    let skyLimit = SKNode()
    
    var alreadyAddedToTheScene = Bool()
    
    var movePipesAndRemove = SKAction()
    var spawnThenDelayForever = SKAction()
    
    var birdyCategory: UInt32 = 1 << 0
    let worldCategory: UInt32 = 1 << 1
    let pipeCategory: UInt32 = 1 << 2
    let scoreCategory: UInt32 = 1 << 3

    var score = NSInteger()
    var scoreLabelNode = SKLabelNode()
    
    var gameSceneAudioPlayer = AVAudioPlayer()
    var gameSceneSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Course-Demo-Game-Scene", ofType: "mp3")!)
    var gameSceneEffectAudioPlayer = AVAudioPlayer()
    var gameSceneEffectSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Course-Demo-Game-Over-Effect", ofType: "mp3")!)

    var userSettingsDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!"
//        myLabel.fontSize = 45
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
//        
//        self.addChild(myLabel)
        
        // reseting the new high score trigger
        kNewHighScore = false
        
        // Help reset the score so the GameOver scene displays the correct score when going from a number higher than zero back to zero
        kScore = 0
        
        // Add movign node to the scene
        addChild(moving)
        
        // Gravity properties
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5)
        self.physicsWorld.contactDelegate = self
        
        // Boolean used to add stuff to the scene
        alreadyAddedToTheScene = false
        
        // Setting the background color
        backgroundColor = skyColor
        
        // Call an instance of MovingGround class
        movingGround = MovingGround(size: CGSizeMake(movingGroundTexture.size().width, movingGroundTexture.size().height))
        moving.addChild(movingGround)
        
        // Call an instance of MovingBackground class
        movingBackground = MovingBackground(size: CGSizeMake(movingBackgroundTexture.size().width, movingBackgroundTexture.size().height))
//        movingBackground.zPosition = -3
        moving.addChild(movingBackground)
        
        // Call an instance of MovingMidground class
        movingMidGround = MovingMidGround(size: CGSizeMake(movingMidgroundTexture.size().width, movingMidgroundTexture.size().height))
        moving.addChild(movingMidGround)

        // Call an instance of MovingForeground class
        movingForeground = MovingForeground(size: CGSizeMake(movingForegroundTexture.size().width, movingForegroundTexture.size().height))
        moving.addChild(movingForeground)
        
        // Add the pipes node the moving node as a chil
        moving.addChild(pipes)
        
        // Adding and removing Pipe1 and Pipe2 too and from the GameScene and it will also set speed that moves across the scene
        let distanceToMove = CGFloat(self.frame.size.width + 5.0 * Pipe1Texture.size().width)
        let movePipes = SKAction.moveByX(-distanceToMove, y: 0.0, duration: NSTimeInterval(0.004 * distanceToMove))
        let removePipes = SKAction.removeFromParent()
        movePipesAndRemove = SKAction.sequence([movePipes, removePipes])
        
        // Attach the spawnPipes fuction directly into the gameSence
        let spawn = SKAction.runBlock({() in self.spawnPipes()})

        // Delays between each spawnPipes Fuction
        let delay = SKAction.waitForDuration(1.9, withRange: 2.0)
        let spawnThenDelay = SKAction.sequence([spawn, delay])
        spawnThenDelayForever = SKAction.repeatActionForever(spawnThenDelay)
        
        // Call and instance of the Dumby class
        dumby = Dumby(size: CGSizeMake(DumbyTexture.size().width, DumbyTexture.size().height))
        dumby.position = CGPoint(x: self.frame.size.width / 2.8, y: self.frame.size.height / 2)
        addChild(dumby)
        
        // Call an instance of the Birdy node
        birdy = Birdy(size: CGSizeMake(MovingBirdyTexture.size().width, MovingBirdyTexture.size().height))
        birdy.position = CGPoint(x: self.frame.size.width / 2.8, y: self.frame.size.height / 2)
        
        // SKPhiscs body properties
        birdy.physicsBody = SKPhysicsBody(circleOfRadius: birdy.size.height / 2)
        birdy.physicsBody?.dynamic = true
        birdy.physicsBody?.allowsRotation = false
        
        // Add birdy to is own category
        birdy.physicsBody?.categoryBitMask = birdyCategory
        
        // Birdy can collide with the world and the pipes category
        birdy.physicsBody?.collisionBitMask =  worldCategory | pipeCategory
        
        // Notification is made whern the birdy collides with the worldground or the pipes
        birdy.physicsBody?.contactTestBitMask = worldCategory | pipeCategory
        
        // Create a floor so the birdy can't fall through the botton of the GameScene
        groundLevel.position = CGPointMake(self.frame.width / 2, movingGroundTexture.size().height / 2)
        
        // SKPhysics body properties
        groundLevel.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, movingGroundTexture.size().width))
        groundLevel.physicsBody?.dynamic = false
        
        // Add the ground to the world category for collision detection
        groundLevel.physicsBody?.categoryBitMask = worldCategory
        
        // Notification is made when the Birdy collides with the ground
        groundLevel.physicsBody?.contactTestBitMask = birdyCategory
        self.addChild(groundLevel)
        
        // Create a boundary around the edge of the screen 
        skyLimit.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        skyLimit.physicsBody?.friction = 0
        
        // Add the ground to the world category for collision detection
        skyLimit.physicsBody?.categoryBitMask = worldCategory
        
        // Notification is made when the Birdy collides with the ground
        skyLimit.physicsBody?.contactTestBitMask = birdyCategory
        self.addChild(skyLimit)
        
        // Setting up the score label and adding it to the scene
        score = 0
        scoreLabelNode.fontName = "Halvetica"
        scoreLabelNode.position = CGPointMake(self.frame.size.width / 1.2, self.frame.size.height / 1.2)
        scoreLabelNode.fontColor = UIColor.darkGrayColor()
        scoreLabelNode.zPosition = 1
        scoreLabelNode.text = "\(score)"
        scoreLabelNode.fontSize = 65
        self.addChild(scoreLabelNode)
        
        // Checking the MuteState in NSUserDefaults
        checkMuteState()
        
        // Retrieve the MuteState from NSUserDefualts
        retrieveMuteState()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        addStuffToTheScene()
        alreadyAddedToTheScene = true
        
        if (moving.speed > 0) {
            birdy.physicsBody?.velocity = CGVectorMake(0, 0)
            birdy.physicsBody?.applyImpulse(CGVectorMake(0, 31))
        }

    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        if (moving.speed > 0) {
            // Tilts the birdy up and down
            birdy.zRotation = self.tiltConstraints(-1, max: 0.5, value: birdy.physicsBody!.velocity.dy * (birdy.physicsBody!.velocity.dx < 0 ? 0.003 : 0.001))
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        // Dectect to see if the scene is moving as collision detection should only work when the scene is moving
        if (moving.speed > 0) {
            if((contact.bodyA.categoryBitMask & scoreCategory) == scoreCategory || (contact.bodyB.categoryBitMask & scoreCategory) == scoreCategory) {
                // Increments the score
                score++
                
                //  Saving the score to be used Game Over Scene
                kScore = score
                
                // Update the scoreLabelNode in the scene to display the users current score
                scoreLabelNode.text = "\(score)"
            }else {
                // Stop the scene from de moving
                moving.speed = 0
                
                // Collision detection with the world category
                birdy.physicsBody?.collisionBitMask = worldCategory
             
                // An attempyt to bring the birdy to the ground after a collision has been detected
                let rotateBirdy = SKAction.rotateByAngle(0.01, duration: 0.003)
                let stopBirdy = SKAction.runBlock({() in self.killSpeed()})
                let slowDownSequence = SKAction.sequence([rotateBirdy, stopBirdy])
                birdy.runAction(slowDownSequence)

                // Stop game scene audio when a collision is detect
                gameSceneAudioPlayer.stop()
                
                // Play the game over effect when a collision is detected
                playGameOverEffectAudio()
                
                // Take screenshot and save to a variable
                if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
                    delay(0.2) {
                        // Call the function that takes the screenshot
                        self.gameEndScreenShot()
                    }
                }
                
                // Save the high score
                saveTheScore()
                
                delay(0.5) {
                    self.gameOver()
                }
            }
        }
    }
    
    func addStuffToTheScene () {
        if alreadyAddedToTheScene == false {
            // Call everything you want to be added to the scene
            movingGround.begin()
            movingBackground.begin()
            movingMidGround.begin()
            movingForeground.begin()
            self.runAction(spawnThenDelayForever)
            dumby.removeFromParent()
            addChild(birdy)
            birdy.begin()
            playGameSceneAudio()
        }
        
    }
    
    func spawnPipes() {
        // A node to add the two pipes too
        let pipePair = SKNode()
        pipePair.position = CGPointMake(self.frame.size.width + Pipe1Texture.size().width, 0)
        pipePair.zPosition = 0
        
        // Pipes variable starting y position
        let height = UInt(self.frame.height / 3)
        let y = UInt(arc4random()) % height
        // Create a pipe1 node and add it to the pipePair node
        let pipe1 = SKSpriteNode(texture: Pipe1Texture)
        pipe1.position = CGPointMake(0.0, CGFloat(y))

        // SKPhysis body properties
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipe1.size)
        pipe1.physicsBody?.dynamic = false
        
        // Adds the pipe to the worldCategory for collision detection
        pipe1.physicsBody?.categoryBitMask = pipeCategory
    
        // Notification is mode when the bird collides with the pipe
        pipe1.physicsBody?.contactTestBitMask = birdyCategory
    
        pipePair.addChild(pipe1)

        // Pipe variable gap
        let maxGap = UInt(self.frame.height / 5)
        let minGap = UInt32(self.frame.height / 8)
        let gap = UInt(arc4random_uniform(minGap)) + maxGap
        
        // Create a pipe2 node and add it to the pipePair node
        let pipe2 = SKSpriteNode(texture: Pipe2Texture)
        pipe2.position = CGPointMake(0.0, CGFloat(y) + pipe1.size.height + CGFloat(gap))

        // SKPhysis body properties
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipe2.size)
        pipe2.physicsBody?.dynamic = false
        
        // Adds the pipe to the worldCategory for collision detection
        pipe2.physicsBody?.categoryBitMask = pipeCategory
        
        // Notification is mode when the bird collides with the pipe
        pipe2.physicsBody?.contactTestBitMask = birdyCategory
        
        pipePair.addChild(pipe2)
        
        // Counting/Detecting the score using collision detection on pipe1
        let contactBirdyNode = SKNode()
        contactBirdyNode.position = CGPointMake(pipe1.size.width + birdy.size.width, CGRectGetMidY(self.frame))
        contactBirdyNode.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width, self.frame.height))
        contactBirdyNode.physicsBody?.dynamic = false
        contactBirdyNode.physicsBody?.categoryBitMask = scoreCategory
        contactBirdyNode.physicsBody?.contactTestBitMask = birdyCategory
        pipePair.addChild(contactBirdyNode)
        
        
        pipePair.runAction(movePipesAndRemove)
        
        pipes.addChild(pipePair)

    }
    
    // Birdy tilt constraints for when Birdy moves up and down in the scene
    func tiltConstraints(min: CGFloat, max: CGFloat, value: CGFloat)  -> CGFloat {
        if(value > max) {
            return max
        }else if(value < min){
            return min
        }else {
            return value
        }
    }
    
    func killSpeed () {
        // Birdy speed to 0 when collision detection has occures
        birdy.speed = 0
    }
    
    func delay(delay: Double, closure:() -> () ) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(delay * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), closure)
    }
    
    func playGameSceneAudio() {
        // Setting up the audio player for the game scene audio
        do {
            try gameSceneAudioPlayer = AVAudioPlayer(contentsOfURL:
            gameSceneSound)
            gameSceneAudioPlayer.prepareToPlay()
            gameSceneAudioPlayer.numberOfLoops = -1
            
            // Check to see if the MuteState is true of false
            if kMuteState == true {
                // Sound need to be muted - stopped
                if gameSceneAudioPlayer.playing {
                    gameSceneAudioPlayer.stop()
                }
            }else if kMuteState == false {
                // The sound can be play
                gameSceneAudioPlayer.play()
            }

        } catch {
            print("GameScene. gameSceneAudioPlayer is not available")
        }
        
    }
    
    func playGameOverEffectAudio() {
        // Setting up the audio player for the game scene audio
        do {
            try gameSceneEffectAudioPlayer = AVAudioPlayer(contentsOfURL:
            gameSceneEffectSound)
            gameSceneEffectAudioPlayer.prepareToPlay()
        
            // Check to see if the MuteState is true of false
            if kMuteState == true {
                // Sound need to be muted - stopped
                if gameSceneEffectAudioPlayer.playing {
                    gameSceneEffectAudioPlayer.stop()
                }
            }else if kMuteState == false {
                // The sound can be play
                gameSceneEffectAudioPlayer.play()
            }
        } catch {
            print("GameScene. gameSceneAudioPlayer is not available")
        }
    }
    
    func checkMuteState() {
        // check to see if we already have a key/object saved called MuteState
        if(userSettingsDefaults.objectForKey("MuteState") != nil) {
            
            // We found a match for MuteState so continue on
            
            }else {
                // We did not a match for the key MuteState so lets create it now as false
                userSettingsDefaults.setBool(false, forKey: "MuteState")
                userSettingsDefaults.synchronize()
            }
    }
    
    func retrieveMuteState() {
        // Retrieve the MuteState from NSUserDefaults
        kMuteState = userSettingsDefaults.boolForKey("MuteState")
    }
    
    func gameEndScreenShot() {
        // Takes a screenshot using the extension of the UIView method in the GameViewController
        let takeScreenShoot =  self.view?.takeSnapShot()
        
        // Save the screen shot to a constant variable so it can be called from another swift file
        kScreenShot = takeScreenShoot!
    }
    
    func saveTheScore() {
        // Check to see if the current score is a Higher number that what is stored in the constant variable kGameSceneHighScore
        if score > kGameSceneHighScore {
            // if it is then assign the value of score to kGameSceneHighScore
            kGameSceneHighScore = score
            
            // Save the highscore to NSUserDefaults
            userSettingsDefaults.setInteger(kGameSceneHighScore, forKey: "GameSceneHighScore")
            
            // Setting up a trigger to display a label message in the GameOver scene
            kNewHighScore = true
        }
        
    }
    
    func gameOver () {
        // Create the new scene to transition too
        let skView = self.view! as SKView
        skView.ignoresSiblingOrder = true

        // Remove scene before transmitioning
        self.scene?.removeFromParent()
        
        // The transition effect
        let transition = SKTransition.fadeWithColor(UIColor.grayColor(), duration: 1.0)
        transition.pausesOutgoingScene = false
        
        // A variable to hold the GameOver scene
        var scene: GameOver!
        scene = GameOver(size: skView.bounds.size)
        
        // Setting the new scene's aspect ration to fill
        scene.scaleMode = .AspectFill
        
        // Presenting the new scene with a transition affect
        skView.presentScene(scene, transition: transition)
    }
}
