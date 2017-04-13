//
//  CanvasViewController.swift
//  EmojiAnimator
//
//  Created by Derrick Wong on 4/12/17.
//  Copyright © 2017 Derrick Wong. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    
    //original center of the tray
    var trayOriginalCenter: CGPoint!
    
    //offset amount that the tray will move down
    var trayDownOffset: CGFloat!
    //tray's position when up
    var trayUp: CGPoint!
    //tray's position when down
    var trayDown: CGPoint!
    
    //variable for new face
    var newlyCreatedFace: UIImageView!
    
    //original center for the new face
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    var isTrayOpen: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isTrayOpen = true
        
        //initialize tray up, down and offset fields
        trayDownOffset = 210
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        //og location in the view
        let translation = sender.translation(in: view)
        if (sender.state == .began){
            //store the tray's center into the trayOriginalCenter variable
            trayOriginalCenter = trayView.center
        } else if(sender.state == .changed){
            //change the trayView.center by the translation. Note: we ignore the x translation because we only want the tray to move up and down
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if(sender.state == .ended){
            //get the velocity of the panner
            var velocity = sender.velocity(in: view)
            
            if(velocity.y > 0){
                //it is moving down
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                                self.isTrayOpen = false
                }, completion: nil)
            } else{
                //it is moving up
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayUp
                                self.isTrayOpen = true
                }, completion: nil)
            }
        }
    }
    
    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: view)
        
        if(sender.state == .began){
            // imageView now refers to the face that you panned on
            var imageView = sender.view as! UIImageView
            
            let pan = UIPanGestureRecognizer(target: self, action: #selector(pan(_:)))
           
            //Create a new image view that has the same image
            //as the one you're currently panning.
            newlyCreatedFace = UIImageView(image: imageView.image)
            newlyCreatedFace.addGestureRecognizer(pan)
            newlyCreatedFace.isUserInteractionEnabled = true
           
            
            //newlyCreatedFace.transform = view.transform.scaledBy(x: 2.0, y: 2.0)
            
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = self.view.transform.scaledBy(x: 2.0, y: 2.0)
            }, completion: nil)
            
            //Add the new face to the main view
            view.addSubview(newlyCreatedFace)
            
            //Initialize the position of the new face
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but 
            // the new face is in the main view, you have to
            // offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            
        } else if(sender.state == .changed){
            
            // pan the position of the newlyCreatedFace.
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)

            
        } else if(sender.state == .ended){
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = self.view.transform.scaledBy(x: 1.0, y: 1.0)
            }, completion: nil)
            
        }
    }
    
    func pan(_ gesture: UIPanGestureRecognizer){
        let translation = gesture.translation(in: view)
        
        if gesture.state == .began {
            newlyCreatedFace = gesture.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = self.view.transform.scaledBy(x: 2.0, y: 2.0)
            }, completion: nil)
        } else if gesture.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if gesture.state == .ended {
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = self.view.transform.scaledBy(x: 1.0, y: 1.0)
            }, completion: nil)
        }
        
    }

    @IBAction func arrowClicked(_ sender: UITapGestureRecognizer) {
        
        print("arrow clicked")
        print(isTrayOpen)
        if(isTrayOpen == true){
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.trayView.center = self.trayDown
                            self.isTrayOpen = false
            }, completion: nil)
            
        } else{
            UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                           animations: { () -> Void in
                            self.trayView.center = self.trayUp
                            self.isTrayOpen = true
            }, completion: nil)
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
