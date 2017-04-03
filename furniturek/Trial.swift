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
    dynamic var condition = ""
    dynamic var created = NSDate()
    dynamic var trialNumber = 1
    dynamic var imageType = ""
    dynamic var imageName = ""
    
    dynamic var response = ""
    dynamic var rt: Double = 0 //reaction time in milliseconds
    
    dynamic var strongpx = ""
    dynamic var weakpx = ""
    dynamic var averagepx = ""
    dynamic var X1biggestpx = ""
    
    dynamic var strongResp = 0
    dynamic var weakResp = 0
    dynamic var averageResp = 0
    dynamic var X1biggestResp = 0
    
    dynamic var sgcorrectpx = ""
    dynamic var sgcorrectResp = 0
}
