//
//  DogLogic.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
struct DogLogic {
    var time:Int = 0
    var dogState:Int = 0
    
    mutating func updateLogic() {
        print(time)
        if time == 100 {
            dogState = 0
            time = 0
        }
    }
    
    mutating func handleSmile(){
            if dogState == 4 {
                dogState = 0
            }
        dogState += 1
        time = 0
        
        if dogState == 0 {
        dogState += 1
        time = 0
        }
        
        
    }
}
