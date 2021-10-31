//
//  ChooseTimingLogic.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation
struct ChooseTimingLogic {
    var objectIndex = 0
    var objects:[Object] = []
    
    struct Object {
        var name = ""
        var state:objectState = .hidden
    }
    
    enum objectState {
        case hidden
        case appear
        case choosed
    }
    
    init(_ objectNames:[String]) {
        for objectName in objectNames {
            let object = Object(name: objectName, state: .hidden)
            self.objects.append(object)
        }
    }
    
    mutating func handleSmile(){
        objects[objectIndex].state = .choosed
    }
}
