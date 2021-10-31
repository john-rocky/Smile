//
//  ChooseTimingGame.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class ChooseTimingGame: Game{
    var logic:ChooseTimingLogic
    
    override func handleSmile() {
        logic.handleSmile()
    }
    
    @objc func swipeRight() {
        logic.objectIndex -= 1
    }
    
    @objc func swipeLeft() {
        logic.objectIndex += 1
    }
    
    override init() {
        logic = ChooseTimingLogic([])
    }
}
