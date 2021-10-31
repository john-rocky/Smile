//
//  Hall.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/29.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class Hall: Game {
    
    lazy var hallLogic = HallLogic([])
    
    
    override func updateGame() {
        
        hallLogic.time += 1
        hallLogic.updateLogic()
        if hallLogic.time == 0 ,!hallLogic.isAllCreatureAppeard{
            creaturesAnimationTriger()
        }
    }
    
    override func handleSmile() {

        hallLogic.handleSmile()
        if hallLogic.isCreatureApear {
            smileAnimationTriger()
            hallLogic.isCreatureApear = false
        }
        if hallLogic.time == 0,!hallLogic.isAllCreatureAppeard {
            creaturesAnimationTriger()
        }

        if hallLogic.isAllCreatureAppeard,!isCameraAppear {
            isCameraAppear = true
        }
        playHapticsFile("DogHelloSmile")
        }
    
    override init() {
        super.init()
        needRequestInterval = 5
        scene = SCNScene(named: "art.scnassets/random.scn")!
        hallLogic = HallLogic(["squirrel","cat","rabbit","otter","miacat"])
        creaturesAnimationTriger()
    }
    
    func creaturesAnimationTriger(){
        switch hallLogic.creatures[hallLogic.appearingCreatureIndex] {
        case "squirrel":
            squirrelAction()
            case "cat":
            catAction()
            case "rabbit":
            rabbitAction()
            case "otter":
            otterAction()
            case "miacat":
            miacatAction()
        default:
            addCamera()
        }
    }
    
    func smileAnimationTriger(){
        switch hallLogic.friends.last {
        case "squirrel":
            squirrelSmileAction()
            case "cat":
            catSmileAction()
            case "rabbit":
            rabbitSmileAction()
            case "otter":
            otterSmileAction()
            case "miacat":
            miacatSmileAction()
        default:
break
            
        }
    }
    
    func squirrelSmileAction() {
        let squirrel = scene.rootNode.childNode(withName: "squirrel", recursively: false)
        squirrel?.removeAllActions()
        let smilePosition = SCNVector3(0.268, 0.312, -1.857)
        let lookAt = SCNAction.run { (SCNNode) in
            squirrel?.childNode(withName: "head", recursively: true)!.runAction(SCNAction.rotateTo(x: -0.3, y: -0.2, z: 0, duration: 1))
        }
        squirrel?.runAction(SCNAction.sequence([
            SCNAction.move(to: smilePosition, duration: 2),
            lookAt
        ]))
    }
    
    func catSmileAction() {
        let cat = scene.rootNode.childNode(withName: "cat", recursively: false)
        cat?.removeAllActions()
        let smilePosition = SCNVector3(-0.271, 0.627, -1.932)
        let lookAt = SCNAction.run { (SCNNode) in
            cat?.childNode(withName: "head", recursively: true)!.runAction(SCNAction.rotateTo(x: -0.2, y: 0.2, z: 0, duration: 1))
        }
        cat?.runAction(SCNAction.sequence([
            SCNAction.move(to: smilePosition, duration: 2),
            lookAt
        ]))
    }
    
    func rabbitSmileAction(){
        let rabbit = scene.rootNode.childNode(withName: "rabbit", recursively: false)
        rabbit?.removeAllActions()
        let smilePosition = SCNVector3(0.378, 0.704, -3.602)
        let lookAt = SCNAction.run { (SCNNode) in
            rabbit?.childNode(withName: "head", recursively: true)!.runAction(SCNAction.rotateTo(x: -0.6, y: -0.1, z: 0, duration: 1))
        }
        rabbit?.runAction(SCNAction.sequence([
            SCNAction.move(to: smilePosition, duration: 2),
            lookAt
        ]))
    }
    
    func otterSmileAction(){
        let otter = scene.rootNode.childNode(withName: "otter", recursively: false)
        otter?.removeAllActions()
        let smilePosition = SCNVector3(-0.313, 0.356, -3.872)
        let lookAt = SCNAction.run { (SCNNode) in
            otter?.childNode(withName: "head", recursively: true)!.runAction(SCNAction.rotateTo(x: -0.3, y: 0.1, z: 0, duration: 1))
        }
        otter?.runAction(SCNAction.sequence([
            SCNAction.move(to: smilePosition, duration: 2),
            lookAt
        ]))
    }
    
    func miacatSmileAction(){
        let miacat = scene.rootNode.childNode(withName: "miacat", recursively: false)
        miacat?.removeAllActions()
        let smilePosition = SCNVector3(-0.709, 0.668, -5.827)
        let lookAt = SCNAction.run { (SCNNode) in
            miacat?.childNode(withName: "head", recursively: true)!.runAction(SCNAction.rotateTo(x: 0.3, y: -0.1, z: 0, duration: 1))
        }
        miacat?.runAction(SCNAction.sequence([
            SCNAction.move(by: SCNVector3(x: 0, y: 0, z: 2), duration: 0.3),
            SCNAction.move(to: smilePosition, duration: 2),
            lookAt
        ]))
    }
    
    func squirrelAction(){
        let squirrel = scene.rootNode.childNode(withName: "squirrel", recursively: false)
        if (squirrel?.worldPosition.x)! > Float(0) {
        squirrel?.runAction(SCNAction.sequence([
            SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.05 - 0.25),
            SCNAction.rotateBy(x: 0, y: 0, z: 0.2, duration: 0.1),
            SCNAction.move(to: SCNVector3(0.55, 0.312, -9.425), duration: 0.1),
            SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.05 - 0.25),
            SCNAction.rotateBy(x: 0, y: -1.1, z: -0.2, duration: 0.1),
            SCNAction.move(to: SCNVector3(0.03, 0.312, -9.425), duration: 0.1),
            SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1),
            SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1),
            SCNAction.rotateBy(x: 0, y: -1.1, z: 0, duration: 0.1),
            SCNAction.move(to: SCNVector3(-0.946, 0.312, -9.425), duration: 0.1),
            SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1)
        ]))
            }else {
            squirrel?.runAction(SCNAction.sequence([
            SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.05 - 0.25),
            SCNAction.rotateBy(x: 0, y: 0, z: -0.2, duration: 0.1),
            SCNAction.move(to: SCNVector3(-0.45, 0.312, -9.425), duration: 0.1),
            SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.05 - 0.25),
            SCNAction.rotateBy(x: 0, y: 1.1, z: 0.2, duration: 0.1),
            SCNAction.move(to: SCNVector3(0.03, 0.312, -9.425), duration: 0.1),
            SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1),
            SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1),
            SCNAction.rotateBy(x: 0, y: 1.1, z: 0, duration: 0.1),
            SCNAction.move(to: SCNVector3(1.152, 0.312, -9.425), duration: 0.1),
            SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1)
            ]))
        }
    }
    
    func catAction(){
        let cat = scene.rootNode.childNode(withName: "cat", recursively: false)
        let sleep = SCNAction.run { (SCNNode) in
            cat?.childNode(withName: "wake", recursively: false)?.isHidden = true
            cat?.childNode(withName: "sleep", recursively: false)?.isHidden = false
        }
        let wake = SCNAction.run { (SCNNode) in
            cat?.childNode(withName: "wake", recursively: false)?.isHidden = false
            cat?.childNode(withName: "sleep", recursively: false)?.isHidden = true
        }
        if (cat?.worldPosition.x)! > Float(0) {
        cat?.runAction(SCNAction.sequence([
            SCNAction.rotateBy(x: 0, y: -1.1, z: 0, duration: 0.1),
            SCNAction.move(to: SCNVector3(0.00, 0.627, -9.425), duration: Double(hallLogic.hiddingTime) * 0.1 * 0.15),
            SCNAction.rotateBy(x: 0, y: 1.1, z: 0, duration: Double(hallLogic.hiddingTime) * 0.1 * 0.15),
            sleep,
            SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.1 * 0.7 - 0.1),
            wake,
            SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1),
            SCNAction.rotateBy(x: 0, y: -1.1, z: 0, duration: 0.1),
            SCNAction.move(to: SCNVector3(-0.946, 0.627, -9.425), duration: 0.1),
            SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1),
        ]))
            } else {
            cat?.runAction(SCNAction.sequence([
                SCNAction.rotateBy(x: 0, y: 1.1, z: 0, duration: 0.1),
                SCNAction.move(to: SCNVector3(0.00, 0.627, -9.425), duration:  Double(hallLogic.hiddingTime) * 0.1 * 0.15),
                SCNAction.rotateBy(x: 0, y: -1.1, z: 0, duration:  Double(hallLogic.hiddingTime) * 0.1 * 0.15),
                sleep,
                SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.1 * 0.7 - 0.1),
                wake,
                SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1),
                SCNAction.rotateBy(x: 0, y: 1.1, z: 0, duration: 0.1),
                SCNAction.move(to: SCNVector3(1.152, 0.627, -9.425), duration: 0.1),
                SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1),
            ]))
        }
    }
    
    func rabbitAction() {
        let rabbit = scene.rootNode.childNode(withName: "rabbit", recursively: false)
        let rabbitPosition = rabbit?.worldPosition
        rabbit?.runAction(SCNAction.sequence([
                   SCNAction.move(to: SCNVector3(0.00, 0.704, -9.425), duration: Double(hallLogic.hiddingTime) * 0.1),
                   SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1),
                   SCNAction.rotateBy(x: 0, y: -2.2, z: 0, duration: 0.1),
                   SCNAction.move(to: rabbitPosition!, duration: 0.1),
                   SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1)
               ]))
    }
    
    func otterAction(){
        let otter = scene.rootNode.childNode(withName: "otter", recursively: false)
        let otterPosition = otter?.worldPosition
        otter?.runAction(SCNAction.sequence([
            SCNAction.rotateBy(x: 0, y: -1.1, z: 0, duration: 0.1),
                   SCNAction.move(to: SCNVector3(0.00, 0.356, -9.425), duration: Double(hallLogic.hiddingTime) * 0.1 * 0.8 - 0.1),
                   SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: Double(hallLogic.hiddingTime) * 0.1 * 0.2),
                   SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1 * 0.9),
                   SCNAction.rotateBy(x: 0, y: 1.1, z: 0, duration:  Double(hallLogic.appearingTime) * 0.1 * 0.1),
                   SCNAction.move(to: otterPosition!, duration: 0.29),
                   SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.01)
               ]))
    }
    
    func miacatAction(){
     let miacat = scene.rootNode.childNode(withName: "miacat", recursively: false)
     miacat?.runAction(SCNAction.sequence([
        SCNAction.wait(duration: Double(hallLogic.hiddingTime) * 0.1 - 0.3),
                SCNAction.move(by: SCNVector3(0.00, 1.584, 0), duration: 0.3),
                SCNAction.wait(duration: Double(hallLogic.appearingTime) * 0.1),
                SCNAction.move(by: SCNVector3(0.00, -1.584, 0), duration: 0.3)
            ]))
    }
}


