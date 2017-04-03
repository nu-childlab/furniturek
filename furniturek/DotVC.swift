//
//  DotViewController.swift
//  furniturek
//
//  Created by Casey Colby on 10/20/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import GameplayKit //for fast and uniform shuffle
import RealmSwift

@IBDesignable

class DotViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    //database/experimental vars
    var i: Int = 0
    let stim = Stimuli()
    var baseTrial = Trial()
    var response = ""
    
    //storyboard outlets
    @IBOutlet weak var character1: UIButton!
    @IBOutlet weak var character2: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dotDisplay: UIImageView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet var tapRec: UITapGestureRecognizer!
    @IBOutlet weak var leftPawButton: UIButton!
    @IBOutlet weak var rightPawButton: UIButton!
    
    //progress vars for display
    var tag = 1
    var numberPaws : Int!
    var position : CGPoint!
    var offsetY : CGFloat = 50
    var randomX : Int = 0
    var isDotDisplayShowing = true
    
    //reaction time vars
    var startTime: TimeInterval = 0
    var endTime: TimeInterval = 0
    var reactionTime: Double = 0
    
    
    
    
    //MARK: Experiment Setup
    
    func selectStimuli() { //by condition
        //3 trial short version for testing/development
        if baseTrial.subjectNumber == "s999" {
            if baseTrial.condition == "sg" {
                stim.shuffled = [stim.aStimuli[0], stim.aStimuli[1], stim.aStimuli[2]]
            }
            if baseTrial.condition == "pl" {
               stim.shuffled = [stim.bStimuli[0], stim.bStimuli[1], stim.bStimuli[2]]
            }
        } else {
        //randomize order of full array of stimuli
            if baseTrial.condition == "sg" {
              stim.shuffled = stim.aStimuli.randomized() as! [NSObject]
            }
            if baseTrial.condition == "pl" {
               stim.shuffled = stim.bStimuli.randomized() as! [NSObject]
            }
        }
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
        for index in 1...i+1 {
            view.viewWithTag(index)?.alpha = 1
        }
    }
    
    func dotDisplayFlip(){
        if (isDotDisplayShowing) {
            
            //hide Dots show Progress
            UIView.transition(from: dotDisplay,
                              to: progressView,
                                      duration: 1.2,
                                      options: [.transitionFlipFromLeft, .showHideTransitionViews],
                                      completion:nil)
            hidePawButtons()
            hideCharacters()
        } else {
            //show Dots show Progress
            UIView.transition(from: progressView,
                                      to: dotDisplay,
                                      duration: 1.2,
                                      options: [.transitionFlipFromRight, .showHideTransitionViews],
                                      completion: {finished in
                                        self.showCharacters()
                                        self.startTimeAction() //start reaction timer
            })
        }
        isDotDisplayShowing = !isDotDisplayShowing
        
        //pulse paws on final display
        if i==stim.shuffled.count-1 {
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
    
    func nextImage() {
        if i==stim.shuffled.count-1 {
            endExperiment()
        } else {
            i+=1
            dotDisplay.image = UIImage(contentsOfFile: stim.shuffled[i] as! String)
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
        for index in 1...i+1 {
            view.viewWithTag(index)?.alpha = 1
        }
        dotDisplayFlip()
    }
    
    @IBAction func tapToHideProgress(_ sender: UITapGestureRecognizer) {
        if isDotDisplayShowing == false {
            nextImage()
            dotDisplayFlip()
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
        
        let path = stim.shuffled[i]
        let url = NSURL.fileURL(withPath: path as! String)
        let fileName = url.deletingPathExtension().lastPathComponent

        NSLog("trial number \(i+1), \(fileName)") //to aux file
        NSLog("subject response : \(response)")

        let realm = try! Realm()
        
        try! realm.write {
            let newTrial = Trial()
            //common
            newTrial.subjectNumber = baseTrial.subjectNumber
            newTrial.condition = baseTrial.condition
            //trial-specific
            newTrial.trialNumber = i+1
            newTrial.response = response
            newTrial.rt = reactionTime
            newTrial.imageName = fileName
            
            preprocessData(currentTrial: newTrial)
            
            realm.add(newTrial)
        }
    }
    
    func preprocessData(currentTrial: Trial) {
        //get imageType
        switch currentTrial.imageName {
        case "Slide02", "Slide03", "Slide04","Slide05":
            currentTrial.imageType = "AllT"
        case "Slide22", "Slide23", "Slide24","Slide25":
            currentTrial.imageType = "AllF"
        case "Slide17", "Slide18", "Slide19","Slide20":
            currentTrial.imageType = "ATWFlg"
        case "Slide12", "Slide13", "Slide14","Slide15":
            currentTrial.imageType = "ATWFsm"
        case "Slide27", "Slide28", "Slide29", "Slide30":
            currentTrial.imageType = "ATWFsm2"
        case "Slide07", "Slide08", "Slide09","Slide10":
            currentTrial.imageType = "ATWT"
        default: break
        }

        if baseTrial.condition == "pl" {
            //hypotheses predictions
            switch currentTrial.imageType {
                case "AllT":
                    currentTrial.strongpx = "R"
                    currentTrial.weakpx = "R"
                    currentTrial.averagepx = "R"
                    currentTrial.X1biggestpx = "R"
                case "AllF":
                    currentTrial.strongpx = "B"
                    currentTrial.weakpx = "B"
                    currentTrial.averagepx = "B"
                    currentTrial.X1biggestpx = "B"
                case "ATWFlg":
                    currentTrial.strongpx = "B"
                    currentTrial.weakpx = "B"
                    currentTrial.averagepx = "R"
                    currentTrial.X1biggestpx = "B"
                case "ATWFsm":
                    currentTrial.strongpx = "B"
                    currentTrial.weakpx = "B"
                    currentTrial.averagepx = "R"
                    currentTrial.X1biggestpx = "R"
                case "ATWFsm2":
                    currentTrial.strongpx = "B"
                    currentTrial.weakpx = "B"
                    currentTrial.averagepx = "R"
                    currentTrial.X1biggestpx = "R"
                case "ATWT":
                    currentTrial.strongpx = "B"
                    currentTrial.weakpx = "R"
                    currentTrial.averagepx = "R"
                    currentTrial.X1biggestpx = "R"
                default: break
            }
            
            //response consistent with hypotheses?
            if response == currentTrial.strongpx {
                currentTrial.strongResp = 1
            }
            if response == currentTrial.weakpx {
                currentTrial.weakResp = 1
            }
            if response == currentTrial.averagepx {
                currentTrial.averageResp = 1
            }
            if response == currentTrial.X1biggestpx {
                currentTrial.X1biggestResp = 1
            }
        }
        
        if baseTrial.condition == "sg" {
            //correct answer
            switch currentTrial.imageName {
            case "Slide02", "Slide03", "Slide04", "Slide05", "Slide07", "Slide08", "Slide09", "Slide10", "Slide12", "Slide13", "Slide18", "Slide19", "Slide20", "Slide27", "Slide28":
                currentTrial.sgcorrectpx = "R"
            case "Slide14","Slide15","Slide17","Slide22","Slide23","Slide24","Slide25","Slide29","Slide30":
                currentTrial.sgcorrectpx = "B"
            default: break
            }
            
            //subject correct?
            if response == currentTrial.sgcorrectpx {
                currentTrial.sgcorrectResp = 1
            }
        }
    }
    
    
    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        redirectLogToDocuments() //send NSlog to aux file
        
        selectStimuli()
        character1.isExclusiveTouch = true
        character2.isExclusiveTouch = true
        
        dotDisplay.image = UIImage(contentsOfFile: stim.shuffled[i] as! String)
        startTimeAction() //for initial trial (dotDisplayFlip not called on load())

        numberPaws = stim.shuffled.count
        leftPawButton.isHidden = true
        rightPawButton.isHidden = true
    }
    
    override func willAnimateRotation(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        containerView.shadow() //redraw shadow on orientation change
        redrawPaws()
    }
    
    override func viewWillLayoutSubviews() {
        //called here in case of rotation after initial loading but before initial display
        containerView.shadow()
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


extension UIView {
    func roundedCorners() {
        self.layer.cornerRadius = 16.0
        self.clipsToBounds = true
    }
    
    func shadow(){
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
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

