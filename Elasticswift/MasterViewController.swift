//
//  MasterViewController.swift
//  Elasticswift
//
//  Created by tady on 12/3/14.
//  Copyright (c) 2014 tady. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var objects = NSMutableArray()

    var username: String?
    var password: String?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let leftButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logOut")
        self.navigationItem.leftBarButtonItem = leftButton

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton

        if let currentUser = ElasticUser.currentUser() {
            self.loadData()
        } else {
            showLoginAlert()
        }
    }

    func showLoginAlert() {
        var loginAlert: UIAlertController = UIAlertController(title: "SignUp / Login", message: "Plase sign up or log in.", preferredStyle: UIAlertControllerStyle.Alert)

        loginAlert.addTextFieldWithConfigurationHandler({ textfield in
            textfield.placeholder = "Your username"
        })
        loginAlert.addTextFieldWithConfigurationHandler({ textfield in
            textfield.placeholder = "Your Password"
            textfield.secureTextEntry = true
        })

        loginAlert.addAction(UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { alertAction in
            let usernameTextfield = loginAlert.textFields![0] as UITextField
            let passwordTextfield = loginAlert.textFields![1] as UITextField

            self.username = usernameTextfield.text
            self.password = passwordTextfield.text

            self.showSwitchAlert()
        }))

        self.presentViewController(loginAlert, animated: true, completion: nil)
    }

    func showSwitchAlert() {
        var loginAlert: UIAlertController = UIAlertController(title: "Create New Account?", message: "Create new account or existing account.", preferredStyle: UIAlertControllerStyle.Alert)
        loginAlert.addAction(UIAlertAction(title: "Sign Up", style: UIAlertActionStyle.Default, handler: { alertAction in

            ElasticUser.signUp(self.username!, password: self.password!, block: { (user: ElasticUser?) -> Void in
                if (user != nil) {
                    println("Sign up succeeded.")
                    self.loadData()
                } else {
                    println("Sign up error.")
                }
            })
        }))
        loginAlert.addAction(UIAlertAction(title: "Log in", style: UIAlertActionStyle.Default, handler: { alertAction in
            ElasticUser.logIn(self.username!, password: self.password!, block: { (user: ElasticUser?) -> Void in
                if (user != nil) {
                    println("Log in succeeded.")
                    self.loadData()
                } else {
                    println("Log in error.")
                }
            })
        }))
        self.presentViewController(loginAlert, animated: true, completion: nil)
    }

    func loadData() {
        self.title = ElasticUser.currentUser()!.username
    }

    func logOut() {
        ElasticUser.logOut()
        showLoginAlert()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        objects.insertObject(NSDate(), atIndex: 0)
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let object = objects[indexPath.row] as NSDate
            (segue.destinationViewController as DetailViewController).detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = objects[indexPath.row] as NSDate
        cell.textLabel!.text = object.description
        return cell
    }

//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }

//    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == .Delete {
//            objects.removeObjectAtIndex(indexPath.row)
//            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}

