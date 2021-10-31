//
//  GameViewController.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/22.
//  Copyright © 2020 daisuke. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import Vision
import AVFoundation
import CoreHaptics
import ARKit

class GameViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var scnView:SCNView?
    var scene:SCNScene?
    var game = Game()
    var smileCounter = 0
    var twoSecondTimer = 0
    var mSecond:Int = 0
    var day = 0
    var cameraButton = UIImageView()
    var backgroundView = UIView()
    
    func handleSmile(){
        game.isSmiling = true
        if !game.isActioning {
            game.handleSmile()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAndStartHapticEngine()
//
         if UserDefaults.standard.string(forKey: "notFirst") != nil {
        //        UserDefaults.standard.removeObject(forKey: "notFirst")
                print("already launched")
                } else {
                print("first!")
                performSegue(withIdentifier: "InitialTerm", sender: self)
        
        //        UserDefaults.standard.removeObject(forKey: "notFirst")
                }
        self.navigationController?.navigationBar.isHidden = true

        print(Calendar.current.component(.day, from: Date()))
        // day cal
//
        if UserDefaults.standard.integer(forKey: "today") == 0 {
            // initial setup
            print("firstDay")
            UserDefaults.standard.set(0, forKey: "day")
            UserDefaults.standard.set(Calendar.current.component(.day, from: Date()), forKey: "today")
            day = 0
        } else {
            // same day setup
            if UserDefaults.standard.integer(forKey: "today") == Calendar.current.component(.day, from: Date()){
                print("same day")
                day = UserDefaults.standard.integer(forKey: "day")
            } else {
                //different day setup
                let reccentDay =  UserDefaults.standard.integer(forKey: "day")
                if reccentDay == 6 {
                UserDefaults.standard.set(0,forKey: "day")
                    day = 0
                    print("day changed to \(day)")
                    } else {
                    UserDefaults.standard.set(reccentDay + 1,forKey: "day")
                    day = UserDefaults.standard.integer(forKey: "day")
                    print("day changed to \(day)")
                    }
            }
        }
        switchGame()
        
        scnView = self.view as! SCNView
        
        scnView!.scene = game.scene
        
        scnView!.backgroundColor = UIColor.black
        
        buttonSetting()
        //MARK:- Global Timer
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
            self.game.time += 1
            self.game.updateGame()
            self.mSecond += 1
            if self.game.isCameraAppear == true {
                if !ARFaceTrackingConfiguration.isSupported {return}
                self.backgroundView.isHidden = false
                self.cameraButton.isHidden = false
            }
            if self.mSecond == self.game.needRequestInterval {
                self.isRequest = true
                self.mSecond = 0
            }
        }
        setupAVCapture()
        
        NotificationCenter.default.addObserver(self, selector: #selector(segueToFaceGame), name: .notifyName, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if !supportsHaptics {return}
        engine.stop(completionHandler: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    func switchGame(){
        switch day {
        case 0:
            game = DogGame()
        case 1:
            game = Chick()
        case 2:
            game = Fox()
        case 3:
            game = Hall()
        case 4:
            game = Fish()
        case 5:
            game = PenguinGame()
        case 6:
            game = ExternalGame()
        default:
            // tutrial
            game = Dog()
        }
    }
    
    @objc func Camera() {
        switch day {
        case 0:
            performSegue(withIdentifier: "ShowCamera", sender: nil)
        case 1:
            performSegue(withIdentifier: "ShowCamera", sender: nil)
        case 2:
            performSegue(withIdentifier: "ShowCamera", sender: nil)
        case 3:
            performSegue(withIdentifier: "ShowRandomCamera", sender: nil)
        case 4:
            performSegue(withIdentifier: "ShowFishCamera", sender: nil)
        case 5:
            performSegue(withIdentifier: "ShowPenguinCamera", sender: nil)
        case 6:
            performSegue(withIdentifier: "ShowExternalCamera", sender: nil)
        default:
            // tutrial
            game = Dog()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCamera" {
            if let dvc = segue.destination as? ViewController {
                    dvc.day = self.day
            }
        }
        
        if segue.identifier == "ShowPenguinCamera" {
            if let dvc = segue.destination as? PenguinCameraViewController {
                    dvc.friendsCount = self.game.smileCounter
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    @objc func segueToFaceGame(){
        DispatchQueue.main.async {
            self.scnView?.pause(nil)
         self.performSegue(withIdentifier: "ShowFaceGame", sender: nil)
        }
    }
    
    //MARK:- Haptics
    var engine: CHHapticEngine!
    var engineNeedsStart = true
    
    lazy var supportsHaptics: Bool = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.supportsHaptics
    }()
    
    private func createAndStartHapticEngine() {
        if !supportsHaptics {return}
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }
        
        engine.stoppedHandler = { reason in
            print("Stop Handler: The engine stopped for reason: \(reason.rawValue)")
            switch reason {
            case .audioSessionInterrupt: print("Audio session interrupt")
            case .applicationSuspended: print("Application suspended")
            case .idleTimeout: print("Idle timeout")
            case .notifyWhenFinished: print("Finished")
            case .systemError: print("System error")
            @unknown default:
                print("Unknown error")
            }
            self.engineNeedsStart = true
        }
        engine.resetHandler = {
            print("The engine reset --> Restarting now!")
            
            // Tell the rest of the app to start the engine the next time a haptic is necessary.
            self.engineNeedsStart = true
        }
        do {
            try engine.start()
            engineNeedsStart = false
        } catch let error {
            fatalError("Engine Start Error: \(error)")
        }
    }
    
    private func hapticsPlay(){
        if !supportsHaptics {return}
        do {
            let hapticPlayer = try playerForMagnitude(1)
            
            try hapticPlayer?.start(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Haptic Playback Error: \(error)")
        }
    }
    
    private func playerForMagnitude(_ magnitude: Float) throws -> CHHapticPatternPlayer? {
        let volume = linearInterpolation(alpha: magnitude, min: 0.1, max: 0.4)
        let decay: Float = linearInterpolation(alpha: magnitude, min: 0.0, max: 0.1)
        let audioEvent = CHHapticEvent(eventType: .audioContinuous, parameters: [
            CHHapticEventParameter(parameterID: .audioPitch, value: -0.15),
            CHHapticEventParameter(parameterID: .audioVolume, value: volume),
            CHHapticEventParameter(parameterID: .decayTime, value: decay),
            CHHapticEventParameter(parameterID: .sustained, value: 0)
        ], relativeTime: 0)
        
        let sharpness = linearInterpolation(alpha: magnitude, min: 0.9, max: 0.5)
        let intensity = linearInterpolation(alpha: magnitude, min: 0.375, max: 1.0)
        let hapticEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [
            CHHapticEventParameter(parameterID: .hapticSharpness, value: sharpness),
            CHHapticEventParameter(parameterID: .hapticIntensity, value: intensity)
        ], relativeTime: 0)
        
        let pattern = try CHHapticPattern(events: [audioEvent, hapticEvent], parameters: [])
        return try engine.makePlayer(with: pattern)
    }
    
    private func linearInterpolation(alpha: Float, min: Float, max: Float) -> Float {
        return min + alpha * (max - min)
    }
    
    
    //MARK: - Smile
    private var requests = [VNRequest]()
    private var mlRequest = [VNRequest]()
    var currentBuffer:CVImageBuffer?
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(label: "VideoDataOutput", qos: .userInitiated, attributes: [], autoreleaseFrequency: .workItem)
    var bufferSize: CGSize = .zero
    var objectBounds = CGRect.zero
    //    var bufferView = UIImageView()
    var isRequest = false
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if isRequest {
            guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
                return
            }
            currentBuffer = pixelBuffer
            
            let exifOrientation = exifOrientationFromDeviceOrientation()
            let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: exifOrientation, options: [:])
            do {
                try imageRequestHandler.perform(self.requests)
            } catch {
                print(error)
            }
            isRequest = false
        }
    }
    
    func mlCompletion(_ results: [Any])  {
        guard let observation = results.first as? VNClassificationObservation else {
            print("its not ml observation")
            return
        }
        if observation.identifier == "smile" {
            handleSmile()
        } else {
            game.isSmiling = false
        }
    }
    
    func setupAVCapture() {
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        let captureConnection = videoDataOutput.connection(with: .video)
        captureConnection?.videoOrientation = .portrait
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.height)
            bufferSize.height = CGFloat(dimensions.width)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        //        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        //        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        //        rootLayer = previewView.layer
        //        previewLayer.frame = rootLayer.bounds
        //        rootLayer.addSublayer(previewLayer)
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    func startCaptureSession() {
        session.startRunning()
    }
    
    public func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        let curDeviceOrientation = UIDevice.current.orientation
        let exifOrientation: CGImagePropertyOrientation
        
        switch curDeviceOrientation {
        case UIDeviceOrientation.portraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = .left
        case UIDeviceOrientation.landscapeLeft:       // Device oriented horizontally, home button on the right
            exifOrientation = .upMirrored
        case UIDeviceOrientation.landscapeRight:      // Device oriented horizontally, home button on the left
            exifOrientation = .down
        case UIDeviceOrientation.portrait:            // Device oriented vertically, home button on the bottom
            exifOrientation = .up
        default:
            exifOrientation = .up
        }
        return exifOrientation
    }
    
    @discardableResult
    func setupVision() -> NSError? {
        // Setup Vision parts
        let error: NSError! = nil
        
        guard let modelURL = Bundle.main.url(forResource: "smileOrNot 2", withExtension: "mlmodelc") else {
            return NSError(domain: "VisionObjectRecognitionViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Model file is missing"])
        }
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL))
            let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: { (request, error) in
                DispatchQueue.main.async(execute: {
                    // perform all the UI updates on the main queue
                    if let results = request.results {
                        self.mlCompletion(results)
                    }
                })
            })
            let faceCropRequest:VNDetectFaceRectanglesRequest = {
                let request = VNDetectFaceRectanglesRequest(completionHandler: { (request, error) in
                    DispatchQueue.main.async(execute: {
                        // perform all the UI updates on the main queue
                        if let results = request.results {
                            self.drawVisionRequestResults(results)
                        }
                    })
                })
                request.revision = VNDetectFaceRectanglesRequestRevision2
                return request
            }()
            
            self.requests = [faceCropRequest]
            self.mlRequest = [objectRecognition]
        } catch let error as NSError {
            print("Model loading went wrong: \(error)")
        }
        
        return error
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        for observation in results where observation is VNFaceObservation {
            guard let objectObservation = observation as? VNFaceObservation else {
                print("noface")
                continue
            }
            // Select only the label with the highest confidence.
            //            let topLabelObservation = objectObservation.labels[0]
            objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
            
        }
        if currentBuffer != nil {
            let image = CIImage(cvImageBuffer: currentBuffer!)
            currentBuffer = nil
            guard let observation = results.first as? VNFaceObservation else {
                return
            }
            let faceRect = VNImageRectForNormalizedRect(observation.boundingBox,Int(image.extent.size.width), Int(image.extent.size.height))
            let faceImage = image.cropped(to: faceRect)
            //            let context = CIContext()
            //            let final = context.createCGImage(faceImage, from: faceImage.extent)
            let mlRequestHandler = VNImageRequestHandler(ciImage: faceImage, options: [:])
            do {
                try mlRequestHandler.perform(self.mlRequest)
            } catch {
                print(error)
            }
        }
    }
    
    func setUpFoxScene()->SCNScene{
        let scene = SCNScene(named: "art.scnassets/fox.scn")!
        
        // Set Animatational Node.
        
        let fox = scene.rootNode.childNode(withName: "fox", recursively: true)!
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        let constraint = SCNLookAtConstraint(target: fox)
        //                cameraNode.constraints = [constraint]
        // place the camera
        cameraNode.worldPosition = SCNVector3(x: 0, y: 1, z: fox.worldPosition.z + 1.5)
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
        let girl = scene.rootNode.childNode(withName: "girl", recursively: false)!
        let tale = girl.childNode(withName: "foxtale", recursively: true)
        let foxear = girl.childNode(withName: "foxear", recursively: true)
        tale?.runAction(SCNAction.repeatForever(SCNAction.sequence([SCNAction.rotateBy(x: 0, y: 0, z: 0.5, duration: 0.5),SCNAction.rotateBy(x: 0, y: 0, z: -0.5, duration: 0.5)])))
        return scene
    }
    
    func foxSmileAction(){
        let fox = scene!.rootNode.childNode(withName: "fox", recursively: true)!
        let foxpivot = fox.childNode(withName: "foxpivot", recursively: true)
        let girl = scene!.rootNode.childNode(withName: "girl", recursively: false)!
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
            fox.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: 1.5, z: 0), duration: 0.5),SCNAction.move(by: SCNVector3(x: 0, y: -1.5, z: 0), duration: 0.5)]))
            foxpivot?.runAction(SCNAction.rotateBy(x: 6.28319, y: 0, z: 0, duration: 1),completionHandler: {
                fox.isHidden = true
                girl.isHidden = false
                self.hapticsPlay()
            })
        case 2:
            girl.runAction(smileAction)
            hapticsPlay()
        case 3:
            girl.runAction(smileAction)
            tale?.isHidden = false
            hapticsPlay()
        case 4:
            girl.runAction(smileAction)
            foxear?.isHidden = false
            hapticsPlay()
        default:
            girl.runAction(smileAction)
            hapticsPlay()
        }
    }
    
    
    func setUpMiaCatScene()->SCNScene{
        let scene = SCNScene(named: "art.scnassets/miacat.scn")!
        
        let miacat = scene.rootNode.childNode(withName: "miacat", recursively: true)!
        miacat.isHidden = true
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        //                           let constraint = SCNLookAtConstraint(target: )
        //                cameraNode.constraints = [constraint]
        // place the camera
        //                           cameraNode.worldPosition = SCNVector3(x: 0, y: 1, z: fox.worldPosition.z + 1.5)
        //                           cameraNode.rotation = SCNVector4(x: 1, y: 0, z: 0,w: -0.5)
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
        
        return scene
    }
    var time = -1
    var isMiaAppear = false
    
    func updateMiacat(){
        let miacat = scene?.rootNode.childNode(withName: "miacat", recursively: false)
        
        if time < 14,!isMiaAppear {
            let hall = scene?.rootNode.childNode(withName: "hall\(time)", recursively: false)
            hall?.isHidden = false
            let position = scene?.rootNode.childNode(withName: "point\(time)", recursively: false)
            miacat?.worldPosition = SCNVector3(x: position!.worldPosition.x, y: miacat!.worldPosition.y, z: position!.worldPosition.z)
        }
    }
    
    func miaSmileAction(){
        if !isMiaAppear{
            hapticsPlay()
            let miacat = scene?.rootNode.childNode(withName: "miacat", recursively: false)
            miacat?.isHidden = false
            isMiaAppear = true
            let head = miacat?.childNode(withName: "head", recursively: false)
            let nose = head?.childNode(withName: "nose", recursively: true)
            miacat?.runAction(SCNAction.sequence([SCNAction.move(by: SCNVector3(0, 0.804, 0), duration: 0.5),SCNAction.wait(duration: 4),SCNAction.move(by: SCNVector3(x: 0, y: -0.804, z: 0), duration: 0.5)]) )
            head?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.5),SCNAction.rotateBy(x: -0.5, y: 0.2, z: 0, duration: 0.3),SCNAction.wait(duration: 1.65),SCNAction.rotateBy(x: 0, y: -0.4, z: 0, duration: 0.3),SCNAction.wait(duration: 1.65),SCNAction.rotateBy(x: 0.5, y: 0.2, z: 0, duration: 0.6)]),completionHandler: {
                self.isMiaAppear = false
                self.time -= 5
            })
            let noseHikuHiku = SCNAction.sequence([SCNAction.move(by: SCNVector3(x: 0, y: -0.1, z: 0), duration: 0.1),SCNAction.move(by: SCNVector3(x: 0, y: 0.1, z: 0), duration: 0.1)])
            nose?.runAction(SCNAction.sequence([SCNAction.wait(duration: 0.8),SCNAction.repeat(noseHikuHiku, count: 8),SCNAction.wait(duration: 0.35),SCNAction.repeat(noseHikuHiku, count: 8)]))
        }
    }
    
    func buttonSetting(){
        backgroundView.frame = CGRect(x: 0, y: view.bounds.maxY - (view.bounds.height * 0.1), width: view.bounds.width, height: view.bounds.height * 0.1)
        backgroundView.backgroundColor = UIColor.white
        backgroundView.alpha = 0.5
        let buttonHeight = backgroundView.bounds.height * 0.66
        cameraButton.frame = CGRect(x: backgroundView.center.x - (buttonHeight * 0.5), y: backgroundView.center.y - (buttonHeight * 0.5), width: buttonHeight, height: buttonHeight)
        cameraButton.image = UIImage(systemName: "camera")
        cameraButton.tintColor = UIColor.darkGray
        view.addSubview(backgroundView)
        view.addSubview(cameraButton)
        cameraButton.isUserInteractionEnabled = true
        let cameraTap = UITapGestureRecognizer(target: self, action: #selector(Camera))
        cameraButton.addGestureRecognizer(cameraTap)
        backgroundView.isHidden = true
        cameraButton.isHidden = true
    }
    
}

extension SCNReferenceNode {
    convenience init(named resourceName: String, loadImmediately: Bool = true) {
        let url = Bundle.main.url(forResource: resourceName, withExtension: "scn", subdirectory: "art.scnassets")!
        self.init(url: url)!
        if loadImmediately {
            self.load()
        }
    }
}
