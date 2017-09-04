//
//  MainTableViewController.swift
//  ParticleController
//
//  Created by Jakkrits on 3/19/2559 BE.
//  Copyright © 2559 App Illustrator. All rights reserved.
//

import UIKit
import ReachabilitySwift

class MainTableViewController: UITableViewController, InternetConnectionManagerDelegate, SparkSetupMainControllerDelegate {
    
    var internetConnectionManager = InternetConnectionManager.sharedInstance
    var availableDevices = [SparkDevice]() {
        didSet {
            self.tableView.reloadData()
            self.appDelegate.hideActivityIndicator()
        }
    }
    let keys = ParticlegarageKeys()
    let customSetup = SparkSetupCustomization.sharedInstance()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var currentDevice: SparkDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.showActivityIndicator()
        //Hide when availableDevices didSet/ No Internet
        internetConnectionManager.delegate = self
        self.clearsSelectionOnViewWillAppear = false
        
        if InternetConnectionManager.sharedInstance.isReachable {
            sparkLogin()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.appDelegate.hideActivityIndicator()
                print("INTERNET NOT AVAILABLE")
            })
        }
        setupRefreshControl()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupRefreshControl() {
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.attributedTitle = NSAttributedString(string: "Refreshing")
        self.refreshControl!.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh(sender: AnyObject) {
        SparkCloud.sharedInstance().getDevices { (devices, error) -> Void in
            if error == nil {
                var newDevices = [SparkDevice]()
                for device in devices as! [SparkDevice] {
                    newDevices.append(device)
                }
                self.availableDevices = newDevices
                self.tableView.reloadData()
                self.refreshControl!.endRefreshing()
            } else {
                print("Error Getting Devices")
            }
        }
    }
    
    func sparkLogin() {
        SparkCloud.sharedInstance().loginWithUser(keys.particleUserName(), password: keys.particlePassword()) { (error) -> Void in
            if error == nil {
                print("logged in")
                SparkCloud.sharedInstance().getDevices { (devices, error) -> Void in
                    for device in devices as! [SparkDevice] {
                        self.availableDevices.append(device)
                    }
                }
            } else {
                print("wrong credentials")
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            return availableDevices.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.MainCellID, forIndexPath: indexPath) as! MainTableViewCell
            print(availableDevices[indexPath.row])
            cell.deviceLabel.text = availableDevices[indexPath.row].name ?? "Device Name"
            if availableDevices[indexPath.row].connected {
                cell.connectivityView.addConnectingAnimationAnimation()
            } else {
                cell.connectivityView.addConnectingAnimationAnimationReverse(true, completionBlock: nil)
            }
            
            switch availableDevices[indexPath.row].type {
            case .Core:
                cell.deviceTypeImageView.image = UIImage(named: "coreWifiCloud")
            case .Photon:
                cell.deviceTypeImageView.image = UIImage(named: "cloudWifi2")
            case .Electron:
                cell.deviceTypeImageView.image = UIImage(named: "cellPhoneCloud")
            }
            
            return cell
        }
        else if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.MainTopCellID, forIndexPath: indexPath)
            cell.textLabel?.text = "TOP"
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCellWithIdentifier(CellID.MainTopCellID, forIndexPath: indexPath) as! MainTopTableViewCell
            cell.textLabel?.text = "TOP"
            return cell }
    }
    
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SegueID.MainToDeviceDetailSegue {
            if let destinationVC = segue.destinationViewController as? DeviceDetailTableViewController {
                destinationVC.selectedDevice = currentDevice
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        currentDevice = availableDevices[indexPath.row]
        
        if currentDevice.connected == true {
            performSegueWithIdentifier(SegueID.MainToDeviceDetailSegue, sender: self)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            let alertController = UIAlertController(title: "Device Down", message: "This device is not connected to the internet, please check device's power and/or wifi connectivity", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(action)
            self.presentViewController(alertController, animated: true, completion: nil)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    //MARK: - IBActions
    @IBAction func setupButtonPressed(sender: UIBarButtonItem) {
        if let setupVC = SparkSetupMainController()
        {
            customSetup.allowSkipAuthentication = true
            
            setupVC.delegate = self
            setupVC.modalPresentationStyle = .FormSheet
            
            self.presentViewController(setupVC, animated: true, completion: nil)
        }
    }
    
    
    //MARK: - Internet Connection Manager Delegate Method
    func reachabilityStatusChangeHandler(reachability: Reachability) {
        if reachability.isReachable() {
            print("is reachable - DELEGATE CALLED")
        } else {
            print("not reachable - DELEGATE CALLED")
        }
    }
    
    //MARK: - SparkSetupMainControllerDelegate
    func sparkSetupViewController(controller: SparkSetupMainController!, didFinishWithResult result: SparkSetupMainControllerResult, device: SparkDevice!) {
        
        switch result {
        case .Success:
            print("Setup completed successfully")
        case .Failure:
            print("Setup failed")
        case .UserCancel :
            print("User cancelled setup")
        case .LoggedIn :
            print("User is logged in")
        default:
            print("Uknown setup error")
        }
        
        
    }
}


extension UIViewController {
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}


