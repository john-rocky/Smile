//
//  FaceTrainingLogic.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation

struct FaceTrainingLogic {
    var time = 0
    var point = 0
    var threshold:Int = 5
    
    enum FaceType {
        case wink
        case suprise
        case kiss
        case angly
        case beh
        case normal
    }
    
    struct Enemy {
        var type:FaceType
        
    }
    
    struct Attacker {
        var type:FaceType
    }
    
    var enemies:[Enemy] = []
    
    mutating func updateGame(){
        if time == 80 {
        appendEnemies(10)
            time = 0
        }
    }
    
    var attackers:[Attacker] = []
    
    mutating func handleSmile(){
        let attacker = Attacker(type: currentFace)
        attackers.append(attacker)
        print(attackers)
    }
    
    var currentFace:FaceType = .normal

    mutating func appendEnemies(_ quantity: Int){
        for _ in 1...quantity {
            let random = Int.random(in: 0...4)
            switch random {
            case 0:
                let enemy = Enemy(type: .angly)
                enemies.append(enemy)
            case 1:
                let enemy = Enemy(type: .beh)
                enemies.append(enemy)
            case 2:
                let enemy = Enemy(type: .kiss)
                enemies.append(enemy)
            case 3:
                let enemy = Enemy(type: .suprise)
                enemies.append(enemy)
            default:
                let enemy = Enemy(type: .wink)
                enemies.append(enemy)
            }
        }
        print(enemies)
    }

    var endGame = false
    
    init() {
        appendEnemies(10)
    }
}
