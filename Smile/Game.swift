//
//  Game.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/25.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
import SceneKit
import CoreHaptics

class Game:NSObject {
    var needRequestInterval = 5
    var scene = SCNScene()
    var time:Int = 0
    var smileCounter = 0
    var isActioning = false
    var isCameraAppear = false
    var isSmiling = false
    

    func updateGame(){
        
    }
    
    func handleSmile(){
        
    }
    
    //MARK:- Haptics
     var engine: CHHapticEngine!
     
    lazy var supportsHaptics: Bool = {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.supportsHaptics
    }()
    
     func createEngine() {
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
         }
         engine.resetHandler = {
             print("The engine reset --> Restarting now!")

         
         do {
            try self.engine.start()
         } catch let error {
             fatalError("Engine Start Error: \(error)")
         }
     }
        do {
                   try self.engine.start()
                } catch let error {
                    fatalError("Engine Start Error: \(error)")
                }
        }
     
    func playHapticsFile(_ filename: String){
        if !supportsHaptics { return }
               
               guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else { return }
        do {
            try engine.start()
            try engine.playPattern(from: URL(fileURLWithPath: path))
        } catch {
            print("haptics error")
        }
    }
    
     func hapticsPlay(){
        if !supportsHaptics {return}
         do {
             let hapticPlayer = try hapticsPlayer()
             
             try hapticPlayer?.start(atTime: CHHapticTimeImmediate)
         } catch let error {
             print("Haptic Playback Error: \(error)")
         }
     }
     
     func hapticsPlayer() throws -> CHHapticPatternPlayer? {
        if !supportsHaptics {return nil}

         let pattern = try CHHapticPattern(events: [], parameters: [])
         return try engine.makePlayer(with: pattern)
     }
    
    func addCamera(){
           
       }
    
    override init() {
        super.init()
        createEngine()
    }
}
