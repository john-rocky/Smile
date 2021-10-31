//
//  Fox.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/02.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import Foundation
import SceneKit
import CoreHaptics

class Fox: Game{
    lazy var logic = ExternalLogic()
    
    override init() {
        super.init()
        createEngine()
        scene = SCNScene(named: "art.scnassets/fox.scn")!
        let fox = scene.rootNode.childNode(withName: "fox", recursively: false)!
        let girl = scene.rootNode.childNode(withName: "girl", recursively: false)!
        let tale = girl.childNode(withName: "foxtale", recursively: true)
        tale?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: 0, z: 0.5, duration: 0.5),SCNAction.rotateBy(x: 0, y: 0, z: -0.5, duration: 0.5)])))
    }
    
    override func handleSmile() {
        logic.smileCount += 1
        let fox = scene.rootNode.childNode(withName: "fox", recursively: false)!
        let girl = scene.rootNode.childNode(withName: "girl", recursively: false)!
        let notSmile = girl.childNode(withName: "notsmile", recursively: true)
        let smile = girl.childNode(withName: "smile", recursively: true)
        let smileeye = girl.childNode(withName: "smileeye", recursively: true)
        let tale = girl.childNode(withName: "foxtale", recursively: true)
        let foxear = girl.childNode(withName: "foxear", recursively: true)
        let smileAppear = SCNAction.run { (SCNNode) in
            notSmile?.isHidden = true
            smile?.isHidden = false
            smileeye?.isHidden = false
        }
        let smileDisappear = SCNAction.run { (SCNNode) in
            notSmile?.isHidden = false
            smile?.isHidden = true
            smileeye?.isHidden = true
        }
        let smileAction = SCNAction.sequence([smileAppear,SCNAction.wait(duration: 2),smileDisappear])
        switch logic.smileCount {
        case 1:
            let foxpivot = fox.childNode(withName: "foxpivot", recursively: true)
            
            fox.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: 1.5, z: 0), duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: -1.5, z: 0), duration: 0.5)]))
            foxpivot?.runAction(SCNAction.rotateBy(x: 6.28319, y: 0, z: 0, duration: 1),completionHandler: {
                fox.isHidden = true
                girl.isHidden = false
            })
            self.playHapticsFile("DogHelloSmile")
        case 2:
            girl.runAction(smileAction)
            self.playHapticsFile("DogHelloSmile")
            
        case 3:
            girl.runAction(smileAction)
            tale?.isHidden = false
            self.playHapticsFile("DogHelloSmile")
        case 4:
            girl.runAction(smileAction)
            foxear?.isHidden = false
            self.playHapticsFile("DogHelloSmile")
            isCameraAppear = true
        default:
            girl.runAction(smileAction)
            self.playHapticsFile("DogHelloSmile")
            
        }
    }
    
    override func addCamera() {
        let camera = SCNReferenceNode(named: "utils", loadImmediately: true).childNode(withName: "arcamera", recursively: false)
        camera?.worldPosition = SCNVector3(x: 0, y: 2.5, z: -1)
        scene.rootNode.addChildNode(camera!)
        isCameraAppear = true
    }
}
