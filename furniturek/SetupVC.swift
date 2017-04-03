//
//  SetupViewController.swift
//  furniturek
//
//  Created by Casey Colby on 11/1/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import RealmSwift

class SetupViewController: UIViewController, UIAlertViewDelegate{
    
    var trial: Trial = Trial()
    var saveAction: UIAlertAction!
    var cancelAction: UIAlertAction!
    var alertController: UIAlertController!
    var errController: UIAlertController!
    
    let brightPurple: UIColor = UIColor(red: 128/255, green: 0/255, blue: 255/255, alpha: 1)
    @IBOutlet weak var containerView: UIView!
    var layerArray = NSMutableArray()
    
    
    //MARK: Drawing
    func drawCircle(radius: Double, offset:Double) {
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.view.bounds.width/2 + CGFloat(offset),y: self.view.frame.height/2-80), radius: CGFloat(radius), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = brightPurple.cgColor
        view.layer.addSublayer(shapeLayer)
        
        layerArray.add(shapeLayer)
    }
    
    //MARK: Actions
    
    func redirectLogToDocuments(){
        let allPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = allPaths.first!
        let pathForLog = documentsDirectory.appending("/logFile.txt")
        freopen(pathForLog.cString(using: String.Encoding.ascii)!, "a+", stderr)
    }
    
    func showAlert(){
        //initialize controller
        alertController = UIAlertController(title: "New Subject", message: "Enter Subject Information", preferredStyle: .alert)
        alertController.view.tintColor = self.brightPurple

        
        //add text fields
        alertController.addTextField{ (textField:UITextField!) in
            textField.placeholder = "Subject Number"
            textField.textColor = self.brightPurple //input text
            textField.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)
        }
        
        
        alertController.addTextField { (textField:UITextField!) in
            textField.placeholder = "Condition (sg or pl)"
            textField.textColor = self.brightPurple //input text
            textField.font = UIFont.systemFont(ofSize: 22, weight: UIFontWeightLight)
        }
        
        //initialize actions
        cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        //handler means the block is executed when user selects that action
        // parameters -> return type (void)
        //in indicates the start of the closure body
        saveAction = UIAlertAction(title: "Save", style: .default, handler: {action in
            self.trial.subjectNumber = "\((self.alertController.textFields![0] as UITextField).text!)" //unwrap array UITextFields (array of type AnyObject), cast to UITextField, and get the text variable from the entry
            self.trial.condition = "\((self.alertController.textFields![1] as UITextField).text!.lowercased())"
            
            if self.validateFields() { //require that all fields are filled before segue is called
                if self.validateSubjectNumber() {
                    self.performSegue(withIdentifier: "toIntro", sender: self) //when save button pressed
                }
            }
        })
        
        //add actions
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        //present alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func validateFields() -> Bool {
        if trial.subjectNumber.isEmpty || trial.condition.isEmpty {
            errController = UIAlertController(title: "Validation Error", message: "All fields must be filled", preferredStyle: .alert)
            errController.view.tintColor = self.brightPurple
            
            let errAction = UIAlertAction(title: "Update Fields", style: UIAlertActionStyle.destructive) { alert in
                self.present(self.alertController, animated: true, completion: nil)
            }
            
            errController.addAction(errAction)
            present(errController, animated: true, completion: nil)
            return false
        }
        let conditions = ["sg", "pl"]
        if !(conditions.contains(trial.condition)) {
            errController = UIAlertController(title: "Validation Error", message: "'sg' or 'pl' conditions only", preferredStyle: .alert)
            errController.view.tintColor = self.brightPurple
            
            let errAction = UIAlertAction(title: "Update Fields", style: UIAlertActionStyle.destructive) { alert in
                self.present(self.alertController, animated: true, completion: nil)
            }
            
            errController.addAction(errAction)
            present(errController, animated: true, completion: nil)
            return false
        }
        else {
            return true
        }
    }
    
    func validateSubjectNumber() -> Bool {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent("furniturek_\(trial.subjectNumber).realm")?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            
            NSLog("validation error: \(trial.subjectNumber) already exists")
            errController = UIAlertController(title: "Validation Error", message: "\(trial.subjectNumber) already exists", preferredStyle: .alert)
            errController.view.tintColor = self.brightPurple
            
            let errAction = UIAlertAction(title: "Enter Unique Subject Number", style:UIAlertActionStyle.default) { alert in
                NSLog("entering new subject number")
                self.present(self.alertController, animated: true, completion: nil)
            }
            let overrideAction = UIAlertAction(title: "Use \(trial.subjectNumber)", style: UIAlertActionStyle.destructive) { alert in
                NSLog("proceeding with \(self.trial.subjectNumber) anyways")
                self.performSegue(withIdentifier: "toIntro", sender: self)
            }
            
            errController.addAction(errAction)
            errController.addAction(overrideAction)
            present(errController, animated: true, completion: nil)
            
            return false
        } else {
        return true
        }
    }
    @IBAction func newSubjectTapped(_ sender: Any) {
        showAlert()
    }
    
    //MARK: Realm Configuration
    func setDefaultRealmForUser() {
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("furniture_\(trial.subjectNumber).realm")
        
        //set this as the configuration used at the default location
        Realm.Configuration.defaultConfiguration = config
        
        print(Realm.Configuration.defaultConfiguration.fileURL!) //prints database filepath to the console (simulator)
        NSLog("\n\n\nSubject Number: \(trial.subjectNumber)") //to aux file
        NSLog("Condition: \(trial.condition)") //to aux file
        
    }
    

    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        redirectLogToDocuments()
        
        let angle = (-2 * 3.14/180.0)
        containerView.transform = CGAffineTransform(rotationAngle: CGFloat(angle))
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
    //remove circles before rotation
        for layer in self.view.layer.sublayers! {
            if(layerArray.contains(layer)){
                layer.removeFromSuperlayer()
                layerArray.remove(layer)
            }
        }
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        //redraw circles
        drawCircle(radius: 65,offset: -195)
        drawCircle(radius: 55, offset: 55)
        drawCircle(radius: 35,offset: 155)
        drawCircle(radius: 20,offset:220)
        drawCircle(radius: 10, offset: 260)
    }
    
    override func viewWillLayoutSubviews() {
        //spacing: 5 between
        drawCircle(radius: 65,offset: -195)
        drawCircle(radius: 55, offset: 55)
        drawCircle(radius: 35,offset: 155)
        drawCircle(radius: 20,offset:220)
        drawCircle(radius: 10, offset: 260)
    }
    
    //MARK: Navigation
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if let destination = segue.destination as? IntroViewController {
            setDefaultRealmForUser()
            destination.trial = self.trial
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){
        //for new subject from final view controller
    }
    
    
}
