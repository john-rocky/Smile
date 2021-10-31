//
//  ChickCamera.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/03.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import CoreHaptics

class ChickCamera:Camera {

    override func handleSmile(){
        game.playHapticsFile("DogHelloSmile")
        let beakTop =  contentNode.childNode(withName: "beaktop", recursively: true)
        let beakBottom =  contentNode.childNode(withName: "beakbottom", recursively: true)
        let wingLeft = contentNode.childNode(withName: "wingleft", recursively: true)
        let wingRight = contentNode.childNode(withName: "wingright", recursively: true)
        let wingUp = SCNAction.move(by: SCNVector3(x: 0, y: 0.1, z: 0), duration: 0.5)
        let wingDown = SCNAction.move(by: SCNVector3(x: 0, y: -0.1, z: 0), duration: 0.5)
        let beakUp = SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)
        let beakDown = SCNAction.move(by: SCNVector3(x: 0, y: -0.05, z: 0), duration: 0.5)
        wingLeft?.runAction(SCNAction.sequence([wingDown,wingUp,wingDown,wingUp]))
        wingRight?.runAction(SCNAction.sequence([wingDown,wingUp,wingDown,wingUp]))
        beakTop?.runAction(SCNAction.sequence([beakUp,beakDown,beakUp,beakDown]))
        beakBottom?.runAction(SCNAction.sequence([beakDown,beakUp,beakDown,beakUp]))
    }
    
    
    
    override init() {
        super.init()
        game.createEngine()
        contentNode = SCNReferenceNode(named: "chickcamera", loadImmediately: true).childNode(withName: "box", recursively: false)!
    }
}
