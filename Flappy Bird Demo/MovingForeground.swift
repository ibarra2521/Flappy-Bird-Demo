//
//  MovingForeground.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

//import Foundation
import UIKit
import SpriteKit

class MovingForeground: SKSpriteNode {
    let MovingForegroundTexture = SKTexture(imageNamed: "MovingForeground")
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(MovingForegroundTexture.size().width, MovingForegroundTexture.size().height))
        
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        
        // Looping the foreground mountain texture from left to right
        for var i:CGFloat = 0; i < 2 + self.frame.size.width / (MovingForegroundTexture.size().width); i++ {
            let groundSprite = SKSpriteNode(texture: MovingForegroundTexture)
            groundSprite.zPosition = -1
            groundSprite.anchorPoint = CGPointMake(0, 0)
            groundSprite.position = CGPointMake(i * groundSprite.size.width, 0)
            addChild(groundSprite)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        // Moving the ground at speed
        let moveGroundSprite = SKAction.moveByX(-MovingForegroundTexture.size().width, y: 0, duration: NSTimeInterval(0.05 * MovingForegroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingForegroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([moveGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
    }

}
