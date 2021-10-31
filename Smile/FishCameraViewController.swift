//
//  FishCameraViewController.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/03.
//  Copyright © 2020 daisuke. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import CoreHaptics
import ReplayKit
import AudioToolbox

class FishCameraViewController: UIViewController, ARSCNViewDelegate ,RPPreviewViewControllerDelegate,UIGestureRecognizerDelegate{
    
    var time = 0
    var isSmiling = false
    var isRequest = false
    lazy var game = Game()
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        sharedRecorder.isMicrophoneEnabled = true
        
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene = SCNScene(named: "art.scnassets/fishcamera.scn")!
        for node in sceneView.scene.rootNode.childNodes {
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
                    let position = random(Float(-2)...Float(-0.1))
                    node.worldPosition = position
                }
            }
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.time += 1
            self.updateGame()
            if self.time == 10 {
                self.time = 0
            }
            if self.isSmiling {
                self.handleSmile()
            }else{
                self.handleNotSmile()
            }
            self.isRequest = true
        }
    }
    var isMovings:[Bool] = []
    var isActioning = false
    var fishNodes:[SCNNode] = []
    var fishPositions:[SCNVector3] = []
    
    func updateGame() {
        if !isActioning {
            for _ in 0...3 {
                let randomIndex = Int.random(in: 0...22)
                let randomTime = Double.random(in: 3...8)
                let randomPosition = random(Float(-2)...Float(-0.1))
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
    
    func random(_ range:ClosedRange<Float>)->SCNVector3 {
        let z = Float.random(in: range)
        let defaultX:Float = 0
        let defaultY:Float = 0
        var plus:Float = 0
        switch z {
        case 4...:
            plus = 0
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -0.2..<0:
            plus = 0.05
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -0.4 ..< -0.2:
            plus = 0.1
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -0.6 ..< -0.4:
            plus = 0.15
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -0.8 ..< -0.6:
            plus = 0.2
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -1 ..< -0.8:
            plus = 0.25
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -1.2 ..< -1:
            plus = 0.3
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -1.4 ..< -1.2:
            plus = 0.35
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -1.6 ..< -1.4:
            plus = 0.4
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        case -1.8 ..< -1.6:
            plus = 0.45
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        default:
            plus = 0.5
            return SCNVector3(Float.random(in: (defaultX - plus)...(defaultX + plus)),Float.random(in:  (defaultY - plus * 2)...(defaultY + plus * 2)),z)
        }
    }
    
    var contentNode = SCNNode()
    var occlusionNode: SCNNode!
    var childContentNode: SCNNode?
    var fishSmilePositions:[SCNVector3] = []
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        if isRequest {
                guard let faceAnchor = anchor as? ARFaceAnchor else {
                    isSmiling = false
                    return
                }
                // 2
                let leftSmileValue = faceAnchor.blendShapes[.mouthSmileLeft] as! CGFloat
                let rightSmileValue = faceAnchor.blendShapes[.mouthSmileRight] as! CGFloat
                if rightSmileValue > 0.8, leftSmileValue > 0.8 {
                    print("blendSmile")
                    isSmiling = true
                } else {
                    isSmiling = false
                }
                    isRequest = false
                    }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        contentNode = SCNReferenceNode(named: "fishface").childNode(withName: "box", recursively: false)!
        return contentNode
    }
    
    func handleSmile(){
        for fish in contentNode.childNodes{
            fishSmilePositions.append(fish.worldPosition)
        }
        
        game.playHapticsFile("DogHelloSmile")
        isActioning = true
        for index in fishNodes.indices {
            fishNodes[index].removeAllActions()
            isMovings[index] = false
             let pivot = fishNodes[index].childNode(withName: "pivot", recursively: true)
            pivot?.removeAllActions()
                let radianX = atan2f(fishSmilePositions[index].x - fishNodes[index].worldPosition.x,fishSmilePositions[index].z - fishNodes[index].worldPosition.z)
                let radianY = atanf(fishSmilePositions[index].y - fishNodes[index].worldPosition.y)
            pivot?.runAction(SCNAction.rotateTo(x:  -CGFloat(radianY), y: CGFloat(radianX), z:0, duration: 0.5))
            fishNodes[index].runAction(SCNAction.sequence([SCNAction.move(to: fishSmilePositions[index], duration: 1),SCNAction.wait(duration: 2)]),completionHandler: {
                self.isActioning = false
            })
        }
    }
    
    func handleNotSmile(){
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        buttonSetting()
    }
    // MARK: - ARSCNViewDelegate
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    //MARK: - Button Views
    
    var isRecording = false
    let sharedRecorder = RPScreenRecorder.shared()
    var recordButton = UILabel()
    var recordingAnimationButton = UILabel()
    var backgroundView = UIView()
    var modeSwitch = [NSLocalizedString("video", comment: ""),NSLocalizedString("photo", comment: "")]
    var modeSwitchButton = UIView()
    var videoModeLabel = UILabel()
    var photoModeLabel = UILabel()
    var backButton = UILabel()
    var isPhoto = false
    
    
    @objc func switchModeSwipeLeft(){
        if !isPhoto{
            switchMode()
        }
    }
    
    @objc func switchModeSwipeRight(){
        if isPhoto{
            switchMode()
        }
    }
    
    @objc func tapRecordButton(){
        if !isPhoto {
            moviewRecord()
        } else {
            shutter()
        }
    }
    
    @objc func switchMode(){
        isPhoto.toggle()
        if !isPhoto{
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [], animations: {
                let modeSwitchButtonWidth = self.modeSwitchButton.bounds.width * 0.33
                let modeSwitchButtonHeight = self.modeSwitchButton.bounds.height
                
                self.videoModeLabel.frame = CGRect(x: (self.modeSwitchButton.bounds.width * 0.5) - (modeSwitchButtonWidth * 0.5), y: 0, width: modeSwitchButtonWidth, height: modeSwitchButtonHeight)
                self.photoModeLabel.frame = CGRect(x: (self.modeSwitchButton.bounds.width * 0.5) + (modeSwitchButtonWidth * 0.5), y: 0, width: modeSwitchButtonWidth, height: modeSwitchButtonHeight)
            },completion: { comp in
                self.videoModeLabel.textColor = UIColor.white
                self.photoModeLabel.textColor = UIColor.darkGray
                self.recordingAnimationButton.layer.backgroundColor = UIColor.white.cgColor
            })
        } else {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: [], animations: {
                let modeSwitchButtonWidth = self.modeSwitchButton.bounds.width * 0.33
                let modeSwitchButtonHeight = self.modeSwitchButton.bounds.height
                
                self.videoModeLabel.frame = CGRect(x: 0, y: 0, width: modeSwitchButtonWidth, height: modeSwitchButtonHeight)
                self.photoModeLabel.frame = CGRect(x: (self.modeSwitchButton.bounds.width * 0.5) - (modeSwitchButtonWidth * 0.5), y: 0, width: modeSwitchButtonWidth, height: modeSwitchButtonHeight)
            },completion: { comp in
                self.videoModeLabel.textColor = UIColor.darkGray
                self.photoModeLabel.textColor = UIColor.white
                self.recordingAnimationButton.layer.backgroundColor = UIColor.darkGray.cgColor
            })
        }
    }
    
    @objc func BackButton(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func shutter(){
        backButton.isHidden = true
        recordButton.isHidden = true
        modeSwitchButton.isHidden = true
        backgroundView.isHidden = true
        AudioServicesPlaySystemSound(1108)
        let saveImage = view.snapshot
        UIImageWriteToSavedPhotosAlbum(saveImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        backButton.isHidden = false
        recordButton.isHidden = false
        modeSwitchButton.isHidden = false
        modeSwitchButton.isHidden = false
        backgroundView.isHidden = false
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: NSLocalizedString("保存しました!",value: "saved!", comment: ""), message: NSLocalizedString("フォトライブラリに保存しました",value: "Saved in photo library", comment: ""), preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
        DispatchQueue.main.async { [unowned previewController] in
            //            self.initializeConfig()
            previewController.dismiss(animated: true, completion: nil)
        }
    }
    
    private func buttonSetting() {
        backgroundView.frame = CGRect(x: 0, y: view.bounds.maxY - (view.bounds.height * 0.1), width: view.bounds.width, height: view.bounds.height * 0.1)
        let buttonHeight = backgroundView.bounds.height * 0.66
        recordButton.frame = CGRect(x: backgroundView.center.x - (buttonHeight * 0.5), y: backgroundView.center.y - (buttonHeight * 0.5), width: buttonHeight, height: buttonHeight)
        recordingAnimationButton.frame = CGRect(x: buttonHeight * 0.05, y: buttonHeight * 0.05, width: buttonHeight * 0.9, height: buttonHeight * 0.9)
        
        modeSwitchButton.frame = CGRect(x: view.bounds.maxX - (buttonHeight * 3), y: backgroundView.frame.origin.y, width: buttonHeight * 3, height: buttonHeight * 0.5)
        
        let modeSwitchButtonWidth = modeSwitchButton.bounds.width * 0.33
        let modeSwitchButtonHeight = modeSwitchButton.bounds.height
        
        videoModeLabel.frame = CGRect(x: (modeSwitchButton.bounds.width * 0.5) - (modeSwitchButtonWidth * 0.5), y: 0, width: modeSwitchButtonWidth, height: modeSwitchButtonHeight)
        photoModeLabel.frame = CGRect(x: (modeSwitchButton.bounds.width * 0.5) + (modeSwitchButtonWidth * 0.5), y: 0, width: modeSwitchButtonWidth, height: modeSwitchButtonHeight)
        
        videoModeLabel.text = NSLocalizedString("Video", comment: "")
        photoModeLabel.text = NSLocalizedString("Photo", comment: "")
        videoModeLabel.textColor = UIColor.white
        photoModeLabel.textColor = UIColor.darkGray
        
        videoModeLabel.textAlignment = .center
        photoModeLabel.textAlignment = .center
        
        videoModeLabel.adjustsFontSizeToFitWidth = true
        photoModeLabel.adjustsFontSizeToFitWidth = true
        
        recordButton.layer.backgroundColor = UIColor.clear.cgColor
        recordButton.layer.borderColor = UIColor.white.cgColor
        recordButton.layer.borderWidth = 4
        recordButton.clipsToBounds = true
        recordButton.layer.cornerRadius = min(recordButton.frame.width, recordButton.frame.height) * 0.5
        
        recordingAnimationButton.layer.backgroundColor = UIColor.white.cgColor
        recordingAnimationButton.clipsToBounds = true
        recordingAnimationButton.layer.cornerRadius = min(recordingAnimationButton.frame.width, recordingAnimationButton.frame.height) * 0.5
        recordingAnimationButton.layer.borderWidth = 2
        recordingAnimationButton.layer.borderColor = UIColor.darkGray.cgColor
        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0.5
        
        backButton.frame = CGRect(x: 0, y: backgroundView.frame.origin.y, width: buttonHeight * 2, height: buttonHeight * 0.5)
        backButton.text = "< Back"
        backButton.textColor = UIColor.darkGray
        
        let symbolConfig = UIImage.SymbolConfiguration(weight: .thin)
        
        view.addSubview(backgroundView)
        view.addSubview(modeSwitchButton)
        view.bringSubviewToFront(modeSwitchButton)
        modeSwitchButton.addSubview(videoModeLabel)
        modeSwitchButton.addSubview(photoModeLabel)
        view.addSubview(recordButton)
        view.bringSubviewToFront(recordButton)
        recordButton.addSubview(recordingAnimationButton)
        view.addSubview(backButton)
        view.bringSubviewToFront(backButton)
        
        recordButton.isUserInteractionEnabled = true
        recordingAnimationButton.isUserInteractionEnabled = true
        modeSwitchButton.isUserInteractionEnabled = true
        backButton.isUserInteractionEnabled = true
        let backTap = UITapGestureRecognizer(target: self, action: #selector(BackButton))
        backButton.addGestureRecognizer(backTap)
        
        let modeSwitchTap = UITapGestureRecognizer(target: self, action: #selector(switchMode))
        modeSwitchButton.addGestureRecognizer(modeSwitchTap)
        
        let modeSwitchSwipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(switchModeSwipeLeft))
        modeSwitchSwipeLeft.direction = .left
        let modeSwitchSwipeRight = UISwipeGestureRecognizer(target: self, action: #selector(switchModeSwipeRight))
        modeSwitchSwipeRight.direction = .right
        modeSwitchButton.addGestureRecognizer(modeSwitchSwipeLeft)
        modeSwitchButton.addGestureRecognizer(modeSwitchSwipeRight)
        let recordTap = UITapGestureRecognizer(target: self, action: #selector(tapRecordButton))
        recordButton.addGestureRecognizer(recordTap)
        let recordTap4Label = UITapGestureRecognizer(target: self, action: #selector(tapRecordButton))
        recordingAnimationButton.addGestureRecognizer(recordTap4Label)
    }
    
    //    MARK: - Movie Rec
    
    func recordingButtonStyling(){
        let buttonHeight = recordButton.bounds.height
        var time = 0
        if !isRecording {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
                self.recordButton.layer.borderColor = UIColor.white.cgColor
                self.recordButton.alpha = 0.5
                
                self.recordingAnimationButton.frame = CGRect(x: buttonHeight * 0.25, y: buttonHeight * 0.25, width: buttonHeight * 0.5, height: buttonHeight * 0.5)
                self.recordingAnimationButton.layer.backgroundColor = UIColor.clear.cgColor
                self.recordingAnimationButton.clipsToBounds = true
                self.recordingAnimationButton.layer.cornerRadius = min(self.recordingAnimationButton.frame.width, self.recordingAnimationButton.frame.height) * 0.1
                self.recordingAnimationButton.layer.borderWidth = 2
                self.recordingAnimationButton.layer.borderColor = UIColor.red.cgColor
                self.recordingAnimationButton.alpha = 0.5
            }, completion: { comp in
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 1.0, options: [], animations: {
                    time += 1
                },completion:  { (comp) in
                    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 1.0, delay: 1.0, options: [], animations: {
                    })
                })
            })
        } else {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [], animations: {
                self.recordButton.layer.borderColor = UIColor.white.cgColor
                self.recordButton.alpha = 1.0
                
                self.recordingAnimationButton.frame = CGRect(x: buttonHeight * 0.05, y: buttonHeight * 0.05, width: buttonHeight * 0.9, height: buttonHeight * 0.9)
                self.recordingAnimationButton.layer.backgroundColor = UIColor.white.cgColor
                self.recordingAnimationButton.clipsToBounds = true
                self.recordingAnimationButton.layer.cornerRadius = min(self.recordingAnimationButton.frame.width, self.recordingAnimationButton.frame.height) * 0.5
                self.recordingAnimationButton.layer.borderWidth = 2
                self.recordingAnimationButton.layer.borderColor = UIColor.darkGray.cgColor
                self.recordingAnimationButton.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func moviewRecord() {
        recordingButtonStyling()
        if !isRecording {
            AudioServicesPlaySystemSound(1117)
            modeSwitchButton.isHidden = true
            modeSwitchButton.isHidden = true
            backgroundView.isHidden = true
            backButton.isHidden = true
            
            isRecording = true
            sharedRecorder.startRecording(handler: { (error) in
                if let error = error {
                    print(error)
                }
            })
        } else {
            AudioServicesPlaySystemSound(1118)
            isRecording = false
            modeSwitchButton.isHidden = false
            modeSwitchButton.isHidden = false
            backgroundView.isHidden = false
            backButton.isHidden = false
            sharedRecorder.stopRecording(handler: { (previewViewController, error) in
                previewViewController?.previewControllerDelegate = self
                self.present(previewViewController!, animated: true, completion: nil)
            })
        }
    }
}


