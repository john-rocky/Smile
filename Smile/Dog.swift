//
//  Dog.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/24.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class Dog:Game {
    // Set Animatational Node.
    var isFriend = 0
    override func updateGame(){
        if time == 2 {
            if !isActioning {
                let randomWaitTime = Double.random(in: 0...4)
                let restTime = 8 - 2.5 - randomWaitTime
                let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
                let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
                let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
                let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
                let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
                let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
                let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
                let head = dog?.childNode(withName: "head", recursively: true)
                let randomX = Float.random(in: -0.5...0.5)
                let randomZ = Float.random(in: -2.5...0)
                let destination = SCNVector3(x: randomX, y: (dog?.worldPosition.y)!, z: randomZ)
                let r = atan2(destination.x - (dog?.worldPosition.x)!, destination.z - (dog?.worldPosition.z)!)
                let rotate = SCNAction.rotateBy(x: 0.5, y: 0, z: 0, duration: 0.25)
                let rotateMinus = SCNAction.rotateBy(x: -0.5, y: 0, z: 0, duration: 0.25)
                let rToCamera = atan2((camera!.worldPosition.x) - dog!.worldPosition.x,(camera!.worldPosition.z) - dog!.worldPosition.z)
                print(rToCamera)
                let rotateToDestination = SCNAction.sequence([SCNAction.rotateTo(x: 0, y: 0 , z: 0, duration: 0.5),SCNAction.wait(duration: 0.5)])
                let rotateAndDownToGround = SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)
                let rotateUpTODefault =  SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)
                if isFriend == 0 {
                    if (dogpivot?.position.y)! < Float(0) {
                               dogpivot?.runAction(SCNAction.sequence([
                                   SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.1),
                                   SCNAction.move(by: SCNVector3(0, 0.15, 0), duration: 0.1)
                               ]))
                           }
                    head?.removeAllActions()
                    dog?.removeAllActions()
                    
                    head?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),SCNAction.wait(duration: randomWaitTime),rotateToDestination,rotateAndDownToGround,SCNAction.wait(duration: restTime),rotateUpTODefault]))
                    
                    dogpivot?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),SCNAction.wait(duration: randomWaitTime),SCNAction.rotateTo(x: 0, y: CGFloat(r), z: 0, duration: 0.5)]))
                    dog?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),SCNAction.move(to: SCNVector3(x: randomX, y: (dog?.worldPosition.y)!, z: randomZ), duration: 1)]))
                    legfrontleft?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotate,rotateMinus,rotateMinus,rotate]))
                    legfrontright?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotateMinus,rotate,rotate,rotateMinus]))
                    legbackleft?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotateMinus,rotate,rotate,rotateMinus]))
                    legbackright?.runAction(SCNAction.sequence([SCNAction.wait(duration: randomWaitTime + 0.5),rotate,rotateMinus,rotateMinus,rotate]))
                } else {
                    //isFriend
                    head?.removeAllActions()
                    dog?.removeAllActions()
                    
                    dogpivot?.runAction(SCNAction.sequence([
                        SCNAction.rotateTo(x: 0, y: 0.5, z: 1.75, duration: 0.4),
                        SCNAction.move(by: SCNVector3(0, -0.15, 0), duration: 0.1),
                        SCNAction.wait(duration: randomWaitTime),
                        SCNAction.rotateTo(x: 0, y: -0.5, z: -1.75, duration: 0.4)
                    ]),completionHandler: {
                        self.isFriend = 0
                    })
                }
            }
        }
        if time == 8 {
            time = 0
        }
    }
    
    override func handleSmile() {
        smileCounter += 1
        
        let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
        let dog = scene.rootNode.childNode(withName: "dog", recursively: false)
        let dogpivot = dog?.childNode(withName: "dogpivot", recursively: true)
        let dogTale = dog?.childNode(withName: "tale", recursively: true)
        let head = dog?.childNode(withName: "head", recursively: true)
        let hand = dog?.childNode(withName: "hand", recursively: true)
        let legfrontleft = dog?.childNode(withName: "legfrontleft", recursively: true)
        let legfrontright = dog?.childNode(withName: "legfrontright", recursively: true)
        let legbackleft = dog?.childNode(withName: "legbackleft", recursively: true)
        let legbackright = dog?.childNode(withName: "legbackright", recursively: true)
        
        let taleFurifuri = SCNAction.repeat(SCNAction.sequence([ SCNAction.rotateTo(x: 0.5, y: 0, z: 0.7, duration: 0.05),SCNAction.rotateTo(x: 0.5, y: 0, z: -0.7, duration: 0.05)]),count: 8)
        let rotate = SCNAction.rotateBy(x: 0.75, y: 0, z: 0, duration: 0.125)
        let rotateMinus = SCNAction.rotateBy(x: -0.75, y: 0, z: 0, duration: 0.125)
        let walkA = SCNAction.sequence([rotate,rotateMinus,rotateMinus,rotate])
        let walkB = SCNAction.sequence([rotateMinus,rotate,rotate,rotateMinus])
        
        let rToCamera = atan2((camera!.worldPosition.x) - head!.worldPosition.x, (camera!.worldPosition.z) - head!.worldPosition.z)
        let ry = atan((camera!.worldPosition.y) - head!.worldPosition.y)
        let dogBless = SCNAction.run { (SCNNode) in
            self.playHapticsFile("DogBless")
            
        }
        let displayHaptics = SCNAction.run { (SCNNode) in
            self.playHapticsFile("DogDisplayTouch")
        }
        
        if (dogpivot?.position.y)! < Float(0) {
            dogpivot?.rotation = SCNVector4(x: 0, y: 0, z: 0, w:0)
            dogpivot?.position = SCNVector3(0, 0, 0)
        }
        
        if !isActioning {
            playHapticsFile("DogHelloSmile")
            isActioning = true
            switch smileCounter {
            case 1:
                self.isFriend += 1
                
                dog?.removeAllActions()
                dogpivot?.removeAllActions()
                head?.removeAllActions()
                dogpivot?.runAction(SCNAction.sequence([SCNAction.rotateTo(x: 0, y: CGFloat(rToCamera), z: 0, duration: 0.3),SCNAction.wait(duration: 0.7),SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5)]))
                head?.runAction(SCNAction.rotateTo(x: -CGFloat(ry) + 0.2, y: 0, z: 0, duration: 0.3))
                dog?.runAction(SCNAction.sequence([
                    SCNAction.wait(duration: 1),
                    SCNAction.move(to: SCNVector3((camera!.worldPosition.x), (dog?.worldPosition.y)!, (camera!.worldPosition.z) - 1.5), duration: 0.5)
                ]))
                legfrontleft?.runAction(SCNAction.sequence([
                    SCNAction.wait(duration: 1),
                    walkA
                ]))
                legfrontright?.runAction(SCNAction.sequence([
                    SCNAction.wait(duration: 1),
                    walkB
                ]))
                legbackleft?.runAction(SCNAction.sequence([
                    SCNAction.wait(duration: 1),
                    walkB
                ]))
                legbackright?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1),
                                                            walkA
                ]))
                dogpivot?.runAction(SCNAction.rotateTo(x: 0, y: CGFloat(rToCamera), z: 0, duration: 0.5))
                dogTale?.runAction(SCNAction.sequence([SCNAction.wait(duration: 1.5), taleFurifuri]),completionHandler: {
                    dogTale?.rotation = SCNVector4(1, 0, 0, -0.5)
                    if !self.isSmiling {
                        self.smileCounter = 0
                    }
                    self.isActioning = false
                })
            case 2:
                dogTale?.runAction(SCNAction.sequence([taleFurifuri]))
                dog?.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(-0.02 , 0, 0), duration: 0.1), SCNAction.scale(to: 2, duration: 0.4),SCNAction.wait(duration: 2)]),completionHandler: {
                    dogTale?.rotation = SCNVector4(1, 0, 0, -0.5)
                    if !self.isSmiling {
                        dog?.runAction(SCNAction.scale(to: 1, duration: 0.4),completionHandler: {
                            self.isActioning = false
                        })
                        self.smileCounter = 0
                    } else {
                    self.isActioning = false
                        }
                })
                
                
            case 3:
                
                
                dog?.runAction(SCNAction.move(by: SCNVector3(x: 0, y: 0.25, z: 0.3), duration: 0.2))
                dogTale?.runAction(SCNAction.sequence([taleFurifuri,taleFurifuri]))
                hand?.isHidden = false
                head?.runAction(SCNAction.sequence([SCNAction.rotateBy(x: 0.2, y: 0, z: 0, duration: 0.1),displayHaptics,SCNAction.move(by: SCNVector3(x: 0, y: 0, z:-0.15), duration: 0.1),SCNAction.wait(duration: 0.3),dogBless]))
                hand?.runAction(SCNAction.sequence([SCNAction.move(to: SCNVector3(x: -0.072, y: 0, z: 0.05), duration: 0.2),SCNAction.wait(duration: 2)]) ,completionHandler: {
                    dogTale?.rotation = SCNVector4(1, 0, 0, -0.5)
                    if !self.isSmiling {
                        self.smileCounter = 0
                        dog?.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: -0.25, z: 0), duration: 0.01),SCNAction.scale(to: 1, duration: 0.1)]),completionHandler: {
                            self.isActioning = false
                        })
                        dog?.runAction(SCNAction.scale(to: 1, duration: 0.1))
                        hand?.isHidden = true
                        head?.runAction(SCNAction.move(by: SCNVector3(x: 0, y: 0, z: 0.15), duration: 0.1))
                    } else {
                        self.isActioning = false
                    }
                })
            case 4:
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
                ]),completionHandler: {
                    dog?.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: -0.25, z: 0), duration: 0.01),SCNAction.scale(to: 1, duration: 0.1)]),completionHandler: {
                        self.isActioning = false
                        if !self.isSmiling {
                            self.smileCounter = 0
                        }
                    })
                    dog?.runAction(SCNAction.scale(to: 1, duration: 0.1))
                    hand?.isHidden = true
                    head?.runAction(SCNAction.move(by: SCNVector3(x: 0, y: 0, z: 0.15), duration: 0.1))
                })
            case 5:
                let currentPosition = dog?.worldPosition
                let destination = SCNVector3(x: 2, y: (dog?.worldPosition.y)!, z: -2)
                let r = atan2(destination.x - (dog?.worldPosition.x)!, destination.z - (dog?.worldPosition.z)!)
                let arCamera = dog!.childNode(withName: "arcamera", recursively: true)
                let cameraIsHiddenFalse = SCNAction.run { (SCNNode) in
                    arCamera?.isHidden = false
                }
                dog?.runAction(SCNAction.sequence([
                    SCNAction.move(to: destination, duration: 1),
                    cameraIsHiddenFalse,
                    SCNAction.move(to: currentPosition!, duration: 2)
                ]),completionHandler: {
                    arCamera?.removeFromParentNode()
                    self.scene.rootNode.addChildNode(arCamera!)
                    arCamera?.worldPosition = SCNVector3(0, 0.1, 0.5)
                    arCamera?.rotation = SCNVector4(0, 0, 1, 0)
                    dogpivot?.runAction(SCNAction.sequence([
                        SCNAction.rotateTo(x: 0, y: 0, z: 0, duration: 0.5),
                        SCNAction.wait(duration: 1)
                        ]),completionHandler: {
                            self.smileCounter = 0
                                               self.isActioning = false
                    })
                })
                dogpivot?.runAction(SCNAction.sequence([
                    SCNAction.rotateBy(x: 0, y: CGFloat(r), z: 0, duration: 0.5),
                    SCNAction.wait(duration: 0.5),
                    SCNAction.rotateTo(x: 0, y: -0.25, z: 0, duration: 0.5)
                ]))
                legfrontleft?.runAction(SCNAction.sequence([
                    SCNAction.repeat(walkA, count: 2),
                    SCNAction.repeat(walkA, count: 2)
                ]))
                legfrontright?.runAction(SCNAction.sequence([
                    SCNAction.repeat(walkB, count: 2),
                    SCNAction.repeat(walkB, count: 2)
                ]))
                legbackleft?.runAction(SCNAction.sequence([
                    SCNAction.repeat(walkB, count: 2),
                    SCNAction.repeat(walkB, count: 2)
                ]))
                legbackright?.runAction(SCNAction.sequence([
                    SCNAction.repeat(walkA, count: 2),
                    SCNAction.repeat(walkA, count: 2)
                ]))
                
            default:
                smileCounter = 0
                self.isActioning = false
            }
        }
        if !isCameraAppear {
            //            addCamera()
        }
    }
    
    override func addCamera() {
        let camera = SCNReferenceNode(named: "utils", loadImmediately: true).childNode(withName: "arcamera", recursively: false)
        camera?.worldPosition = SCNVector3(x: 0, y: 2.5, z: -1)
        scene.rootNode.addChildNode(camera!)
        isCameraAppear = true
    }
    
    override init() {
        super.init()
        needRequestInterval = 10
        scene = SCNScene(named: "art.scnassets/petit.scn")!
        let dog = scene.rootNode.childNode(withName: "dog", recursively: true)!
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        // place the camera
        cameraNode.worldPosition = SCNVector3(x: 0, y: 1, z: dog.worldPosition.z + 1.5)
        cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0,w: -0.5)
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
        
        let randomX = Float.random(in: -0.5...0.5)
        let randomZ = Float.random(in: -2.5...0)
        dog.worldPosition = SCNVector3(randomX, dog.worldPosition.y, randomZ)
        let dogUpDown = dog.childNode(withName: "dogupdown", recursively: true)
        let dogBody = dog.childNode(withName: "body", recursively: true)
        let dogPivot = dog.childNode(withName: "dogpivot", recursively: true)
        dogPivot!.rotation = SCNVector4(0, 1, 0, randomX)
        
        dogUpDown?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: 0.02, z: 0), duration: 0.3),SCNAction.move(by: SCNVector3(x: 0, y: -0.02, z: 0), duration: 0.3)])))
        dogBody?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 0.16, duration: 1),SCNAction.scale(to: 0.15, duration: 1)])))
        
        createEngine()
    }
    
    
}
