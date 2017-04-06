//
//  Stimuli.swift
//  furniturek
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import Foundation
import UIKit

struct singleStim {
    let astim: String
    let bstim: String
}

class Stimuli {
    
    //TODO: Get both conditions and orders
    
    // always start with trial 1, then 24. then randomize the rest
    var shuffledStimuli = [
        singleStim(astim: "1At1n1s1", bstim: "1Bt0n0s0"),
        singleStim(astim: <#T##String#>, bstim: <#T##String#>)
        ]
    
    let stimuli = [singleStim(astim: "1At1n1s1", bstim: "1Bt0n0s0"), singleStim(astim: "2At1n1s0",bstim: "2Bt0n0s1")]



}

