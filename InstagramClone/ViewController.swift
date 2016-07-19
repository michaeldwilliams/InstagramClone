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

    lazy var imagePicker:UIImagePickerController = {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        return image
    }()
    
    @IBOutlet weak var importedImage: UIImageView!
    
    @IBAction func importImage(sender: UIButton) {
        self.presentViewController(imagePicker, animated: true, completion: nil)
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

