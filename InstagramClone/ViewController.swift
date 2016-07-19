//
//  ViewController.swift
//  InstagramClone
//
//  Created by Michael Williams on 7/18/16.
//  Copyright © 2016 Michael D. Williams. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    lazy var activityIndicator:UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        return activityIndicator
    }()
    
    
    lazy var imagePicker:UIImagePickerController = {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        return image
    }()
    
    lazy var alertView:UIAlertController = {
        var alert = UIAlertController(title: "Hello", message: "How's it going?", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        return alert
    }()
    
    @IBOutlet weak var importedImage: UIImageView!
    
    @IBAction func importImage(sender: UIButton) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pause(sender: UIButton) {
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
//        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
    }
    @IBAction func stop(sender: UIButton) {
        activityIndicator.stopAnimating()
//        UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
    }
    @IBAction func alert(sender: UIButton) {
        self.presentViewController(alertView, animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        importedImage.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

