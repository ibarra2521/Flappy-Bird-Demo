//
//  MovingMidGround.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

//import Foundation
import UIKit
import SpriteKit

class MovingMidGround: SKSpriteNode {
    let MovingMidgroundTexture = SKTexture(imageNamed: "MovingMidground")
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(MovingMidgroundTexture.size().width, MovingMidgroundTexture.size().height))
        
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        
        // Looping the midground mountain texture from left to right
        for var i:CGFloat = 0; i < 2 + self.frame.size.width / (MovingMidgroundTexture.size().width); i++ {
            let groundSprite = SKSpriteNode(texture: MovingMidgroundTexture)
            groundSprite.zPosition = -2
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
        let moveGroundSprite = SKAction.moveByX(-MovingMidgroundTexture.size().width, y: 0, duration: NSTimeInterval(0.08 * MovingMidgroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingMidgroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([moveGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
    }

}