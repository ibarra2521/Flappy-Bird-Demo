//
//  Dumby.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/10/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

import UIKit
import SpriteKit

class Dumby: SKSpriteNode {
    let DumbyTexture = SKTexture(imageNamed: "Birdy1")

    init(size: CGSize) {
        super.init(texture: DumbyTexture, color: UIColor.clearColor(), size: CGSizeMake(size.width, size.height))
        zPosition = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
