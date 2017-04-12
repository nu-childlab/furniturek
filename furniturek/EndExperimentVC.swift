//
//  EndExperimentVC.swift
//  furniturek
//
//  Created by Casey Colby on 11/4/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit

class EndExperimentViewController: UIViewController {
    
    @IBOutlet var tapRec: UITapGestureRecognizer!
    var i = 4
    
    var alertController : UIAlertController!
    let accentColor: UIColor = UIColor(red: 68/255, green: 178/255, blue: 108/255, alpha: 1)

    @IBOutlet weak var containerView: UIView!
    
    
    //MARK: Actions
    
    @IBAction func tapReceived(_ sender: UITapGestureRecognizer) {
        //get touch location
           let position :CGPoint = sender.location(in: view)
        //create and add footprintPrint at touch
            let footprintPrint = UIImageView()
            footprintPrint.image = UIImage(named: "coin.png")
            footprintPrint.frame = CGRect(x: position.x, y: position.y, width: 80, height: 80)
            self.view.addSubview(footprintPrint)
        //for removal later
            i+=1
            footprintPrint.tag = i
    }
    
    @IBAction func clearfootprintPrintsTapped(_ sender: Any) {
        for x in 4...i{
            let image = view.viewWithTag(x)
            image?.removeFromSuperview()
        }
    }
    
    func showAlert(){
        //initialize controller
        alertController = UIAlertController(title: "Are you sure?", message: "Select 'Continue' to start a new experiment", preferredStyle: .alert)
        alertController.view.tintColor = self.accentColor
        
        
        //initialize actions
        let continueAction = UIAlertAction(title: "Continue", style: .default, handler: {action in
            self.performSegue(withIdentifier: "unwindToSetupVC", sender: self) //when save button pressed
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        })
        
        //add actions
        alertController.addAction(continueAction)
        alertController.addAction(cancelAction)
        
        //present alert controller
        self.present(alertController, animated: true, completion: nil)
    }
    

    
    
    //MARK: View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    //MARK: Navigation
    
    @IBAction func newSubjectTapped(_ sender: Any) {
        showAlert()
    }

    
}
