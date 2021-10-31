//
//  FoxCamera.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/03.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import CoreHaptics

class FoxCamera:Camera {

    override func handleSmile(){
        game.playHapticsFile("DogHelloSmile")
        foxSmileAction()
    }
    
        func foxSmileAction(){
            let girl = contentNode.childNode(withName: "girl", recursively: false)!
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
    
    
            switch smileCounter {
            case 1:
                girl.runAction(smileAction)
            case 2:
                girl.runAction(smileAction)
                tale?.isHidden = false
            case 3:
                girl.runAction(smileAction)
                foxear?.isHidden = false
            default:
                girl.runAction(smileAction)
            }
        }
    
    override init() {
        super.init()
        game.createEngine()
        contentNode = SCNReferenceNode(named: "foxcamera", loadImmediately: true).childNode(withName: "box", recursively: false)!
    }
}
