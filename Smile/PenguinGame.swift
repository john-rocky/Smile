//
//  PenguinGame.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class PenguinGame:Game {
    var updateTime = 10
    lazy var logic = PenguinLogic()
    
    var matchPosition = SCNVector3()
    
    override func updateGame() {
       
        if time == updateTime - 5 {
            if logic.time == logic.rythm.count - 1 {
                logic.time = 0
            }
            if logic.rythm[logic.time + 1] == 1 {
                let penguin = scene.rootNode.childNode(withName: "penguin", recursively: false)
                penguin?.childNode(withName: "wingright", recursively: true)?.runAction(SCNAction.sequence([
                SCNAction.rotateBy(x: -2.2, y: 0, z: 0, duration: 0.25),
                SCNAction.rotateBy(x: 2.2, y: 0, z: 0, duration: 0.2)
                ]))
            }
        }
        
        if time == updateTime {
            logic.updateGame()
            time = 0
            
            if logic.rythm[logic.time] == 1 {
                       let penguin = scene.rootNode.childNode(withName: "penguin", recursively: false)?.clone()
                penguin?.name = "p\(logic.time)"
                       scene.rootNode.addChildNode(penguin!)
                        
                       penguin?.runAction(SCNAction.sequence([
                           SCNAction.move(to: matchPosition, duration: 0.3),
                           SCNAction.wait(duration: 0.5),
                           SCNAction.move(by: SCNVector3(0, 0, 10), duration: 0.3)
                       ]))
                   }
        }
    }
    override func handleSmile() {
        logic.isSmile = true
        if logic.rythm[logic.time] == 1,time > 3 {
            logic.friendCount += 1
            smileCounter += 1
            let penguin = scene.rootNode.childNode(withName: "p\(logic.time)", recursively: false)!
                penguin.removeAllActions()
            penguin.runAction(SCNAction.sequence([
                SCNAction.move(by: SCNVector3(0, 10, 0), duration: 0.1),
                SCNAction.rotateTo(x: 0, y: -1.1, z: 0, duration: 0.1),
                SCNAction.move(to: SCNVector3(1, 0.545, Double(5 - logic.friendCount)), duration: 0.1)
            ]))
        }
        playHapticsFile("DogHelloSmile")
        if logic.friendCount == 8 {
            isCameraAppear = true
        }
    }
    
    override init() {
        super.init()
        scene = SCNScene(named: "art.scnassets/penguin.scn")!
        createEngine()
        let position = scene.rootNode.childNode(withName: "position", recursively: false)?.worldPosition
        matchPosition = SCNVector3(x: position!.x, y: 0.545, z: position!.z)
    }
}
