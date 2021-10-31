//
//  FaceTrainingGame.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import CoreHaptics

class FaceTrainigGame: Game {
    
    override init() {
        super.init()
        scene = SCNScene(named: "art.scnassets/facegame.scn")!
    }
    
    override func handleSmile() {
        let camera = scene.rootNode.childNode(withName: "camera", recursively: false)
       
       let gameDisplay = scene.rootNode.childNode(withName: "gamedisplayobj", recursively: true)
        let flash = gameDisplay?.childNode(withName: "flash", recursively: false)
        let contet = gameDisplay?.childNode(withName: "daifuku", recursively: false)
        let displayAction = SCNAction.run { (SCNNode) in
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.1
            flash?.scale = SCNVector3(1, 1, 1)
            SCNTransaction.completionBlock = {
                flash?.isHidden = true
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0.1
                contet?.opacity = 1
                gameDisplay?.geometry?.firstMaterial?.diffuse.contents = UIColor.white
                SCNTransaction.commit()

                }
            SCNTransaction.commit()
        }
        camera?.runAction(SCNAction.sequence([SCNAction.move(to: SCNVector3(0, 2.5, -2.3), duration: 1),SCNAction.rotateTo(x: -1.5, y: 0, z: 0, duration: 1),SCNAction.wait(duration: 1),displayAction,SCNAction.wait(duration: 1),SCNAction.move(by: SCNVector3(0, -0.5, 0), duration: 1),SCNAction.wait(duration: 0.55)]),completionHandler: {
            NotificationCenter.default.post(name: .notifyName,object: nil)
        })
    }
    
    }

extension Notification.Name {
    static let notifyName = Notification.Name("notifyName")
}
