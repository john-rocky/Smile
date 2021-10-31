//
//  HallLogic.swift
//  Smile
//
//  Created by 間嶋大輔 on 2020/01/31.
//  Copyright © 2020 daisuke. All rights reserved.
//

import Foundation

struct HallLogic {
    var time:Int = 0
    var hiddingTime:Int = 0
    var appearingTime:Int = 0
    var isCreatureApear = false
    var isAllCreatureAppeard = false
    
    var creatures:[String] = []
    var friends:[String] = []
    var appearingCreatureIndex = 0
    
    mutating func updateLogic(){
        if creatures.count != 0 {
            if appearingCreatureIndex < creatures.count {
        if time == hiddingTime {
            isCreatureApear = true
            print("appear,\(creatures[appearingCreatureIndex])")
        }
        if time == hiddingTime + appearingTime {
            isCreatureApear = false
                }
        
        if time == hiddingTime + appearingTime + 3{
            hiddingTime = Int.random(in: 40...80)
            appearingTime = Int.random(in: 40...80)
            time = 0
            print("hidden,\(creatures[appearingCreatureIndex])")
            appearingCreatureIndex += 1
        }
                } else {
                appearingCreatureIndex = 0
            }
        } else {
                isAllCreatureAppeard = true
                print(friends)
        }
    }
    
    mutating func handleSmile(){
        if isCreatureApear,!isAllCreatureAppeard {
            if appearingCreatureIndex == creatures.count - 1 { appearingCreatureIndex = 0 }
            friends.append(creatures[appearingCreatureIndex])
            print("friend,\(friends.last)")
            creatures.remove(at: appearingCreatureIndex)
            if creatures.count == 0 {isAllCreatureAppeard = true}
            time = 0
            hiddingTime = Int.random(in: 40...80)
            appearingTime = Int.random(in: 40...80)
        } else {
        }
    }
    
    init(_ creaturesNames:[String]) {
        hiddingTime = Int.random(in: 40...80)
        appearingTime = Int.random(in: 40...80)
        creatures = creaturesNames
        creatures.shuffle()
        print(creatures)
    }
}
