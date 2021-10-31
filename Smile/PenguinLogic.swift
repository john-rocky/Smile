//
//  PenguinLogic.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
struct PenguinLogic {
    var time:Int = 0
    
    var rythm:[Int] = [
        0,1,0,1,0,1,0,1,
        1,0,1,0,1,0,1,0,
        1,0,0,0,1,0,0,0,
        0,1,0,1,0,1,0,1,
        0,0,0,0,0,0,0,0,
        1,0,1,0,1,0,1,0,
        1,0,0,0,1,0,0,0,
        0,1,0,1,0,1,0,1
    ]
    
    var isSmile = false
    var friendCount = 0
    var allPenguinAppeard = false
    
    mutating func updateGame(){
        if time < rythm.count - 1 {
            time += 1
            if rythm[time] == 0 {
                print("🧊")
            } else {
                print("🐧")
            }
        } else {
            time = 0
            allPenguinAppeard = true
            print("allPenguinAppeard")
        }
        isSmile = false
    }
}
