//
//  Girl.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/26.
//  Copyright © 2020 daisuke. All rights reserved.
//

import SceneKit
import CoreHaptics

class Girl:Game {
    // Set Animatational Node.
    override func updateGame(){
        
    }
    
    override func handleSmile() {
        let girl = scene.rootNode.childNode(withName: "girl", recursively: false)
        let smile = girl?.childNode(withName: "smile", recursively: true)
        let notSmile = girl?.childNode(withName: "notsmile", recursively: true)
        smile?.isHidden = false
        notSmile?.isHidden = true
        hapticsPlay()
    }
    
    override init() {
        super.init()
        createEngine()
        scene = SCNScene(named: "art.scnassets/girl.scn")!
        let girl = scene.rootNode.childNode(withName: "girl", recursively: false)
        let cameraNode = scene.rootNode.childNode(withName: "camera", recursively: false)
        cameraNode!.camera = SCNCamera()
        
        //           cameraNode.worldPosition = SCNVector3(x: 0, y: 1, z: dog.worldPosition.z + 1.5)
        //           cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0,w: -0.5)
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .directional
        lightNode.position = SCNVector3(x: 0, y: 20, z: 0)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
//        let ambientLightNode = SCNNode()
//        ambientLightNode.light = SCNLight()
//        ambientLightNode.light!.type = .directional
//        ambientLightNode.light!.color = UIColor.darkGray
//        scene.rootNode.addChildNode(ambientLightNode)
    }
    
    override func hapticsPlayer() throws -> CHHapticPatternPlayer? {
        let volume:Float = 1
        let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
            CHHapticEventParameter(parameterID: .audioPitch, value: 1),
            CHHapticEventParameter(parameterID: .audioVolume, value: volume),
            CHHapticEventParameter(parameterID: .decayTime, value: 0.1),
            CHHapticEventParameter(parameterID: .sustained, value: 0),
            CHHapticEventParameter(parameterID: .audioBrightness, value: 0.3)
           ,
           CHHapticEventParameter(parameterID: .audioPan, value: 1)
        ], relativeTime: 0)
        
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: 1),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        ], relativeTime: 0)
        let pattern = try CHHapticPattern(events: [audioEvent, hapticEvent], parameters: [])
        return try engine.makePlayer(with: pattern)
    }
}
