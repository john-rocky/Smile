//
//  ChickCameraViewController.swift
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

class ExternalCameraViewController: UIViewController, ARSCNViewDelegate ,RPPreviewViewControllerDelegate,UIGestureRecognizerDelegate{

    var time = 0
    var isSmiling = false
    var isRequest = false
    var contentNode = SCNNode()
    var game = Game()
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        sharedRecorder.isMicrophoneEnabled = true
        
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
//        sceneView.pointOfView?.addChildNode(SCNReferenceNode(named: "externalcamera"))
//        sceneView.scene = SCNScene(named: "art.scnassets/externalcamera.scn")!
//        for node in sceneView.scene.rootNode.childNodes {
//                node.randomCameraWalk()
//        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.time += 1
            if self.time == 5 {
                self.time = 0
                self.changeNode()
            }
                
            if self.isSmiling {
                self.handleSmile()
            }else{
                self.handleNotSmile()
            }
            self.isRequest = true
        }
        }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard anchor is ARFaceAnchor else { return nil }
        contentNode = SCNReferenceNode(named: "externalcamera")
        return contentNode
    }
    
//     func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//               if isRequest {
//                   isRequest = false
//                   guard let faceAnchor = anchor as? ARFaceAnchor else {
//                       return
//                   }
//               }
//           }
    
    var nodeNumber = 0
    
    func changeNode(){
        contentNode.childNode(withName: "\(nodeNumber)", recursively: true)?.isHidden = true
        if nodeNumber == 12 {
            nodeNumber = 0
            contentNode.childNode(withName: "\(nodeNumber)", recursively: true)?.isHidden = false

        } else {
            nodeNumber += 1
            contentNode.childNode(withName: "\(nodeNumber)", recursively: true)?.isHidden = false
        }
    }
    
    func handleSmile(){
        
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

extension SCNNode {
    func randomCameraWalk(){
        let randomWaitTime = Double.random(in: 1...8)
        let randomRotateDuration = Double.random(in: 0.5...2)
        let randomWalkDuration = Double.random(in: 5...8)
        let randomX = Float.random(in: -0.5...0.5)
        let randomZ = Float.random(in: -1 ... -0.5)
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
