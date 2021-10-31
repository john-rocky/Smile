//
//  Camera.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/28.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import ARKit
import CoreHaptics

class Camera:NSObject,ARSCNViewDelegate {
    var contentNode = SCNNode()
    var smileCounter = 0
    var scene = SCNScene()
    func handleSmile(){
        
    }
    lazy var game = Game()
    var isSmiling = false
    var isRequest = false
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        return contentNode
    }
    
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if isRequest {
            guard let faceAnchor = anchor as? ARFaceAnchor else {
                isSmiling = false
                return
            }
            // 2
            let leftSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
            let rightSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
    //        let eyeBlinkLeft = faceAnchor.blendShapes[.eyeBlinkLeft] as! CGFloat
    //        let eyeLookDownLeft = faceAnchor.blendShapes[.eyeLookDownLeft] as! CGFloat
    //        let eyeLookInLeft = faceAnchor.blendShapes[.eyeLookInLeft] as! CGFloat
    //        let eyeLookUpLeft = faceAnchor.blendShapes[.eyeLookUpLeft] as! CGFloat
    //        let eyeSquintLeft = faceAnchor.blendShapes[.eyeSquintLeft] as! CGFloat
    //        let eyeWideLeft = faceAnchor.blendShapes[.eyeWideLeft] as! CGFloat
    //        let jawForward = faceAnchor.blendShapes[.jawForward] as! CGFloat
    //        let jawLeft = faceAnchor.blendShapes[.jawLeft] as! CGFloat
    //        let jawRight = faceAnchor.blendShapes[.jawRight] as! CGFloat
    //        let jawOpen = faceAnchor.blendShapes[.jawOpen] as! CGFloat
    //        let mouthClose = faceAnchor.blendShapes[.mouthClose] as! CGFloat
    //        let mouthFunnel = faceAnchor.blendShapes[.mouthFunnel] as! CGFloat
    //        let mouthPucker = faceAnchor.blendShapes[.mouthPucker] as! CGFloat
    //        let mouthLeft = faceAnchor.blendShapes[.mouthLeft] as! CGFloat
    //        let mouthRight = faceAnchor.blendShapes[.mouthRight] as! CGFloat
    //        let mouthFrownLeft = faceAnchor.blendShapes[.mouthFrownLeft] as! CGFloat
    //        let mouthFrownRight = faceAnchor.blendShapes[.mouthFrownRight] as! CGFloat
    //        let mouthDimpleLeft = faceAnchor.blendShapes[.mouthDimpleLeft] as! CGFloat
    //        let mouthDimpleRight = faceAnchor.blendShapes[.mouthDimpleRight] as! CGFloat
    //        let mouthStretchLeft = faceAnchor.blendShapes[.mouthStretchLeft] as! CGFloat
    //        let mouthStretchRight = faceAnchor.blendShapes[.mouthStretchRight] as! CGFloat
    //        let mouthRollLower = faceAnchor.blendShapes[.mouthRollLower] as! CGFloat
    //        let mouthRollUpper = faceAnchor.blendShapes[.mouthRollUpper] as! CGFloat
    //        let mouthShrugLower = faceAnchor.blendShapes[.mouthShrugLower] as! CGFloat
    //        let mouthShrugUpper = faceAnchor.blendShapes[.mouthShrugUpper] as! CGFloat
    //        let mouthPressLeft = faceAnchor.blendShapes[.mouthPressLeft] as! CGFloat
    //        let mouthPressRight = faceAnchor.blendShapes[.mouthPressRight] as! CGFloat
    //        let mouthLowerDownLeft = faceAnchor.blendShapes[.mouthLowerDownLeft] as! CGFloat
    //        let mouthLowerDownRight = faceAnchor.blendShapes[.mouthLowerDownRight] as! CGFloat
    //        let mouthUpperUpLeft = faceAnchor.blendShapes[.mouthUpperUpLeft] as! CGFloat
    //        let mouthUpperUpRight = faceAnchor.blendShapes[.mouthUpperUpRight] as! CGFloat
    //        let browDownLeft = faceAnchor.blendShapes[.browDownLeft] as! CGFloat
    //        let browDownRight = faceAnchor.blendShapes[.browDownRight] as! CGFloat
    //        let browInnerUp = faceAnchor.blendShapes[.browInnerUp] as! CGFloat
    //        let browOuterUpLeft = faceAnchor.blendShapes[.browOuterUpLeft] as! CGFloat
    //        let browOuterUpRight = faceAnchor.blendShapes[.browOuterUpRight] as! CGFloat
    //        let cheekPuff = faceAnchor.blendShapes[.cheekPuff] as! CGFloat
    //        let cheekSquintLeft = faceAnchor.blendShapes[.cheekSquintLeft] as! CGFloat
    //        let cheekSquintRight = faceAnchor.blendShapes[.cheekSquintRight] as! CGFloat
    //        let noseSneerLeft = faceAnchor.blendShapes[.noseSneerLeft] as! CGFloat
    //        let noseSneerRight = faceAnchor.blendShapes[.noseSneerRight] as! CGFloat
            
            // 3
            if rightSmileValue > 0.8, leftSmileValue > 0.8 {
                print("blendSmile")
                isSmiling = true
            } else {
                isSmiling = false
            }
    //            } else {
    //            resetTracking()
                isRequest = false
                }
    //        for shape in faceAnchor.blendShapes {
    //            if Double(shape.value) > 0.5 {
    //                print(shape.key,shape.value)
    //            }
    //        }
    //        print("leftsmile",leftSmileValue, "rightsmile",rightSmileValue,
    //              "\neyeBlinkLeft",eyeBlinkLeft,
    //              "\neyeLookDownLeft",eyeLookDownLeft,
    //              "\neyeLookInLeft",eyeLookInLeft,
    //              "\neyeLookUpLeft",eyeLookUpLeft,
    //              "\neyeSquintLeft",eyeSquintLeft,
    //              "\neyeWideLeft",eyeWideLeft,
    //              "\njawForward",jawForward,
    //              "\njawLeft",jawLeft,
    //              "\njawRight",jawRight,
    //              "\njawOpen",jawOpen,
    //              "\nmouthClose",mouthClose,
    //              "\nmouthFunnel",mouthFunnel,
    //              "\nmouthPucker",mouthPucker,
    //              "\nmouthLeft",mouthLeft,
    //              "\nmouthRight",mouthRight,
    //              "\nmouthFrownLeft",mouthFrownLeft,
    //              "\nmouthFrownRight",mouthFrownRight,
    //              "\nmouthDimpleLeft",mouthDimpleLeft,
    //              "\nmouthDimpleRight",mouthDimpleRight,
    //              "\nmouthStretchLeft",mouthStretchLeft,
    //              "\nmouthStretchRight",mouthStretchRight,
    //              "\nmouthRollLower",mouthRollLower,
    //              "\nmouthRollUpper",mouthRollUpper,
    //              "\nmouthShrugLower",mouthShrugLower,
    //              "\nmouthShrugUpper",mouthShrugUpper,
    //              "\nmouthPressLeft",mouthPressLeft,
    //              "\nmouthPressRight",mouthPressRight,
    //              "\nmouthLowerDownLeft",mouthLowerDownLeft,
    //              "\nmouthLowerDownRight",mouthLowerDownRight,
    //              "\nmouthUpperUpLeft",mouthUpperUpLeft,
    //              "\nmouthUpperUpRight",mouthUpperUpRight,
    //              "\nbrowDownLeft",browDownLeft,
    //              "\nbrowDownRight",browDownRight,
    //              "\nbrowInnerUp",browInnerUp,
    //              "\nbrowOuterUpLeft",browOuterUpLeft,
    //              "\nbrowOuterUpRight",browOuterUpRight,
    //              "\ncheekPuff",cheekPuff,
    //              "\ncheekSquintLeft",cheekSquintLeft,
    //              "\ncheekSquintRight",cheekSquintRight,
    //              "\nnoseSneerLeft",noseSneerLeft,
    //              "\nnoseSneerRight",noseSneerRight)
        }
}
