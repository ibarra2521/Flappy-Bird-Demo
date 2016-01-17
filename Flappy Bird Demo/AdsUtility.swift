//
//  AdsUtility.swift
//  Flappy Bird Demo
//
//  Created by Nivardo Ibarra on 1/11/16.
//  Copyright © 2016 Nivardo Ibarra. All rights reserved.
//

import Foundation

class AdsUtility {
    class func chartboostInterstitial() {
        // Play the add
        Chartboost.showInterstitial(CBLocationGameOver)
        
        // Try to cache the next ad
        Chartboost.cacheInterstitial(CBLocationGameOver)
    }
    
    
}