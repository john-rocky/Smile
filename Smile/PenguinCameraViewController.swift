//
//  PenguinCameraViewController.swift
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
import CoreMotion
private func linearInterpolation(alpha: Float, min: Float, max: Float) -> Float {
    return min + alpha * (max - min)
}
class PenguinCameraViewController: UIViewController, ARSCNViewDelegate ,RPPreviewViewControllerDelegate,UIGestureRecognizerDelegate, UICollisionBehaviorDelegate{
    // View: A single circular view to represent the sphere.
    private var sphereView: [UIImageView] = []
    
    // The sphere's radius matches the screen's corner radius.
    private let kSphereRadius: CGFloat = 72

    // Haptic Engine & State:
    private var engine: CHHapticEngine!
    private var engineNeedsStart = true

    // Animator:
    private var animator: UIDynamicAnimator!
    
    // Behaviors to give the sphere physical realism:
    private var gravity: UIGravityBehavior!
    private var wallCollisions: UICollisionBehavior!
    private var bounce: UIDynamicItemBehavior!
    
    // Managing motion data from the accelerometer & gyroscope:
    private var motionManager: CMMotionManager!
    private var motionQueue: OperationQueue!
    private var motionData: CMAccelerometerData!
    private let kMaxVelocity: Float = 500

    private var foregroundToken: NSObjectProtocol?
    private var backgroundToken: NSObjectProtocol?

    lazy var supportsHaptics: Bool = {
        return (UIApplication.shared.delegate as? AppDelegate)?.supportsHaptics ?? false
    }()

    // Track the screen dimensions:
    lazy var windowWidth: CGFloat = {
        return UIScreen.main.bounds.size.width
    }()
    
    lazy var windowHeight: CGFloat = {
        return UIScreen.main.bounds.size.height
    }()
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func createAndStartHapticEngine() {
        guard supportsHaptics else {
            return
        }

        // Create and configure a haptic engine.
        do {
            engine = try CHHapticEngine()
        } catch let error {
            fatalError("Engine Creation Error: \(error)")
        }

        // The stopped handler alerts engine stoppage.
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
            
            // Indicate that the next time the app requires a haptic, the app must call engine.start().
            self.engineNeedsStart = true
        }

        // The reset handler notifies the app that it must reload all its content.
        // If necessary, it recreates all players and restarts the engine in response to a server restart.
        engine.resetHandler = {
            print("The engine reset --> Restarting now!")
            
            // Tell the rest of the app to start the engine the next time a haptic is necessary.
            self.engineNeedsStart = true
        }

        // Start haptic engine to prepare for use.
        do {
            try engine.start()

            // Indicate that the next time the app requires a haptic, the app doesn't need to call engine.start().
            engineNeedsStart = false
        } catch let error {
            print("The engine failed to start with error: \(error)")
        }
    }

    var friendsCount = 2
    
    private func initializeSphere() {
        
        // Place sphere at the center of the screen to start.
        let sphereSize = kSphereRadius
        let xStart = floor((windowWidth - sphereSize) / 2)
        let yStart = floor((windowHeight - sphereSize) / 2)
        let frame = CGRect(x: xStart, y: yStart, width: sphereSize, height: sphereSize)
        for _ in 1...friendsCount {
        let sphere = UIImageView(frame: frame)
        sphere.image = UIImage(named: "penguin")
        sphere.layer.cornerRadius = sphereSize / 2
        
//        sphereView.layer.backgroundColor = #colorLiteral(red: 0.9696919322, green: 0.654135406, blue: 0.5897029042, alpha: 1)

        view.addSubview(sphere)
            sphereView.append(sphere)
            }
    }

    var pen = SCNNode()
    
    /// - Tag: DefineWalls
    private func initializeWalls() {
        wallCollisions = UICollisionBehavior(items: sphereView)
        wallCollisions.collisionDelegate = self
        
        // Express walls using vertices.
        let upperLeft = CGPoint(x: -1, y: -1)
        let upperRight = CGPoint(x: windowWidth + 1, y: -1)
        let lowerRight = CGPoint(x: windowWidth + 1, y: windowHeight + 1)
        let lowerLeft = CGPoint(x: -1, y: windowHeight + 1)
        
        // Each wall is a straight line shifted one pixel offscreen, to give an impression of existing at the boundary.
        
        // Left edge of the screen:
        wallCollisions.addBoundary(withIdentifier: NSString("leftWall"),
                                   from: upperLeft,
                                   to: lowerLeft)
        
        // Right edge of the screen:
        wallCollisions.addBoundary(withIdentifier: NSString("rightWall"),
                                   from: upperRight,
                                   to: lowerRight)
        
        // Top edge of the screen:
        wallCollisions.addBoundary(withIdentifier: NSString("topWall"),
                                   from: upperLeft,
                                   to: upperRight)
        
        // Bottom edge of the screen:
        wallCollisions.addBoundary(withIdentifier: NSString("bottomWall"),
                                   from: lowerRight,
                                   to: lowerLeft)

    }
    
    // Each bounce against the wall is a dynamic item behavior, which lets you tweak the elasticity to match the haptic effect.
    private func initializeBounce() {
        bounce = UIDynamicItemBehavior(items: sphereView)
        
        // Increase the elasticity to make the sphere bounce higher.
        bounce.elasticity = 0.5
    }
    
    // Represent gravity as a behavior in UIKit Dynamics:
    private func initializeGravity() {
        gravity = UIGravityBehavior(items: sphereView)
    }
    
    /// - Tag: DefineAnimator
    // The animator ties together the gravity, sphere, and wall, so the dynamics framework is aware of all the components.
    private func initializeAnimator() {
        animator = UIDynamicAnimator(referenceView: view)
        
        // Add bounce, gravity, and collision behavior.
        animator.addBehavior(bounce)
        animator.addBehavior(gravity)
        animator.addBehavior(wallCollisions)
    }
    
    /// - Tag: ActivateAccelerometer
    private func activateAccelerometer() {
        // Manage motion events in a separate queue off the main thread.
        motionQueue = OperationQueue()
        motionData = CMAccelerometerData()
        motionManager = CMMotionManager()
        
        guard let manager = motionManager else {
            return
        }
        
        manager.startDeviceMotionUpdates(to: motionQueue, withHandler: { deviceMotion, error in
            guard let motion = deviceMotion else {
                return
            }
            let gravity = motion.gravity
            
            // Dispatch gravity updates to main queue, since they affect UI.
            DispatchQueue.main.async {
                self.gravity.gravityDirection = CGVector(dx: gravity.x * 3.5,
                                                         dy: -gravity.y * 3.5)
            }
        })
    }
    
    private func addObservers() {
        backgroundToken = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification,
                                                                 object: nil,
                                                                 queue: nil) { _ in
            guard self.supportsHaptics else {
                return
            }
            // Stop the haptic engine.
            self.engine.stop(completionHandler: { error in
                if let error = error {
                    print("Haptic Engine Shutdown Error: \(error)")
                    return
                }
                self.engineNeedsStart = true
            })
        }
        foregroundToken = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification,
                                                                 object: nil,
                                                                 queue: nil) { _ in
            guard self.supportsHaptics else {
                return
            }
            // Restart the haptic engine.
            self.engine.start(completionHandler: { error in
                if let error = error {
                    print("Haptic Engine Startup Error: \(error)")
                    return
                }
                self.engineNeedsStart = false
            })
        }
    }

    // pragma mark - UICollisionBehaviorDelegate
    
    /// - Tag: MapVelocity
    func collisionBehavior(_ behavior: UICollisionBehavior,
                           beganContactFor item: UIDynamicItem,
                           withBoundaryIdentifier identifier: NSCopying?,
                           at point: CGPoint) {
        // Play collision haptic for supported devices.
        guard supportsHaptics else {
            return
        }

        // Play haptic here.
        do {
            // Start the engine if necessary.
            if engineNeedsStart {
                try engine.start()
                engineNeedsStart = false
            }

            // Map the bounce velocity to intensity & sharpness.
            let velocity = bounce.linearVelocity(for: item)
            let xVelocity = Float(velocity.x)
            let yVelocity = Float(velocity.y)

            // Normalize magnitude to map one number to haptic parameters:
            let magnitude = sqrtf(xVelocity * xVelocity + yVelocity * yVelocity)
            let normalizedMagnitude = min(max(Float(magnitude) / kMaxVelocity, 0.0), 1.0)

            // Create a haptic pattern player from normalized magnitude.
            let hapticPlayer = try playerForMagnitude(normalizedMagnitude)

            // Start player, fire and forget
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
    
    var time = 0
    var isSmiling = false
    var isRequest = false
    
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        sharedRecorder.isMicrophoneEnabled = true
        
        sceneView.delegate = self
        sceneView.automaticallyUpdatesLighting = true
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (Timer) in
            self.time += 1
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
        
        createAndStartHapticEngine()

        initializeSphere()
        initializeWalls()
        initializeBounce()
        initializeGravity()
        initializeAnimator()
        activateAccelerometer()
        
        addObservers()
    }
    
//         func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//            DispatchQueue.main.async {
//
//                self.pen.position = SCNVector3(x: Float(self.sphereView.center.x), y: Float(self.sphereView.center.y), z: self.pen.position.z)
//                    
//                }
//               }
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
