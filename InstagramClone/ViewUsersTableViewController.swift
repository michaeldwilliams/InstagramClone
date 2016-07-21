//
//  ViewUsersTableViewController.swift
//  InstagramClone
//
//  Created by Michael Williams on 7/19/16.
//  Copyright © 2016 Michael D. Williams. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ViewUsersTableViewController: UITableViewController {

    let ref = FIRDatabase.database().reference()
    let currentUser = FIRAuth.auth()?.currentUser
    var users = [String]()
    var isFollowing = [String:Bool]() {
        didSet {
            tableView.reloadData()
        }
    }
    var count = 0
    
    func followUser(withIndexPath indexPath:NSIndexPath) {
        if let currentUserEmail = currentUser?.email {
            let followDict:[String:AnyObject] = ["follower":currentUserEmail, "following":users[indexPath.row]]
            ref.child("followers").childByAutoId().setValue(followDict)
            
        }
        
    }

    
    func unFollowUser(withIndexPath indexPath:NSIndexPath) {
        if let currentUserEmail = currentUser?.email {
            ref.child("followers").observeEventType(.Value) { (snapshot:FIRDataSnapshot) in
                for child in snapshot.children {
                    if child.value["following"] as? String == self.users[indexPath.row] && child.value["follower"] as? String == currentUserEmail {
                        child.setValue(nil)
                    }
                }
            }
        }
    }
    
    func getAllUsers() {
        var users = [String]()
        self.ref.child("users").observeEventType(.Value, withBlock: {snapshot in
            for child in snapshot.children {
//                print(child)
                if let email = child.value["email"] as? String {
                    if email != self.currentUser?.email {
                        users.append(email)
                    }
                }
            }
            self.users = users
            self.tableView.reloadData()
        })
    }
    
    
//    func getAllUsersCurrentUserFollows() {
//        let followersRef = self.ref.child("followers")
//        followersRef.observeEventType(.Value) { (snapshot:FIRDataSnapshot) in
//            for child in snapshot.children {
//                let follower = child.value["follower"] as? String
//                let following = child.value["following"] as? String
//                for user in self.users {
//                    if user == following && self.currentUser?.email == follower {
//                        self.isFollowing[user] = true
//                    }
//                    else {
//                        self.isFollowing[user] = false
//                    }
//                }
//                
//            }
//        }
//    }
    
    
    func getAllUsersCurrentUserFollows() {
        let followersRef = self.ref.child("followers")
        followersRef.observeEventType(.Value) { (snapshot:FIRDataSnapshot) in
            for child in snapshot.children {
                let follower = child.value["follower"] as? String
                let following = child.value["following"] as? String
                for user in self.users {
                    if user == following && self.currentUser?.email == follower {
                        self.isFollowing[user] = true
                    }
                    else {
                        self.isFollowing[user] = false
                    }
                }
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllUsers()
        getAllUsersCurrentUserFollows()
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        
//        let sortedUsers = users.sort()
        
        cell.textLabel?.text = users[indexPath.row]
        
        if isFollowing.count > 0 {
            let followedUser = users[indexPath.row]
            if isFollowing[followedUser] == true {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }


        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            let followedUser = users[indexPath.row]
            if isFollowing[followedUser] == false {
                isFollowing[followedUser] = true
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
                followUser(withIndexPath: indexPath)
            }
            else {
                isFollowing[followedUser] = false
                cell.accessoryType = .None
                unFollowUser(withIndexPath: indexPath)
            }
            
        }
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
