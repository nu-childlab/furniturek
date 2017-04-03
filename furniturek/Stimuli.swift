//
//  Stimuli.swift
//  furniturek
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import Foundation
import UIKit

class Stimuli {
    
    //TODO: Get both conditions and orders
    
    var shuffled : [NSObject] = []
    
    let aStimuli : [NSObject] = [
        Bundle.main.path(forResource: "1At1n1s1", ofType: "png", inDirectory: "stimuli")! as NSObject,
        Bundle.main.path(forResource: "2At1n1s0", ofType: "png", inDirectory: "stimuli")! as NSObject,
        Bundle.main.path(forResource: "23At0n0s1", ofType: "png", inDirectory: "stimuli")! as NSObject,
    ]
    
    let bStimuli : [NSObject] = [
        Bundle.main.path(forResource: "1Bt0n0s0", ofType: "png", inDirectory: "stimuli")! as NSObject,
        Bundle.main.path(forResource: "2Bt0n0s1", ofType: "png", inDirectory: "stimuli")! as NSObject,
        Bundle.main.path(forResource: "23Bt1n1s0", ofType: "png", inDirectory: "stimuli")! as NSObject,
    ]

}

