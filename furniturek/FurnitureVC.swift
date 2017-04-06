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
    
    //storyboard outlets
    @IBOutlet weak var character1: UIButton!
    @IBOutlet weak var character2: UIButton!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var leftDisplay: UIImageView!
    @IBOutlet weak var rightDisplay: UIImageView!
    
    
    @IBOutlet var tapRec: UITapGestureRecognizer!
    @IBOutlet weak var leftPawButton: UIButton!
    @IBOutlet weak var rightPawButton: UIButton!
    
    //progress vars for display
    var tag = 1
    var numberPaws : Int!
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
        
    }
    
    
    //MARK: Progress-Display Setup
    
    func createPaw(offsetX: CGFloat, offsetY: CGFloat) {
        position.y = position.y + offsetY //update position Y, keep original position X and pick offset
        let pawView = UIImageView()
        pawView.image = UIImage(named: "paw.png")
        pawView.frame = CGRect(x:position.x + offsetX, y: position.y, width: CGFloat((14.0/Double(numberPaws))*50), height: CGFloat((14.0/Double(numberPaws))*50))
        pawView.alpha = 0.01
        pawView.tag = tag
        progressView.addSubview(pawView)
        tag+=1
    }

    func redrawPaws() {
    //first clean up any previous paws (ie if redrawing upon orientation change)
        //remove any existing paws 
        for view in progressView.subviews {
            view.removeFromSuperview()
        }
        //reset tag
        tag = 1
    //generate subviews
        offsetY = (self.progressView.frame.height - 80)/CGFloat(numberPaws) //generate offset from view
        position = CGPoint(x:progressView.center.x, y:progressView.frame.maxY - 40) //generate position from view
        for _ in 1...numberPaws {
            //scale offset according to width of paw image
            let width_multiplier = 14.0/Double(numberPaws) * 2
            if tag % 2 == 0 {
                createPaw(offsetX: CGFloat(8*width_multiplier), offsetY: -offsetY)
            }
            else if tag % 3 == 0 {
                createPaw(offsetX: CGFloat(-7*width_multiplier), offsetY: -offsetY)
            }
            else {
                createPaw(offsetX: CGFloat(-17*width_multiplier), offsetY: -offsetY)
            }
        }
        //reveal any progress made so far
        for index in 1...i {
            view.viewWithTag(index)?.alpha = 1
        }
    }
    
    func furnitureFlip(){
        if (isFurnitureShowing) {
            
            self.hidePawButtons()
            self.hideCharacters()
            // hide furniture show progress
            UIView.transition(with: self.progressView, duration: 1.2, options: UIViewAnimationOptions.transitionCurlDown, animations: {
                self.leftDisplay.isHidden = true
                self.rightDisplay.isHidden = true
                self.progressView.isHidden = false
            })

            
            //hide furniture show Progress
//            UIView.animate(withDuration: 3.0, animations: {
//                self.leftDisplay.isHidden = true
//                self.rightDisplay.isHidden = true
//                self.progressView.isHidden = false
//            }, completion: {
//                finished in
//                self.hidePawButtons()
//                self.hideCharacters()
//            })

        } else {
//            //show Furniture hide Progress
            
//            UIView.animate(withDuration: 3.0, animations: {
//                self.leftDisplay.isHidden = false
//                self.rightDisplay.isHidden = false
//                self.progressView.isHidden = true
//            }, completion: {finished in
//                self.showCharacters()
//                self.startTimeAction()
//            })
//            
            UIView.transition(with: self.progressView, duration: 1.2, options: UIViewAnimationOptions.transitionCurlUp, animations: {
                self.progressView.isHidden = true
            }, completion: {finished in
                self.leftDisplay.isHidden = false
                self.rightDisplay.isHidden = false
                self.showCharacters()
                self.startTimeAction()
            })

        }
        
        
        isFurnitureShowing = !isFurnitureShowing
        
        //pulse paws on final display
        if i==stim.aStimuli.count {
            for pawView in progressView.subviews {
                pawView.shake(bounceMagnitude: 4.0, wiggleRotation: 0.06)
            }
        }
    }
    
    
    //MARK: Response Buttons
    
    func hidePawButtons() {
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
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
        if i==stim.aStimuli.count {
            endExperiment()
        } else {
            // access a/b values from the tuple in the array element
            let aName = stim.stimuli[i].astim
            let bName = stim.stimuli[i].bstim
            
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
                    response="R"
                    revealPawButton(button: leftPawButton)
                    character2.isEnabled = false
                
                case character2:
                    response="B"
                    revealPawButton(button: rightPawButton)
                    character1.isEnabled = false
                default:
                    response="NA"
            }
    }
    
    
    //MARK: Progress Display Functions
    
    func revealPawButton(button: UIButton) {
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
    
    
    //MARK: Realm Database
    
    func writeTrialToRealm() {
        
        let aPath = stim.aStimuli[i-1]
        let bPath = stim.bStimuli[i-1]
        let aUrl = NSURL.fileURL(withPath: aPath as! String)
        let bUrl = NSURL.fileURL(withPath: bPath as! String)
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
            newTrial.trialNumber = i-1
            newTrial.response = response
            newTrial.rt = reactionTime
            newTrial.aImageName = aFileName
            newTrial.bImageName = bFileName
            
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

        numberPaws = stim.aStimuli.count
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
        progressView.isHidden = true
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        redrawPaws()
    }
    
    override func viewWillLayoutSubviews() {
        //called here in case of rotation after initial loading but before initial display
        redrawPaws()
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

