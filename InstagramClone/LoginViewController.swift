//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by Michael Williams on 7/18/16.
//  Copyright © 2016 Michael D. Williams. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var ref:FIRDatabaseReference = {
       let ref = FIRDatabase.database().reference()
        return ref
    }()
    let viewUsersSegue = "viewUsersSegue"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    lazy var activityIndicator:UIActivityIndicatorView = {
        var activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = .Gray
        self.view.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    
    func createUserInDatabase(withUID uid:String) {
        let userDict:[String:AnyObject] = ["uid":uid, "email":usernameTextField.text!, "followers":["follower":"", "following":""]]
        ref.child("users").child(uid).setValue(userDict)
    }
    
    
    @IBAction func signUp(sender: UIButton) {
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        FIRAuth.auth()?.createUserWithEmail(self.usernameTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                let alert:UIAlertController = {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription  , preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    return alert
                }()
                self.presentViewController(alert, animated: true, completion: nil)

            }
            else {
                if let uid = user?.uid {
                    self.createUserInDatabase(withUID: uid)
                }
                self.activityIndicator.stopAnimating()
                self.performSegueWithIdentifier(self.viewUsersSegue, sender: self)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }
        })
        
    }
    @IBAction func logIn(sender: UIButton) {
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        FIRAuth.auth()?.signInWithEmail(usernameTextField.text!, password: passwordTextField.text!, completion: { (user, error) in
            if error != nil {
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                self.activityIndicator.stopAnimating()
                let alert:UIAlertController = {
                    let alert = UIAlertController(title: "Error", message: error!.localizedDescription  , preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) in
                        self.dismissViewControllerAnimated(true, completion: nil)
                    }))
                    return alert
                }()
                self.presentViewController(alert, animated: true, completion: nil)

            }
            else {
                self.activityIndicator.stopAnimating()
                self.performSegueWithIdentifier(self.viewUsersSegue, sender: self)
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
            }

        })
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if FIRAuth.auth()?.currentUser != nil {
            self.performSegueWithIdentifier(viewUsersSegue, sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
