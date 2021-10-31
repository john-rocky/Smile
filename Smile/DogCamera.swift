//
//  DogCamera.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/28.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import CoreHaptics

class DogCamera:Camera {

    override func handleSmile(){
        game.playHapticsFile("DogHelloSmile")
        let dogTale = contentNode.childNode(withName: "tale", recursively: true)
        let taleFurifuri = SCNAction.repeat(SCNAction.sequence([ SCNAction.rotateTo(x: 0.5, y: 0, z: 1.2, duration: 0.25),SCNAction.rotateTo(x: 0.5, y: 0, z: -1.2, duration: 0.25)]),count: 8)
        dogTale?.runAction(taleFurifuri)
    }
    
    
    
    override init() {
        super.init()
        game.createEngine()
        contentNode = SCNReferenceNode(named: "utils", loadImmediately: true).childNode(withName: "box", recursively: false)!
        let dog = contentNode.childNode(withName: "dog", recursively: false)
        let dogBody = dog!.childNode(withName: "body", recursively: true)
        dogBody?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 0.16, duration: 1),SCNAction.scale(to: 0.15, duration: 1)])))
    }
}
