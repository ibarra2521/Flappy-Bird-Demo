//
//  MovingGround.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

//import Foundation
import SpriteKit

class MovingGround: SKSpriteNode {
    let MovingGroundTexture = SKTexture(imageNamed: "MovingGround")
    
    init(size: CGSize) {
        super.init(texture: nil, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        anchorPoint = CGPointMake(0, 0)
        position = CGPointMake(0.0, 0.0)
        zPosition = 1
        
        // Looping the ground image from left to right
        for var i:CGFloat = 0; i < 2 + self.frame.size.width / (MovingGroundTexture.size().width); i++ {
            let groundSprite = SKSpriteNode(texture: MovingGroundTexture)
            groundSprite.zPosition = 0
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
        let moveGroundSprite = SKAction.moveByX(-MovingGroundTexture.size().width, y: 0, duration: NSTimeInterval(0.004 * MovingGroundTexture.size().width))
        let resetGroundSprite = SKAction.moveByX(MovingGroundTexture.size().width, y: 0, duration: 0.0)
        let moveSequence = SKAction.sequence([moveGroundSprite, resetGroundSprite])
        runAction(SKAction.repeatActionForever(moveSequence))
    }
    
}
