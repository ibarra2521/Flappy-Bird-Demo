//
//  Birdy.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

import UIKit
import SpriteKit

class Birdy: SKSpriteNode {
    let MovingBirdy1Texture = SKTexture(imageNamed: "Birdy1")
    let MovingBirdy2Texture = SKTexture(imageNamed: "Birdy2")
    
    init(size: CGSize) {
        super.init(texture: MovingBirdy1Texture, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func begin() {
        // Flipping wings animation
        let animation = SKAction.animateWithTextures([MovingBirdy1Texture, MovingBirdy2Texture], timePerFrame: 0.2)
        runAction(SKAction.repeatActionForever(animation))
        
    }
}