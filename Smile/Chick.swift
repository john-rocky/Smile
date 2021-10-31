//
//  Chick.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/25.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit

class Chick:Game {
    // Set Animatational Node.
    
    override func handleSmile() {
        isActioning = true
        smileCounter += 1
        let egg = scene.rootNode.childNode(withName: "egg", recursively: false)
        let bottom = egg?.childNode(withName: "bottom", recursively: true)
        let full = egg?.childNode(withName: "full", recursively: true)
        let shell = egg?.childNode(withName: "shell", recursively: true)
        let beak = egg?.childNode(withName: "beak", recursively: true)
        let chick = scene.rootNode.childNode(withName: "chick", recursively: false)
        let top = chick?.childNode(withName: "top", recursively: true)
        let wingLeft = chick?.childNode(withName: "wingleft", recursively: true)
        let wingRight = chick?.childNode(withName: "wingright", recursively: true)
        let legLeft = chick?.childNode(withName: "legleft", recursively: true)
        let legRight = chick?.childNode(withName: "legright", recursively: true)
        let beakTop = chick?.childNode(withName: "beaktop", recursively: true)
        let beakBottom = chick?.childNode(withName: "beakbottom", recursively: true)
        let pivotCenter = chick?.childNode(withName: "pivotcenter", recursively: true)
        let pivotleft = chick?.childNode(withName: "pivotleft", recursively: true)
        let pivotright = chick?.childNode(withName: "pivotright", recursively: true)
        let head = chick?.childNode(withName: "head", recursively: true)
        let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
        let dropShell = SCNAction.run { (SCNNode) in
            top?.removeFromParentNode()
            self.scene.rootNode.addChildNode(top!)
            self.playHapticsFile("CameraClick")
        }
        let beakUp = SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)
        let beakDown = SCNAction.move(by: SCNVector3(x: 0, y: -0.05, z: 0), duration: 0.5)
        let legUp = SCNAction.rotateBy(x: -1, y: 0, z: 0, duration: 0.5)
        let legDown = SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 0.5)
        let wingUp = SCNAction.move(by: SCNVector3(x: 0, y: 0.1, z: 0), duration: 0.5)
        let wingDown = SCNAction.move(by: SCNVector3(x: 0, y: -0.1, z: 0), duration: 0.5)

        switch smileCounter {
        case 1:
            playHapticsFile("Boing")
            egg?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0, z: -0.1, duration: 0.5),SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)]),completionHandler: {
                self.isActioning = false
            })
        case 2:
            playHapticsFile("Boing")
            egg?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0, z: 0.1, duration: 0.5),SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)]),completionHandler: {
                self.isActioning = false
            })
        case 3:
            playHapticsFile("PakiPaki")
            shell?.isHidden = false
            egg?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0, z: 0.1, duration: 0.5),SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)]),completionHandler: {
                self.isActioning = false
            })
        case 4:
            playHapticsFile("PariPari")
            beak?.isHidden = false
            egg?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0, z: 0.1, duration: 0.5),SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)]),completionHandler: {
                self.isActioning = false
            })
        case 5:
            playHapticsFile("Baki")

            beak?.isHidden = true
            full?.isHidden = true
            chick?.isHidden = false
            shell?.isHidden = true
            top?.worldPosition = SCNVector3(x: -0.286, y: 0.197, z: 0.983)
                self.isActioning = false
        case 6:
            chick?.runAction(SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 1),completionHandler: {
                self.isActioning = false
            })
        case 7:
//            playHapticsFile("Heartbeats")
            chick?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: -0.5, y: 0, z: 0, duration: 1),dropShell,SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 1)]) ,completionHandler: {
                self.isActioning = false
            })
            top?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1), SCNAction.move(to: SCNVector3(x: 0, y: 0, z: 0), duration: 0.5)]))
            beakTop?.runAction(SCNAction.sequence([SCNAction.wait(duration: 2),beakUp,beakDown,beakUp,beakDown]))
            beakBottom?.runAction(SCNAction.sequence([SCNAction.wait(duration: 2),beakDown,beakUp,beakDown,beakUp]),completionHandler: {
                self.isActioning = false
            })
        case 8:
            pivotright?.runAction(SCNAction.rotateBy(x: 0, y: -1, z: 0, duration: 1))
            pivotleft?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),SCNAction.rotateBy(x: 0, y: 1, z: 0, duration: 1)]))
            bottom?.runAction(SCNAction.sequence([SCNAction.rotateBy(x: 1, y: 0, z: 0, duration: 1),SCNAction.rotateBy(x: -1, y: 0, z: 0, duration: 1)]))
            legLeft?.runAction(SCNAction.sequence([legUp,legDown,legUp,legDown]))
            legRight?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),legDown,legUp,legDown]),completionHandler: {
                self.isActioning = false
            })
        case 9:
            head?.runAction(SCNAction.rotateBy(x: -0.3, y: 0.3, z: 0.3, duration: 0.3),completionHandler: {
                self.isActioning = false
            })
        default:
            isCameraAppear = true
            head?.runAction(SCNAction.rotateTo(x: -0.3, y: 0, z: 0, duration: 0.3))
            camera?.runAction(SCNAction.move(by: SCNVector3(0, 0, 2), duration: 1))
            chick?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),SCNAction.move(to: SCNVector3(x: camera!.worldPosition.x + 0.5, y: chick!.worldPosition.y, z: camera!.worldPosition.z - 5), duration: 2)]))
            pivotCenter?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),SCNAction.rotateBy(x: 0, y: 0, z: 0.1, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: -0.2, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: 0.2, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: -0.2, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: 0.2, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: -0.2, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: 0.2, duration: 0.25),SCNAction.rotateBy(x: 0, y: 0, z: -0.1, duration: 0.25)]))
            legLeft?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),legUp,legDown,legUp,legDown,legUp,legDown,legUp,legDown]))
            legRight?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.5),legUp,legDown,legUp,legDown,legUp,legDown,legUp]))
            wingLeft?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),wingDown,wingUp,wingDown,wingUp]))
            wingRight?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),wingDown,wingUp,wingDown,wingUp]))
            beakTop?.runAction(SCNAction.sequence([SCNAction.wait(duration: 2),beakUp,beakDown,beakUp,beakDown]))
            beakBottom?.runAction(SCNAction.sequence([SCNAction.wait(duration: 2),beakDown,beakUp,beakDown,beakUp]),completionHandler: {
                self.isActioning = false
            })
        }
    }
    
    override init() {
        super.init()
        scene = SCNScene(named: "art.scnassets/chick.scn")!
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        //                cameraNode.constraints = [constraint]
        // place the camera
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 20, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = UIColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
    }
}
