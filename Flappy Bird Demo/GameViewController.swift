//
//  GameViewController.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright (c) 2016 Nivardo Ibarra. All rights reserved.
//

import UIKit
import SpriteKit
import Social
import GameKit

// Extending the UIView (view) to take a screenshot
extension UIView {
    func takeSnapShot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, 1.0)
        drawViewHierarchyInRect(self.bounds, afterScreenUpdates: false)
        CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), CGInterpolationQuality.Low)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            skView.showsPhysics = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            scene.size = skView.bounds.size
            skView.presentScene(scene)
        }
        
        // Advice NSNotification Centre of the facebook view controller to lounch
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showFacebookSheet:", name: "FacebookID", object: nil)
        
        // Initiate Game Center
        authenticateLocalPlayer()
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func showFacebookSheet(notification: NSNotification) {
        let facebookSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        facebookSheet.completionHandler = {
            result in
            switch result {
                case SLComposeViewControllerResult.Cancelled:
                
                // Add some code to deal with the cancellation
                    break
                case SLComposeViewControllerResult.Done:
                
                // Add some code to deal with post being completed
                    break
            }
        }
        // Content of the Facebook post
        facebookSheet.setInitialText("Enter some text\n\n ")
        facebookSheet.addImage(kScreenShot)
        facebookSheet.addURL(NSURL(string: "http://iosnandn.simplesite.com/"))
        
        self.presentViewController(facebookSheet, animated: false, completion: {
            // Optional completion code
            
        })
    }
    
    func authenticateLocalPlayer() {
        // Prepare the Game View Controller
        let localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            if (viewController != nil) {
                // Display the Game Center ViewController as the user has not signed in to Game Center
                self.presentViewController(viewController!, animated: true, completion: nil)
            }else {
                // Display the Game Center username in the console window
                print((GKLocalPlayer.localPlayer().authenticated))
                print("Local player alias \(localPlayer.alias)")
                
                // Prepare alias to be saved to local storage
                let alias = localPlayer.alias
                print("Game Center Alias \(alias)")
                
                // Set up NSUserDefults save method
                let defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
                
                // Save the Game Center Username to local storage
                defaults.setObject(alias, forKey: "currentPlayer")
            }
        }
    }
}
