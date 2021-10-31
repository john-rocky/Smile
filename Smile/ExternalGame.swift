//
//  ExternalGame.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class ExternalGame: Game{
    
    lazy var logic = ExternalLogic()
    
    override func updateGame() {
        if time == 100 {
            if isAncoAppear {
                for ancoNode in anco {
                    ancoNode.randomWalk()
                }
            }
            if isOkomeAppear {
                for okomeNode in okome {
                    okomeNode.randomWalk()
                }
            }
            if isSweetsAppear {
                for sweetsNode in sweets {
                    sweetsNode.randomWalk()
                }
            }
            time = 0
        }
    }
    
    override func handleSmile() {
        logic.smileCount += 1
        playHapticsFile("DogHelloSmile")
        switch logic.smileCount {
        case 1:
            flower()
        case 2:
            flower()
        case 3:
            flower()
        case 4:
            flower()
        case 5:
            scene.rootNode.childNode(withName: "apple0", recursively: false)?.isHidden = false
        case 6:
            scene.rootNode.childNode(withName: "apple1", recursively: false)?.isHidden = false
        case 7:
            scene.rootNode.childNode(withName: "apple2", recursively: false)?.isHidden = false
        case 8:
            scene.rootNode.childNode(withName: "apple3", recursively: false)?.isHidden = false
        case 9:
            scene.rootNode.childNode(withName: "leaf", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.1))
        case 10:
            scene.rootNode.childNode(withName: "leaf", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.1))
        case 11:
            scene.rootNode.childNode(withName: "leaf", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.1))
        case 12:
            scene.rootNode.childNode(withName: "leaf", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.1))
        case 13:
            scene.rootNode.childNode(withName: "leaf", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.1))
        case 14:
            scene.rootNode.childNode(withName: "leaf", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 0.2, 0), duration: 0.1))
        case 15:
            anco[0].isHidden = false
        case 16:
            anco[1].isHidden = false
        case 17:
            anco[2].isHidden = false
        case 18:
            anco[3].isHidden = false
        case 19:
            anco[0].runAction(SCNAction.move(to: SCNVector3(anco[0].worldPosition.x, 0.212, anco[0].worldPosition.z), duration: 0.5),completionHandler: {
                self.anco[0].randomWalk()
                self.anco[1].randomWalk()
                self.anco[2].randomWalk()
                self.anco[3].randomWalk()
            })
            anco[1].runAction(SCNAction.move(to: SCNVector3(anco[1].worldPosition.x, 0.212, anco[1].worldPosition.z), duration: 0.5))
            anco[2].runAction(SCNAction.move(to: SCNVector3(anco[2].worldPosition.x, 0.212, anco[2].worldPosition.z), duration: 0.5))
            anco[3].runAction(SCNAction.move(to: SCNVector3(anco[3].worldPosition.x, 0.212, anco[3].worldPosition.z), duration: 0.5))
            isAncoAppear = true
        case 20:
            scene.rootNode.childNode(withName: "nae", recursively: false)!.runAction(SCNAction.move(by: SCNVector3(0, 0.5, 0), duration: 0.1))
        case 21:
            scene.rootNode.childNode(withName: "nae", recursively: false)!.runAction(SCNAction.move(by: SCNVector3(0, 0.5, 0), duration: 0.1))
        case 22:
            scene.rootNode.childNode(withName: "nae", recursively: false)!.runAction(SCNAction.move(by: SCNVector3(0, 0.5, 0), duration: 0.1))
        case 23:
            scene.rootNode.childNode(withName: "nae", recursively: false)!.runAction(SCNAction.move(by: SCNVector3(0, 0.5, 0), duration: 0.1))
        case 24:
            scene.rootNode.childNode(withName: "particles", recursively: true)?.isHidden = false
        case 25:
            okome[0].isHidden = false
            okome[1].isHidden = false
            okome[2].isHidden = false
            okome[3].isHidden = false
            okome[4].isHidden = false
            okome[5].isHidden = false
            okome[6].isHidden = false
            okome[7].isHidden = false
        case 26:
            okome[0].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition0", recursively: false)!.worldPosition, duration: 1))
            okome[1].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition1", recursively: false)!.worldPosition, duration: 1))
            okome[2].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition2", recursively: false)!.worldPosition, duration: 1))
            okome[3].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition3", recursively: false)!.worldPosition, duration: 1))
            okome[4].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition4", recursively: false)!.worldPosition, duration: 1))
            okome[5].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition5", recursively: false)!.worldPosition, duration: 1))
            okome[6].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition6", recursively: false)!.worldPosition, duration: 1))
            okome[7].runAction(SCNAction.move(to: scene.rootNode.childNode(withName: "okomeposition7", recursively: false)!.worldPosition, duration: 1))
        case 27:
            okome[0].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[0].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[1].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[1].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[2].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[2].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[3].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[3].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[4].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[4].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[5].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[5].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[6].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[6].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[7].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[7].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[0].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[0].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[1].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[1].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[2].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[2].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[3].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[3].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[4].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[4].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[5].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[5].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[6].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[6].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[7].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[7].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
        case 28:
            okome[0].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[0].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[1].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[1].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[2].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[2].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[3].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[3].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[4].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[4].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[5].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[5].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[6].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[6].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[7].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[7].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[0].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[0].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[1].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[1].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[2].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[2].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[3].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[3].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[4].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[4].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[5].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[5].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[6].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[6].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[7].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[7].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
        case 29:
            okome[0].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[0].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[1].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[1].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[2].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[2].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[3].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[3].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[4].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[4].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[5].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[5].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[6].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[6].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[7].childNode(withName: "notsmile", recursively: false)?.isHidden = true
            okome[7].childNode(withName: "smile", recursively: false)?.isHidden = false
            okome[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[0].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[0].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[1].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[1].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[2].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[2].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[3].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[3].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[4].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[4].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[5].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[5].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[6].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[6].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.5, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.08, z: 0), duration: 0.5)]),completionHandler: {
                self.okome[7].childNode(withName: "notsmile", recursively: false)?.isHidden = false
                self.okome[7].childNode(withName: "smile", recursively: false)?.isHidden = true
            })
            okome[0].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[1].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[2].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[3].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[4].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[5].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[6].childNode(withName: "kara", recursively: false)?.isHidden = true
            okome[7].childNode(withName: "kara", recursively: false)?.isHidden = true
            scene.rootNode.childNode(withName: "nae", recursively: true)?.isHidden = true

        case 30:
            nosimochi[0].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition0", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition0", recursively: false)!.worldPosition.z)
            nosimochi[1].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition1", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition1", recursively: false)!.worldPosition.z)
            nosimochi[2].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition2", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition2", recursively: false)!.worldPosition.z)
            nosimochi[3].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition3", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition3", recursively: false)!.worldPosition.z)
            nosimochi[4].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition4", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition4", recursively: false)!.worldPosition.z)
            nosimochi[5].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition5", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition5", recursively: false)!.worldPosition.z)
            nosimochi[6].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition6", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition6", recursively: false)!.worldPosition.z)
            nosimochi[7].worldPosition = SCNVector3(scene.rootNode.childNode(withName: "okomeposition7", recursively: false)!.worldPosition.x,0.049,scene.rootNode.childNode(withName: "okomeposition7", recursively: false)!.worldPosition.z)
            okome[0].isHidden = true
            okome[1].isHidden = true
            okome[2].isHidden = true
            okome[3].isHidden = true
            okome[4].isHidden = true
            okome[5].isHidden = true
            okome[6].isHidden = true
            okome[7].isHidden = true
            nosimochi[0].isHidden = false
            nosimochi[1].isHidden = false
            nosimochi[2].isHidden = false
            nosimochi[3].isHidden = false
            nosimochi[4].isHidden = false
            nosimochi[5].isHidden = false
            nosimochi[6].isHidden = false
            nosimochi[7].isHidden = false
            nosimochi[0].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[1].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[2].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[3].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[4].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[5].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[6].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
            nosimochi[7].childNode(withName: "body", recursively: false)!.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 0.5)])))
        case 31:
            nosimochi[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
        case 32:
            nosimochi[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
        case 33:
            nosimochi[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
        case 34:
            nosimochi[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
        case 35:
            nosimochi[0].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[1].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[2].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[3].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[4].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[5].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[6].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
            nosimochi[7].runAction(SCNAction.sequence([SCNAction.scale(by: 1.3, duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: 0.05, z: 0), duration: 0.5)]))
        case 36:
            okome[0] = scene.rootNode.childNode(withName: "kinako", recursively: false)!
            okome[1] = scene.rootNode.childNode(withName: "isobe", recursively: false)!
            okome[2] = scene.rootNode.childNode(withName: "ancoro", recursively: false)!
            okome[3] = scene.rootNode.childNode(withName: "mitarasi", recursively: false)!
            okome[4] = scene.rootNode.childNode(withName: "andango", recursively: false)!
            okome[5] = scene.rootNode.childNode(withName: "sansyoku", recursively: false)!
            okome[6] = scene.rootNode.childNode(withName: "omochi", recursively: false)!
            okome[7] = scene.rootNode.childNode(withName: "kanten", recursively: false)!
            okome[0].worldPosition = SCNVector3(nosimochi[0].worldPosition.x,okome[0].worldPosition.y,nosimochi[0].worldPosition.z)
            okome[1].worldPosition = SCNVector3(nosimochi[1].worldPosition.x,okome[1].worldPosition.y,nosimochi[1].worldPosition.z)
            okome[2].worldPosition = SCNVector3(nosimochi[2].worldPosition.x,okome[2].worldPosition.y,nosimochi[2].worldPosition.z)
            okome[3].worldPosition = SCNVector3(nosimochi[3].worldPosition.x,okome[3].worldPosition.y,nosimochi[3].worldPosition.z)
            okome[4].worldPosition = SCNVector3(nosimochi[4].worldPosition.x,okome[4].worldPosition.y,nosimochi[4].worldPosition.z)
            okome[5].worldPosition = SCNVector3(nosimochi[5].worldPosition.x,okome[5].worldPosition.y,nosimochi[5].worldPosition.z)
            okome[6].worldPosition = SCNVector3(nosimochi[6].worldPosition.x,okome[6].worldPosition.y,nosimochi[6].worldPosition.z)
            okome[7].worldPosition = SCNVector3(nosimochi[7].worldPosition.x,okome[7].worldPosition.y,nosimochi[7].worldPosition.z)
            nosimochi[0].isHidden = true
            nosimochi[1].isHidden = true
            nosimochi[2].isHidden = true
            nosimochi[3].isHidden = true
            nosimochi[4].isHidden = true
            nosimochi[5].isHidden = true
            nosimochi[6].isHidden = true
            nosimochi[7].isHidden = true
            okome[0].isHidden = false
            okome[1].isHidden = false
            okome[2].isHidden = false
            okome[3].isHidden = false
            okome[4].isHidden = false
            okome[5].isHidden = false
            okome[6].isHidden = false
            okome[7].isHidden = false
            okome[0].childNode(withName: "pivot", recursively: false)?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 1)])))
            okome[1].childNode(withName: "pivot", recursively: false)?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 1)])))
            okome[2].childNode(withName: "pivot", recursively: false)?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 1)])))
            okome[6].childNode(withName: "pivot", recursively: false)?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.scale(to: 1.1, duration: 1),SCNAction.scale(to: 1, duration: 1)])))
            isOkomeAppear = true
        case 37:
            isSweetsAppear = true
            chocoBeing(sweets[3])
            chocoBeing(sweets[4])
            chocoBeing(sweets[5])
        case 38:
            scene.background.contents = UIColor.black
            self.scene.rootNode.childNode(withName: "moon", recursively: false)?.runAction(SCNAction.move(to: SCNVector3(x: 4.866, y: 6.024, z: -39.615), duration: 0.5))

            hanabi.isHidden = false
            hanabi.runAction(SCNAction.move(by: SCNVector3(0, 6, 0), duration: 3))
            case 39:
            hanabi.isHidden = true
            let hidden = SCNAction.run { (SCNNode) in
                self.hanabi.isHidden = false
            }
            hanabi.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(2, -6, 0), duration: 0.1),hidden,SCNAction.move(by: SCNVector3(0, 6, 0), duration: 6)]),completionHandler: {
                self.hanabi.isHidden = true
            })
        case 40:
            scene.rootNode.childNode(withName: "rock", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 12, 0), duration: 3))
            scene.rootNode.childNode(withName: "rockwall", recursively: false)?.runAction(SCNAction.move(by: SCNVector3(0, 12, 0), duration: 3))

        case 41:
            pddingSmile()
        case 42:
            hotcakeSmile()
        case 43:
            omochiSmile(okome[0])
        case 44:
            omochiSmile(okome[1])
            omochiSmile(okome[2])
            omochiSmile(okome[6])
        case 45:
            scene.rootNode.childNode(withName: "rock", recursively: false)?.childNode(withName: "door", recursively: true)?.runAction(SCNAction.move(by: SCNVector3(4, 0, 0), duration: 6),completionHandler: {
                let tablet = self.scene.rootNode.childNode(withName: "flowertablet", recursively: false)
                let sun = self.scene.rootNode.childNode(withName: "IESLight", recursively: false)
                sun?.isHidden = false
                self.scene.background.contents = UIColor.white
                self.scene.rootNode.childNode(withName: "moon", recursively: false)?.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
                tablet?.worldPosition = SCNVector3(x: -1.291, y: 1.502, z: -44.329)
                tablet?.isHidden = false
                tablet?.runAction(SCNAction.move(to: SCNVector3(x: -0.092, y: 1.502, z: -3.094), duration: 1),completionHandler: {
                    SCNTransaction.begin()
                    SCNTransaction.animationDuration = 0.5
                    tablet?.opacity = 0.9
                    SCNTransaction.completionBlock = {
                        SCNTransaction.begin()
                        SCNTransaction.animationDuration = 0.5
                        tablet?.opacity = 0.1
                        SCNTransaction.completionBlock = {
                            SCNTransaction.begin()
                                               SCNTransaction.animationDuration = 0.5
                                               tablet?.opacity = 0.9
                                               SCNTransaction.completionBlock = {
                                                   SCNTransaction.begin()
                                                   SCNTransaction.animationDuration = 0.5
                                                   tablet?.opacity = 0.1
                                                   SCNTransaction.completionBlock = {
                                                       tablet?.isHidden = true
                                                   }
                                                   SCNTransaction.commit()
                                               }
                                               SCNTransaction.commit()
                        }
                        SCNTransaction.commit()
                    }
                    SCNTransaction.commit()
                })
            })
//        case 46:
//            let tablet = self.scene.rootNode.childNode(withName: "flowertablet", recursively: false)
//
//            case 47 :
//            let tablet = self.scene.rootNode.childNode(withName: "flowertablet", recursively: false)
//                       SCNTransaction.begin()
//                       SCNTransaction.animationDuration = 0.5
//                       tablet?.opacity = 0.1
//                       SCNTransaction.commit()
//            case 48 :
//            let tablet = self.scene.rootNode.childNode(withName: "flowertablet", recursively: false)
//                       SCNTransaction.begin()
//                       SCNTransaction.animationDuration = 0.5
//                       tablet?.opacity = 0.9
//                       SCNTransaction.commit()
//            case 49 :
//            let tablet = self.scene.rootNode.childNode(withName: "flowertablet", recursively: false)
//            tablet?.isHidden = true
        default:
            isCameraAppear = true
            flower()
        }
    }
    
    override init() {
        super.init()
        needRequestInterval = 10
        logic.smileCount = 0
        scene = SCNScene(named: "art.scnassets/external.scn")!
        anco.append(scene.rootNode.childNode(withName: "anco0", recursively: true)!)
        anco.append(scene.rootNode.childNode(withName: "anco1", recursively: true)!)
        anco.append(scene.rootNode.childNode(withName: "anco2", recursively: true)!)
        anco.append(scene.rootNode.childNode(withName: "anco3", recursively: true)!)
        okome.append(scene.rootNode.childNode(withName: "okome0", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome1", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome2", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome3", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome4", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome5", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome6", recursively: false)!)
        okome.append(scene.rootNode.childNode(withName: "okome7", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi0", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi1", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi2", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi3", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi4", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi5", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi6", recursively: false)!)
        nosimochi.append(scene.rootNode.childNode(withName: "nosimochi7", recursively: false)!)
        sweets.append(scene.rootNode.childNode(withName: "hotcake", recursively: false)!)
        sweets.append(scene.rootNode.childNode(withName: "pdding", recursively: false)!)
        sweets.append(scene.rootNode.childNode(withName: "anpan", recursively: false)!)
        sweets.append(scene.rootNode.childNode(withName: "truffe", recursively: false)!)
        sweets.append(scene.rootNode.childNode(withName: "choco", recursively: false)!)
        sweets.append(scene.rootNode.childNode(withName: "chococat", recursively: false)!)
    hanabi = scene.rootNode.childNode(withName: "hanabi", recursively: false)!

    }

    var okome:[SCNNode] = []
    var anco:[SCNNode] = []
    var nosimochi:[SCNNode] = []
    var sweets:[SCNNode] = []
    var isAncoAppear = false
    var isOkomeAppear = false
    var isSweetsAppear = false
    var hanabi = SCNNode()
    
    func flower(){
        let flower = scene.rootNode.childNode(withName:"flowerwro", recursively: false)!.clone()
        scene.rootNode.addChildNode(flower)
        let randomNumber = Float.random(in: -2...2)
        let randomNumberz = Float.random(in: -10 ... -7)
        flower.worldPosition = SCNVector3(randomNumber,0.5,randomNumberz)
    }
    func chocoBeing(_ node:SCNNode){
        let chocoPivot = node.childNode(withName: "chocopivot", recursively: true)
        let rotate = SCNAction.rotateBy(x: 0, y: 0, z: 0.3, duration: 0.5)
        let rotateMinus = SCNAction.rotateBy(x: 0, y: 0, z: -0.6, duration: 1)
        chocoPivot?.runAction(SCNAction.repeatForever(SCNAction.sequence([rotate,SCNAction.wait(duration: 0.5),rotateMinus,SCNAction.wait(duration: 0.5),rotate])))
    }
//    func pddingBeing(_ node:SCNNode){
//        let head = node.childNode(withName: "head", recursively: true)
//        let face = node.childNode(withName: "face", recursively: true)
//       let down = SCNAction.moveBy(x: 0, y: -0.1, z: 0, duration: 1)
//        let up = SCNAction.moveBy(x: 0, y: 0.1, z: 0, duration: 1)
//        let scaleup = SCNAction.scale(to: 1.2, duration: 1)
//        let scaledown = SCNAction.scale(to: 1, duration: 1)
//        let front = SCNAction.moveBy(x: 0, y: 0.1, z: 0.2, duration: 1)
//        let back = SCNAction.moveBy(x: 0, y: -0.1, z: -0.2, duration: 1)
//
//        node.runAction(SCNAction.repeatForever(SCNAction.sequence([down,up])))
//        head!.runAction(SCNAction.repeatForever(SCNAction.sequence([scaleup,scaledown])))
//        face!.runAction(SCNAction.repeatForever(SCNAction.sequence([front,back])))
//    }
    
    func pddingSmile() {
        let pddingkun = sweets[1].childNode(withName: "pivot", recursively: true)
        let pddingkunUp = SCNAction.move(by: SCNVector3(x: 0, y: 0.801, z: 0), duration: 0.5)
        let puddingkunDown = SCNAction.move(by: SCNVector3(x: 0, y: -0.123, z: 0), duration: 0.2)
        pddingkun!.runAction(SCNAction.sequence([pddingkunUp,puddingkunDown]) )
    }
    
    func hotcakeSmile() {
        let hotcake = sweets[0]
        let sirokumachan = hotcake.childNode(withName: "sirokumachan", recursively: true)
        let sirokumachanAppear = SCNAction.move(by: SCNVector3(x: 0, y: 0.6, z: 0), duration: 0.5)
        sirokumachan!.runAction(sirokumachanAppear)
    }
    
    func omochiSmile(_ node:SCNNode) {
        node.childNode(withName: "eyeleftply",recursively: true)!.isHidden = true
            node.childNode(withName: "eyerightply",recursively: true)!.isHidden = true
            node.childNode(withName: "eyeleftsmileply",recursively: true)!.isHidden = false
            node.childNode(withName: "eyerightsmileply",recursively: true)!.isHidden = false
            node.childNode(withName: "cheekleft0smileply",recursively: true)!.isHidden = false
            node.childNode(withName: "cheekright0smileply",recursively: true)!.isHidden = false
            node.childNode(withName: "cheekleft1smileply",recursively: true)!.isHidden = false
            node.childNode(withName: "cheekright1smileply",recursively: true)!.isHidden = false
//            childNode("omochiply","eyeleftply",recursively: true).isHidden = false
//            childNode("omochiply","eyerightply",recursively: true).isHidden = false
//            childNode("omochiply","eyeleftsmileply",recursively: true).isHidden = true
//            childNode("omochiply","eyerightsmileply").isHidden = true
//            childNode("omochiply","cheekleft0smileply").isHidden = true
//            childNode("omochiply","cheekright0smileply").isHidden = true
//            childNode("omochiply","cheekleft1smileply").isHidden = true
//            childNode("omochiply","cheekright1smileply").isHidden = true
    }
}

extension SCNNode {
    func randomWalk(){
        let randomWaitTime = Double.random(in: 1...8)
        let randomRotateDuration = Double.random(in: 0.5...2)
        let randomWalkDuration = Double.random(in: 5...8)
        let randomX = Float.random(in: -3...3)
        let randomZ = Float.random(in: -20 ... -5)
        let destination = SCNVector3(x: randomX, y: self.worldPosition.y, z: randomZ)
        //        let pivot = self.childNode(withName: "pivot", recursively: true)
        let r = atan2(destination.x - self.worldPosition.x, destination.z - self.worldPosition.z)
//        let createRandom = SCNAction.run { (SCNNode) in
//            randomWaitTime = Double.random(in: 1...16)
//            randomRotateDuration = Double.random(in: 0.5...2)
//            randomWalkDuration = Double.random(in: 5...8)
//            randomX = Float.random(in: -0.5...0.5)
//            randomZ = Float.random(in: -2.5...0)
//            destination = SCNVector3(x: randomX, y: self.worldPosition.y, z: randomZ)
//            r = atan2(destination.x - self.worldPosition.x, destination.z - self.worldPosition.z)
//        }
        //        pivot?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),SCNAction.wait(duration: randomWaitTime),SCNAction.rotateTo(x: 0, y: CGFloat(r), z: 0, duration: 0.5)]))
        self.runAction(
//            SCNAction.repeatForever(
            SCNAction.sequence([
//                createRandom,
                SCNAction.wait(duration: randomWaitTime),
                SCNAction.rotateTo(x: 0, y: CGFloat(r), z: 0, duration: randomRotateDuration),
                SCNAction.move(to:destination, duration: randomWalkDuration)]))
//        )
    }
}

extension SCNVector3 {
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
