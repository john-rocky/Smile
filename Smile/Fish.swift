//
//  Fish.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/25.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import GameplayKit

class Fish:Game {
    var fishNodes:[SCNNode] = []
    var fishPositions:[SCNVector3] = []
    var isMovings:[Bool] = []
    
    var renderingTime:TimeInterval = 0
    var delta:TimeInterval = 0
    
    
    
    override func updateGame() {
        if !isActioning {
        for _ in 0...3 {
        let randomIndex = Int.random(in: 0...22)
        let randomTime = Double.random(in: 3...8)
        let randomPosition = random(Float(-5)...Float(5))
            let radianX = atan2f(randomPosition.x - fishNodes[randomIndex].worldPosition.x,randomPosition.z - fishNodes[randomIndex].worldPosition.z)
             let radianY = atanf(randomPosition.y - fishNodes[randomIndex].worldPosition.y)
        let pivot = fishNodes[randomIndex].childNode(withName: "pivot", recursively: true)

        if !isMovings[randomIndex]{
            isMovings[randomIndex] = true
            pivot?.runAction(SCNAction.rotateTo(x:  -CGFloat(radianY), y: CGFloat(radianX), z:0, duration: randomTime))
            fishNodes[randomIndex].runAction(SCNAction.move(to: randomPosition, duration: randomTime),completionHandler: {
                self.isMovings[randomIndex] = false
            })
        }
            }
            }
    }
    
    override func handleSmile() {
        isActioning = true
        for index in fishNodes.indices {
            fishNodes[index].removeAllActions()
            isMovings[index] = false
             let pivot = fishNodes[index].childNode(withName: "pivot", recursively: true)
            pivot?.removeAllActions()
                let radianX = atan2f(fishPositions[index].x - fishNodes[index].worldPosition.x,fishPositions[index].z - fishNodes[index].worldPosition.z)
                let radianY = atanf(fishPositions[index].y - fishNodes[index].worldPosition.y)
            pivot?.runAction(SCNAction.rotateTo(x:  -CGFloat(radianY), y: CGFloat(radianX), z:0, duration: 0.5))
            fishNodes[index].runAction(SCNAction.sequence([SCNAction.move(to: fishPositions[index], duration: 1),SCNAction.wait(duration: 2)]),completionHandler: {
                self.isActioning = false
            })
        }
        isCameraAppear = true
    }
    
    override init() {
        super.init()
        scene = SCNScene(named: "art.scnassets/fish.scn")!
        
        
        for node in scene.rootNode.childNodes {
            if node.name != nil {
                if node.name!.contains("fish"){
                    fishNodes.append(node)
                    fishPositions.append(node.worldPosition)
                    let tale = node.childNode(withName: "tale", recursively: true)
                    let pivotBody = node.childNode(withName: "pivotbody", recursively: true)
                    let cone = SCNNode(geometry: SCNCone(topRadius: 0, bottomRadius: 0.5, height: 1))
                    tale?.addChildNode(cone)
                    cone.position = SCNVector3(0.062, 0.022, -0.005)
                    cone.scale = SCNVector3(0.166, 0.166, 0.12)
                    cone.rotation = SCNVector4(0, 0, 1, 2)
                    cone.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
                    isMovings.append(false)
                    let randomTime = Double.random(in: 0.2...0.3)
//                    tale?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: 0.3, z: 0, duration: randomTime),SCNAction.rotateBy(x: 0, y: -0.3, z: 0, duration: randomTime)])))
                    pivotBody!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: -0.3, z: 0, duration: randomTime),SCNAction.rotateBy(x: 0, y: 0.3, z: 0, duration: randomTime)])))
                    let position = random(Float(-5)...Float(3))
                    node.worldPosition = position
                }
            }
        }
        
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
    
    func random(_ range:ClosedRange<Float>)->SCNVector3 {
        let z = Float.random(in: range)
        let defaultX:Float = 0
        let defaultY:Float = -5
        var plus:Float = 0
        switch z {
        case 4...:
            plus = 0
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case 3..<4:
            plus = 0.3
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case 2..<3:
            plus = 0.5
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case 1..<2:
            plus = 1
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case 0..<1:
            plus = 2
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case -1..<0:
            plus = 2.5
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case -2 ..< -1:
            plus = 3
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case -3 ..< -2:
            plus = 3.5
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case -4 ..< -3:
            plus = 4
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        case -5 ..< -4:
            plus = 4.5
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        default:
            plus = 0.5
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus)...(defaultY + plus)),z)
        }
    }
}

extension SCNVector3 {
    
}
