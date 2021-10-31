//
//  FaceGameViewController.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/02/01.
//  Copyright © 2020 daisuke. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import ReplayKit
import AudioToolbox


class FaceGameViewController: UIViewController, ARSCNViewDelegate, RPPreviewViewControllerDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    var isRequest = false
    var cameraNode = SCNNode()
    var referenceNode = SCNNode()
    var enemyNodes:[SCNNode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            self.time += 1
            self.updateGame()
            if self.time == self.logic.threshold {
                self.isRequest = true
                self.time = 0
            }
            if self.isSmiling {
                self.handleSmile()
                self.isSmiling = false
            }
        }
        
       
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        self.navigationController?.navigationBar.isHidden = true
        sharedRecorder.isMicrophoneEnabled = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           let configuration = ARFaceTrackingConfiguration()
           sceneView.session.run(configuration)
        
         referenceNode = SCNReferenceNode(named: "shapes", loadImmediately: true)
                cameraNode = sceneView.pointOfView!
        //            switch enemy.type {
        //            case .wink:
                        cameraNode.addChildNode(referenceNode)

        //            default:
        //                <#code#>
        //            }
                
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    lazy var logic = FaceTrainingLogic()
        
    var time = 0
    var isSmiling = false
        
        func updateGame() {
            logic.time += 1
            logic.updateGame()
            referenceNode.childNode(withName: "puff", recursively: false)?.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)

        }
        
        func handleSmile() {
            logic.handleSmile()
        }
        
        func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
            if isRequest {
                isRequest = false
                guard let faceAnchor = anchor as? ARFaceAnchor else {
                    return
                }
                switchCurrentFace(faceAnchor)
            }
        }
        
        func switchCurrentFace(_ anchor: ARFaceAnchor ){
            let result = anchor.blendShapes.filter({$0.value as! Double > 0.5})
        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
}
