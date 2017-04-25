//
//  FurnitureController.swift
//  furniturek
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import GameplayKit //for fast and uniform shuffle
import RealmSwift

@IBDesignable

class FurnitureViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    //database/experimental vars
    var i: Int = 0
    let stim = Stimuli()
    var baseTrial = Trial()
    var response = ""
    var aName = ""
    var bName = ""
    
    var ratio = 0.0
    var typePx = ""
    var numPx = ""
    var sizePx = ""
    var correctByType = 0
    var correctByNum = 0
    var correctBySize = 0
    
    //storyboard outlets
    @IBOutlet weak var character1: UIButton!
    @IBOutlet weak var character2: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var leftDisplay: UIImageView!
    @IBOutlet weak var rightDisplay: UIImageView!
    
    
    @IBOutlet weak var treasure: UIImageView!
    @IBOutlet var tapRec: UITapGestureRecognizer!
    @IBOutlet weak var leftfootprintButton: UIButton!
    @IBOutlet weak var rightfootprintButton: UIButton!
    
    //progress vars for display
    var tag = 1
    var numberfootprints : Int!
    var position : CGPoint!
    var offsetY : CGFloat = 50
    var randomX : Int = 0
    var isFurnitureShowing = true
    
    //reaction time vars
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var reactionTime: Double = 0
    
    
    //MARK: Experiment Setup 
    
    func shuffleStimuli() {
        stim.shuffledStimuli += stim.stimuli.randomized() as! [singleStim]
    }
    
    
    //MARK: Progress-Display Setup
    
    func createfootprint(offsetX: CGFloat, offsetY: CGFloat, rotationAngle: CGFloat) {
        position.y = position.y + offsetY //update position Y, keep original position X and pick offset
        let footprintView = UIImageView()
        footprintView.image = UIImage(named: "footprint.png")
        footprintView.alpha = 0.01
        footprintView.frame = CGRect(x:position.x + offsetX, y: position.y, width: CGFloat((14.0/Double(numberfootprints))*50), height: CGFloat((14.0/Double(numberfootprints))*50))
        footprintView.transform = CGAffineTransform(rotationAngle: CGFloat(rotationAngle))
        footprintView.tag = tag
        progressView.addSubview(footprintView)
        tag+=1
    }

    func redrawfootprints() {
    //first clean up any previous footprints (ie if redrawing upon orientation change)
        //remove any existing footprints
        for view in progressView.subviews {
            if (view.tag > 0) {
                view.removeFromSuperview()
            }
        }
        //reset tag
        tag = 1
    //generate subviews
        offsetY = (self.progressView.frame.height - 50)/CGFloat(numberfootprints) //generate offset from view
        position = CGPoint(x:progressView.center.x, y:progressView.frame.maxY - 5) //generate position from view
        for _ in 1...numberfootprints {
            //scale offset according to width of footprint image
            let width_multiplier = 14.0/Double(numberfootprints) * 2
            if (tag % 8 == 1 || tag == 1) {
                createfootprint(offsetX: CGFloat(0*width_multiplier), offsetY: -offsetY, rotationAngle: -50*3.14/180.0)
            }
            else if (tag % 8 == 2 || tag == 2) {
                createfootprint(offsetX: CGFloat(-25*width_multiplier), offsetY: -offsetY, rotationAngle: -40*3.14/180.0)

            }
            else if (tag % 8 == 3 || tag == 3) {
                createfootprint(offsetX: CGFloat(-55*width_multiplier), offsetY: -offsetY, rotationAngle: 5*3.14/180.0)
            }
            else if (tag % 8 == 4 || tag == 4) {
                createfootprint(offsetX: CGFloat(-25*width_multiplier), offsetY: -offsetY, rotationAngle: 65*3.14/180.0)
            }
            else if(tag % 8 == 5 || tag == 5) {
                createfootprint(offsetX: CGFloat(10*width_multiplier), offsetY: -offsetY, rotationAngle: 50*3.14/180.0)
            }
            else if(tag % 8 == 6 || tag == 6) {
                createfootprint(offsetX: CGFloat(35*width_multiplier), offsetY: -offsetY, rotationAngle: 40*3.14/180.0)
            }
            else if(tag % 8 == 7 || tag == 7) {
                createfootprint(offsetX: CGFloat(55*width_multiplier), offsetY: -offsetY, rotationAngle: -5*3.14/180.0)
            }
            else if(tag % 8 == 0 || tag == 8) {
                createfootprint(offsetX: CGFloat(35*width_multiplier), offsetY: -offsetY, rotationAngle: -60*3.14/180.0)
            }
        }
        //reveal any progress made so far
        for index in 1...i {
            view.viewWithTag(index)?.alpha = 1
        }
    }
    
    func furnitureFlip(){
        if (isFurnitureShowing) {
            
            self.hidefootprintButtons()
            self.hideCharacters()
            // hide furniture show progress
            UIView.transition(with: self.progressView, duration: 1.2, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.progressView.isHidden = false
            })


        } else {
//            //show Furniture hide Progress
            UIView.transition(with: self.progressView, duration: 1.2, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.progressView.isHidden = true
            }, completion: {finished in
                self.showCharacters()
                self.startTimeAction()
            })

        }
        
        
        isFurnitureShowing = !isFurnitureShowing
        
        //pulse footprints on final display
        if i==stim.shuffledStimuli.count {
            for footprintView in progressView.subviews {
                footprintView.shake(bounceMagnitude: 4.0, wiggleRotation: 0.06)
            }
        }
    }
    
    
    //MARK: Response Buttons
    
    func hidefootprintButtons() {
        leftfootprintButton.isHidden = true
        rightfootprintButton.isHidden = true
    }
    
    func hideCharacters() {
        character1.isHidden = true
        character2.isHidden = true
    }
    
    func showCharacters() {
        character1.isHidden = false
        character2.isHidden = false
    }
    
    func wobbleButton(sender:UIButton) {
        //shrink
        sender.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        //bounce back to normal size
        UIView.animate(withDuration: 2.0,
                       delay: 0,
                       usingSpringWithDamping: 0.2,
                       initialSpringVelocity: 6.0,
                       options: UIViewAnimationOptions.allowUserInteraction,
                       animations: {
                        sender.transform =
                            CGAffineTransform.identity}
            , completion: nil)
        sender.isEnabled = false
    }
    
    
    //MARK: Experimental Actions
    
    func nextImages() {
        if i==stim.shuffledStimuli.count {
            endExperiment()
        } else {
            // access a/b values from the tuple in the array element
            aName = stim.shuffledStimuli[i].astim
            bName = stim.shuffledStimuli[i].bstim
            
             // use imageWithContentsOfFile:. This will keep your single-use image out of the system image cache, potentially improving the memory use characteristics of your app.
            let aPath = Bundle.main.path(forResource:aName, ofType: "png", inDirectory: "stimuli")! as NSObject
            let bPath = Bundle.main.path(forResource:bName, ofType: "png", inDirectory: "stimuli")! as NSObject
            leftDisplay.image = UIImage(contentsOfFile: aPath as! String)
            rightDisplay.image = UIImage(contentsOfFile: bPath as! String)
            
            i+=1
            
            character1.isEnabled = true
            character2.isEnabled = true
        }
    }
    
    func endExperiment() {
        NSLog("Experiment terminated successfully")
        self.performSegue(withIdentifier: "endExperiment", sender: self)
    }
    
    @IBAction func subjectResponse(_ sender:UIButton) {
        stopTimeAction()
        wobbleButton(sender: sender)
            //next image called when progressView is dismissed
            //show button which calls progress view
            switch sender{
                case character1:
                    response="A"
                    revealfootprintButton(button: leftfootprintButton)
                    character2.isEnabled = false
                
                case character2:
                    response="B"
                    revealfootprintButton(button: rightfootprintButton)
                    character1.isEnabled = false
                default:
                    response="NA"
            }
    }
    
    
    //MARK: Progress Display Functions
    
    func revealfootprintButton(button: UIButton) {
        button.isEnabled = true
        button.isHidden = false
        pulseButton(button: button)
    }
    

    @IBAction func showProgress() {
        writeTrialToRealm()
        for index in 1...i {
            view.viewWithTag(index)?.alpha = 1
        }
        furnitureFlip()
    }
    
    @IBAction func tapToHideProgress(_ sender: UITapGestureRecognizer) {
        if isFurnitureShowing == false {
            nextImages()
            furnitureFlip()
        }
    }
    
    func pulseButton(button: UIButton) {
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0.7
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.infinity
        button.layer.add(pulseAnimation, forKey: "layerAnimation")
    }
    
    //MARK: Reaction Time Functions
    
    func startTimeAction() { //called in dotDisplayFlip()
        startTime = NSDate().timeIntervalSinceReferenceDate
    }
    
    func stopTimeAction() { //called in subjectResponse()
        endTime = NSDate().timeIntervalSinceReferenceDate
        reactionTime = (endTime-startTime).timeMilliseconds.roundTo(places: 3)
        
        //ensure any experiment oddities won't log fake reaction times.
        startTime = 0
        endTime = 0
    }
    
    // MARK: Data preprocessing
    
    func preprocessData() {
        // ratio by imagename
        switch aName {
        case "1At1n1s1", "24At0n0s0", "11At1n0s1", "7At0n0s1","14At0n1s0","21At0n1s1","4At1n0s0", "18At1n1s0":
            ratio  = 2
        case "23At0n0s1", "16At0n0s0", "10At1n1s0", "13At0n1s1", "6At0n1s0","20At1n0s0","17At1n1s1", "3At1n0s1":
            ratio = 1.3
        case "22At0n1s0","2At1n1s0","19At1n0s1" , "5At0n1s1", "8At0n0s0","9At1n1s1","12At1n0s0","15At0n0s1":
            ratio = 1.5
        default:
            ratio = 0.0
        }
        
        
        // using filenames -- some have 8 characters if number is 1 digit, else 9 if number if > 10 
        // so if length of aName is 8, add a "0" to the front so the indexes match across all images
        if(aName.characters.count == 8) {
            aName = "0" + aName
        }
        
        // predictions by hypothesis using image filenames
        let tIndexA = aName.index(aName.startIndex, offsetBy: 4)
        switch aName[tIndexA] {
        case "1":
            typePx = "A"
        case "0":
            typePx = "B"
        default:
            typePx = "NA"
        }
        
        let nIndexA = aName.index(aName.startIndex, offsetBy: 6)
        switch aName[nIndexA] {
            case "1":
                numPx = "A"
            case "0":
                numPx = "B"
            default:
                numPx = "NA"
        }
        
        let sIndexA = aName.index(aName.startIndex, offsetBy: 8)
        switch aName[sIndexA] {
            case "1":
                sizePx = "A"
            case "0":
                sizePx = "B"
            default:
                sizePx = "NA"
        }
        
        // correcty by hypothesis by comparing predictions to responses
        if(response == typePx) {
            correctByType = 1
        } else {
            correctByType = 0
        }
        if(response == numPx) {
            correctByNum = 1
        } else {
            correctByNum = 0
        }
        if(response == sizePx) {
            correctBySize = 1
        } else {
            correctBySize = 0
        }
        
    }
    
    
    //MARK: Realm Database
    
    func writeTrialToRealm() {
        
        preprocessData()

        let aUrl = NSURL.fileURL(withPath: aName)
        let bUrl = NSURL.fileURL(withPath: bName)
        let aFileName = aUrl.deletingPathExtension().lastPathComponent
        let bFileName = bUrl.deletingPathExtension().lastPathComponent

        NSLog("trial number \(i-1), a: \(aFileName), \(bFileName)") //to aux file
        NSLog("subject response : \(response)")

        let realm = try! Realm()
        
        try! realm.write {
            let newTrial = Trial()
            //common
            newTrial.subjectNumber = baseTrial.subjectNumber
            //trial-specific
            newTrial.trialNumber = i
            newTrial.response = response
            newTrial.rt = reactionTime
            newTrial.aImageName = aFileName
            newTrial.bImageName = bFileName
            // preprocessing
            newTrial.ratio = ratio
            newTrial.typePx = typePx
            newTrial.numPx = numPx
            newTrial.sizePx = sizePx
            newTrial.correctByType = correctByType
            newTrial.correctByNum = correctByNum
            newTrial.correctBySize = correctBySize
            
            realm.add(newTrial)
        }
    }
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redirectLogToDocuments() //send NSlog to aux file
        
        character1.isExclusiveTouch = true
        character2.isExclusiveTouch = true
        
        shuffleStimuli()
        nextImages()
        startTimeAction() //for initial trial (dotDisplayFlip not called on load())

        numberfootprints = stim.shuffledStimuli.count
        leftfootprintButton.isHidden = true
        rightfootprintButton.isHidden = true
        progressView.isHidden = true
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        redrawfootprints()
    }
    
    override func viewWillLayoutSubviews() {
        //called here in case of rotation after initial loading but before initial display
        redrawfootprints()
    }

    //MARK: Logging
    func redirectLogToDocuments() {
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        _ = documentsDirectory.appending("/experimentLog.txt")
    }

}



extension Array {
    func randomized() -> [Any] {
        let list = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: self)
        return list
    }
}


extension TimeInterval {

    var timeMilliseconds: Double {
        //NSTimeInterval (self) is in seconds
        let milliseconds = self * 1000
        
        if milliseconds > 0 {
            return milliseconds
        } else {
            return 0
        }
    }
}


extension Double {
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}

