//
//  IntroViewController.swift
//  furniturek
//
//  Created by Casey Colby on 11/1/16.
//  Copyright © 2016 ccolby. All rights reserved.
//

import UIKit
import SwiftGifOrigin

class IntroViewController: UIViewController {

    let mainColor = UIColor(red: 255/255, green: 151/255, blue: 134/255, alpha: 1)
    var layerArray = NSMutableArray()
    
    @IBOutlet var tapRecognizer: UITapGestureRecognizer!
    var tapIndex = 0
    
    @IBOutlet weak var furnitureView: UIView!
    
    @IBOutlet weak var boy: UIImageView!
    @IBOutlet weak var girl: UIImageView!
    @IBOutlet weak var pupAlone: UIImageView!

    
    @IBOutlet weak var navigationBarTitle: UINavigationItem!

    var trial = Trial()
    
    
    //MARK: Actions 
    
    func movePuppy() {
        UIView.animate(withDuration: 2.5,
                                   delay: 0.0,
                                   options: .curveEaseOut,
                                   animations: {
                                    self.pupAlone.center = CGPoint(x: self.view.frame.maxX * CGFloat(1.15), y: self.view.frame.maxY * CGFloat(0.85))
                                    self.pupAlone.transform=CGAffineTransform(scaleX: 2.0, y: 2.0)
        },
                                   completion: { finished in
                                    self.pupAlone.alpha = 0
        })
    }
    
    @IBAction func tappedToContinue(_ sender: UITapGestureRecognizer) {
        tapIndex+=1
        
        switch tapIndex {
        case 1:
            UIView.animate(withDuration: 0.6, animations: {
                self.pupAlone.alpha = 1
                self.pupAlone.shake(bounceMagnitude: 2.0, wiggleRotation: 0.03)
            })
        case 2:
                self.movePuppy()
        case 3:
            UIView.animate(withDuration: 0.9, animations: {
                self.furnitureView.alpha = 1
            })
        case 4:
            self.performSegue(withIdentifier: "beginExperiment", sender: self)
            
        default:
            self.furnitureView.alpha = 0
            self.view.alpha = 1
        }
        
    }
    
   
    //MARK: Drawing
    
    func drawEllipse() {
        let ellipsePath = UIBezierPath(ovalIn: CGRect(x:boy.frame.minX, y:boy.frame.maxY - 110, width:girl.frame.maxX-boy.frame.minX, height:200))
        let ellipseLayer = CAShapeLayer()
        ellipseLayer.path = ellipsePath.cgPath
        ellipseLayer.fillColor = mainColor.cgColor
        view.layer.insertSublayer(ellipseLayer, at: 0)
        
        layerArray.add(ellipseLayer)
    }
    

    //MARK: View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        furnitureView.alpha = 0
        pupAlone.alpha = 0
        
        tapRecognizer.isEnabled = true
        tapRecognizer.numberOfTapsRequired = 2
        tapRecognizer.numberOfTouchesRequired = 2
        
    }
    
    override func viewDidLayoutSubviews() {
        //modify UI after autolayout triggered but before view presented to screen
        //called on every rotation too
        super.viewDidLayoutSubviews()
        drawEllipse()
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        //remove before redraw in correct position
        for layer in self.view.layer.sublayers! {
            if(layerArray.contains(layer)){
                layer.removeFromSuperlayer()
                layerArray.remove(layer)
            }
        }
    }
    
    //MARK: Navigation
    
    override func prepare(for segue:UIStoryboardSegue, sender:Any?) {
        if let destination = segue.destination as? FurnitureViewController {
            destination.baseTrial = self.trial
        }
        
    }
    
}

extension UIView {

    func shake(bounceMagnitude: Double, wiggleRotation: Double){
        
        /* shake animation based on swift 3 code found here:  http://stackoverflow.com/questions/3703922/how-do-you-create-a-wiggle-animation-similar-to-iphone-deletion-animation
         */
        let bounceY = bounceMagnitude // originally 4.0
        let bounceDuration = 0.12
        let bounceDurationVariance = 0.025
        
        let wiggleRotateAngle = wiggleRotation // originally 0.06
        let wiggleRotateDuration = 0.10
        let wiggleRotateDurationVariance = 0.025
        
        func randomize(interval: TimeInterval, withVariance variance: Double) -> Double{
            let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
            return interval + variance * random
        }
        
        //Create rotation animation
        let rotationAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotationAnim.values = [-wiggleRotateAngle, wiggleRotateAngle]
        rotationAnim.autoreverses = true
        rotationAnim.duration = randomize(interval: wiggleRotateDuration, withVariance: wiggleRotateDurationVariance)
        rotationAnim.repeatCount = HUGE
        
        //Create bounce animation
        let bounceAnimation = CAKeyframeAnimation(keyPath: "transform.translation.y")
        bounceAnimation.values = [bounceY, 0]
        bounceAnimation.autoreverses = true
        bounceAnimation.duration = randomize(interval: bounceDuration, withVariance: bounceDurationVariance)
        bounceAnimation.repeatCount = HUGE
        
        //Apply animations to view
        UIView.animate(withDuration: 0) {
            self.layer.add(rotationAnim, forKey: "rotation")
            self.layer.add(bounceAnimation, forKey: "bounce")
            self.transform = .identity
        }
    }


}

