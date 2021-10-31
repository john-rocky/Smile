//
//  And.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/29.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class And: Game {
    
    var A = [
        0,0,0,0
    ]
    
    var B = [
        0,0,0,0
    ]
    
    var hallCount = 15
    
    override func updateGame() {
        
    }
    
    override func handleSmile() {
        
        playHapticsFile("DogHelloSmile")
    }
    
    override init() {
        super.init()
        scene = SCNScene(named: "art.scnassets/squirrel.scn")!
    }
}
