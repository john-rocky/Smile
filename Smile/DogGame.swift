//
//  DogGame.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/03.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import Foundation
import SceneKit
import CoreHaptics

class DogGame:Game {
    lazy var logic = DogLogic()
    
    override func updateGame() {
            logic.time += 1
            logic.updateLogic()
        
        if logic.time == 0,logic.dogState == 0 {
            defaultAction()
        }
    }
    
    override func handleSmile() {
        if logic.dogState > 0, logic.time > 30 {
        logic.handleSmile()
        switch logic.dogState {
        case 1:
            firstAction()
        case 2:
            secondAction()
        case 3:
            thirdAction()
        case 4:
            fourthAction()
            isCameraAppear = true
        default:
            break
        }
        }
        
        if logic.dogState == 0 {
            logic.handleSmile()
            firstAction()
        }
    }
    
    func defaultAction(){
        print("default")
        
        let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
        let randomWaitTime = Double.random(in: 0...4)
        let restTime = 8 - 2.5 - randomWaitTime
        let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
        let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
        let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
        let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
        let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
        let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
        let head = dog?.childNode(withName: "head", recursively: true)
        let hand = dog?.childNode(withName: "hand", recursively: true)
        let randomX = Float.random(in: -0.5...0.5)
        let randomZ = Float.random(in: -2.5...0)
        let destination = SCNVector3(x: randomX, y: (dog?.worldPosition.y)!, z: randomZ)
        let r = atan2(destination.x - (dog?.worldPosition.x)!, destination.z - (dog?.worldPosition.z)!)
        let rotate = SCNAction.rotateBy(x: 0.5, y: 0, z: 0, duration: 0.25)
        let rotateMinus = SCNAction.rotateBy(x: -0.5, y: 0, z: 0, duration: 0.25)
        let rotateToDestination = SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0 , z: 0, duration: 0.5),SCNAction.wait(duration: 0.5)])
        let rotateAndDownToGround = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)
        let rotateUpTODefault =  SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)
        hand?.isHidden = true
        if (dog?.worldPosition.y)! > Float(0.25) {
            dog?.worldPosition.y = 0.25
        }
        head?.runAction(SCNAction.sequence([
            SCNAction.move(to: SCNVector3(x: 0.03, y: 0.051, z: 0.096), duration: 0.1),
            SCNAction.wait(duration: randomWaitTime + 0.4),
            rotateToDestination,
            rotateAndDownToGround,
            SCNAction.wait(duration: restTime),
            rotateUpTODefault
        ]))
        
        dogpivot?.runAction(SCNAction.sequence([
            SCNAction.wait(duration: 0.5),
            SCNAction.wait(duration: randomWaitTime),
            SCNAction.rotateTo(x: 0, y: CGFloat(r), z: 0, duration: 0.5)]))
        dog?.runAction(SCNAction.sequence([SCNAction.scale(to: 1, duration: 0.4),SCNAction.wait(duration: randomWaitTime + 0.1),SCNAction.move(to: SCNVector3(x: randomX, y: (dog?.worldPosition.y)!, z: randomZ), duration: 1)]))
        legfrontleft?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotate,rotateMinus,rotateMinus,rotate]))
        legfrontright?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotateMinus,rotate,rotate,rotateMinus]))
        legbackleft?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotateMinus,rotate,rotate,rotateMinus]))
        legbackright?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotate,rotateMinus,rotateMinus,rotate]))
    }
    
    func firstAction(){
        print("first")
        playHapticsFile("DogHelloSmile")
        let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
        let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
        let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
        let dogTale = dog?.childNode(withName: "tale", recursively: true)
        let head = dog?.childNode(withName: "head", recursively: true)
        let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
        let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
        let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
        let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
        let taleFurifuri = SCNAction.repeat(SCNAction.sequence([ SCNAction.rotateTo(x: 0.5, y: 0, z: 0.7, duration: 0.05),SCNAction.rotateTo(x: 0.5, y: 0, z: -0.7, duration: 0.05)]),count: 16)
        let ry = atan((camera!.worldPosition.y) - head!.worldPosition.y)
        
        dog?.removeAllActions()
        dogpivot?.removeAllActions()
        legbackleft?.removeAllActions()
        legbackright?.removeAllActions()
        legfrontleft?.removeAllActions()
        legfrontright?.removeAllActions()
        head?.removeAllActions()
        dogTale?.removeAllActions()
        
        dogpivot?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1)]))
        head?.runAction(SCNAction.sequence([
            SCNAction.move(to: SCNVector3(x: 0.03, y: 0.051, z: 0.096),duration: 0.1),
            SCNAction.rotateTo(x: -0.35 , y: 0, z: 0, duration: 0.1)]))
        dog?.runAction(SCNAction.sequence([
            SCNAction.scale(to: 1, duration: 0.1),
            SCNAction.move(to: SCNVector3((camera!.worldPosition.x), 0.25, (camera!.worldPosition.z) - 1.5), duration: 0.5)
        ]))
        dogTale?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5), taleFurifuri]),completionHandler: {
            dogTale?.rotation = SCNVector4(1, 0, 0, -0.5)
        })
    }
    
    func secondAction(){
        print("second")
        playHapticsFile("DogHelloSmile")
         let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
               let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
               let dogTale = dog?.childNode(withName: "tale", recursively: true)
               let head = dog?.childNode(withName: "head", recursively: true)
               let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
               let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
               let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
               let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
               let taleFurifuri = SCNAction.repeat(SCNAction.sequence([ SCNAction.rotateTo(x: 0.5, y: 0, z: 0.7, duration: 0.05),SCNAction.rotateTo(x: 0.5, y: 0, z: -0.7, duration: 0.05)]),count: 16)
               
               dog?.removeAllActions()
               dogpivot?.removeAllActions()
               legbackleft?.removeAllActions()
               legbackright?.removeAllActions()
               legfrontleft?.removeAllActions()
               legfrontright?.removeAllActions()
               head?.removeAllActions()
               dogTale?.removeAllActions()
        dogTale?.runAction(SCNAction.sequence([taleFurifuri]))
        dog?.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(-0.02 , 0, 0), duration: 0.1), SCNAction.scale(to: 2, duration: 0.4),SCNAction.wait(duration: 2)]))
    }
    
    func thirdAction(){
        print("third")
        playHapticsFile("DogHelloSmile")
        let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
        let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
        let dogTale = dog?.childNode(withName: "tale", recursively: true)
        let head = dog?.childNode(withName: "head", recursively: true)
        let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
        let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
        let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
        let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
        let taleFurifuri = SCNAction.repeat(SCNAction.sequence([ SCNAction.rotateTo(x: 0.5, y: 0, z: 0.7, duration: 0.05),SCNAction.rotateTo(x: 0.5, y: 0, z: -0.7, duration: 0.05)]),count: 16)
        
        dog?.removeAllActions()
        dogpivot?.removeAllActions()
        legbackleft?.removeAllActions()
        legbackright?.removeAllActions()
        legfrontleft?.removeAllActions()
        legfrontright?.removeAllActions()
        head?.removeAllActions()
        dogTale?.removeAllActions()
        let hand = dog?.childNode(withName: "hand", recursively: true)
        let dogBless = SCNAction.run { (SCNNode) in
            DispatchQueue.main.async {
            self.playHapticsFile("DogBless")
            }
        }
        let displayHaptics = SCNAction.run { (SCNNode) in
            DispatchQueue.main.async {
            self.playHapticsFile("DogDisplayTouch")
            }
        }
        
        dog?.runAction(SCNAction.move(by: SCNVector3(x: 0, y: 0.25, z: 0.3), duration: 0.2))
                       dogTale?.runAction(SCNAction.sequence([
                        taleFurifuri,
                        taleFurifuri
                        ]))
                       hand?.isHidden = false
                       head?.runAction(SCNAction.sequence([
                        SCNAction.rotateBy(x: 0.2, y: 0, z: 0, duration: 0.1),
                        displayHaptics,
                        SCNAction.move(by: SCNVector3(x: 0, y: 0, z:-0.15), duration: 0.1),SCNAction.wait(duration: 0.3),
                        dogBless
                       ]))
                       hand?.runAction(SCNAction.sequence([
                        SCNAction.move(to: SCNVector3(x: -0.072, y: 0, z: 0.05), duration: 0.2),SCNAction.wait(duration: 2)
                       ]))
    }
    
    func fourthAction(){
        print("fourth")
        playHapticsFile("DogHelloSmile")
            let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
           let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
           let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
           let dogTale = dog?.childNode(withName: "tale", recursively: true)
           let head = dog?.childNode(withName: "head", recursively: true)
           let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
           let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
           let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
           let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
           let taleFurifuri = SCNAction.repeat(SCNAction.sequence([ SCNAction.rotateTo(x: 0.5, y: 0, z: 0.7, duration: 0.05),SCNAction.rotateTo(x: 0.5, y: 0, z: -0.7, duration: 0.05)]),count: 16)
           let ry = atan((camera!.worldPosition.y) - head!.worldPosition.y)
           
           dog?.removeAllActions()
           dogpivot?.removeAllActions()
           legbackleft?.removeAllActions()
           legbackright?.removeAllActions()
           legfrontleft?.removeAllActions()
           legfrontright?.removeAllActions()
           head?.removeAllActions()
           dogTale?.removeAllActions()
               let dogBless = SCNAction.run { (SCNNode) in
                   self.playHapticsFile("DogBless")
                   
               }
               let displayHaptics = SCNAction.run { (SCNNode) in
                   self.playHapticsFile("DogDisplayTouch")
               }
        dogTale?.runAction(SCNAction.sequence([taleFurifuri,taleFurifuri, taleFurifuri,taleFurifuri]))
        
        let bound = SCNAction.sequence([
            SCNAction.move(by: SCNVector3(x: 0.05, y: 0.1, z: -0.1), duration: 0.1),
            displayHaptics,
            SCNAction.move(by: SCNVector3(x: -0.05, y: -0.1, z: 0.1), duration: 0.1),
            displayHaptics,
            SCNAction.wait(duration: 0.6),
            SCNAction.move(by: SCNVector3(x: -0.05, y: 0.1, z: -0.1), duration: 0.1),
            displayHaptics,
            SCNAction.move(by: SCNVector3(x: 0.05, y: -0.1, z: 0.1), duration: 0.1),            displayHaptics,
        ])
        dog?.runAction(SCNAction.sequence([ SCNAction.repeat(bound, count: 2),
                                            dogBless,
                                            dogBless,
                                            SCNAction.wait(duration: 2)
        ]))
    }
    
    func dogBeing(){
        let dog = scene.rootNode.childNode(withName: "dog", recursively: true)!
        let dogUpDown = dog.childNode(withName: "dogupdown", recursively: true)
        let dogBody = dog.childNode(withName: "body", recursively: true)
        dogUpDown?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: 0.02, z: 0), duration: 0.3),SCNAction.move(by: SCNVector3(x: 0, y: -0.02, z: 0), duration: 0.3)])))
        dogBody?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 0.16, duration: 1),SCNAction.scale(to: 0.15, duration: 1)])))
    }
    
    
    override init() {
        super.init()
        createEngine()
        scene = SCNScene(named: "art.scnassets/petit.scn")!
        defaultAction()
        dogBeing()
    }
}
