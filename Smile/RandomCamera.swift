//
//  RandomCamera.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/02.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import CoreHaptics

class RandomCamera:Camera {

    var cat = SCNNode()
    
    override func handleSmile(){
        game.playHapticsFile("DogHelloSmile")
    }
    
    
    override init() {
        super.init()
        game = Hall()
        game.createEngine()
        scene = SCNScene(named: "art.scnassets/emptyscene.scn")!
        let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
        cat = SCNReferenceNode(named: "random").childNode(withName: "cat", recursively: false)!
        camera?.addChildNode(cat)
        cat.position = SCNVector3(0, 0, -5)
//        contentNode = SCNReferenceNode(named: "randomcamera", loadImmediately: true).childNode(withName: "box", recursively: false)!
//        contentNode.scale = SCNVector3(0.5, 0.5, 0.5)
//        let dog = contentNode.childNode(withName: "dog", recursively: false)
//        let dogBody = dog!.childNode(withName: "body", recursively: true)
//        dogBody?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 0.16, duration: 1),SCNAction.scale(to: 0.15, duration: 1)])))
    }
}
