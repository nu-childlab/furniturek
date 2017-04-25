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
        singleStim(astim: "24At0n0s0", bstim: "24Bt1n1s1")
        ]
    
    let stimuli = [singleStim(astim: "2At1n1s0", bstim: "2Bt0n0s1"),
                   singleStim(astim: "3At1n0s1",bstim: "3Bt0n1s0"),
                   singleStim(astim: "4At1n0s0", bstim: "4Bt0n1s1"),
                   singleStim(astim: "5At0n1s1", bstim: "5Bt1n0s0"),
                   singleStim(astim: "6At0n1s0", bstim: "6Bt1n0s1"),
                   singleStim(astim: "7At0n0s1", bstim: "7Bt1n1s0"),
                   singleStim(astim: "8At0n0s0", bstim: "8Bt1n1s1"),
                   singleStim(astim: "9At1n1s1", bstim: "9Bt0n0s0"),
                   singleStim(astim: "10At1n1s0", bstim: "10Bt0n0s1"),
                   singleStim(astim: "11At1n0s1", bstim: "11Bt0n1s0"),
                   singleStim(astim: "12At1n0s0", bstim: "12Bt0n1s1"),
                   singleStim(astim: "13At0n1s1", bstim: "13Bt1n0s0"),
                   singleStim(astim: "14At0n1s0", bstim: "14Bt1n0s1"),
                   singleStim(astim: "15At0n0s1", bstim: "15Bt1n1s0"),
                   singleStim(astim: "16At0n0s0", bstim: "16Bt1n1s1"),
                   singleStim(astim: "17At1n1s1", bstim: "17Bt0n0s0"),
                   singleStim(astim: "18At1n1s0", bstim: "18Bt0n0s1"),
                   singleStim(astim: "19At1n0s1", bstim: "19Bt0n1s0"),
                   singleStim(astim: "20At1n0s0", bstim: "20Bt0n1s1"),
                   singleStim(astim: "21At0n1s1", bstim: "21Bt1n0s0"),
                   singleStim(astim: "22At0n1s0", bstim: "22Bt1n0s1"),
                   singleStim(astim: "23At0n0s1", bstim: "23Bt1n1s0")
                ]

}

