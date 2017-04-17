//
//  Trial.swift
//  furniturek
//
//  Created by Casey Colby on 11/10/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Trial: Object {
    
    dynamic var subjectNumber = ""
    dynamic var created = NSDate()
    dynamic var trialNumber = 1
    dynamic var aImageName = ""
    dynamic var bImageName = ""
    
    dynamic var response = ""
    dynamic var rt: Double = 0 //reaction time in milliseconds
    
    dynamic var ratio = 0.0
    dynamic var typePx = ""
    dynamic var numPx = ""
    dynamic var sizePx = ""
    
    dynamic var correctByType = 0
    dynamic var correctByNum = 0
    dynamic var correctBySize = 0
}
