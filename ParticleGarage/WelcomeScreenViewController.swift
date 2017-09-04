//
//  WelcomeScreenViewController.swift
//  ParticleGarage
//
//  Created by JakkritS on 3/22/2559 BE.
//  Copyright © 2559 AppIllustrator. All rights reserved.
//

import UIKit
import ReachabilitySwift

class WelcomeScreenViewController: UIViewController, InternetConnectionManagerDelegate, SparkSetupMainControllerDelegate {

    var internetConnectionManager = InternetConnectionManager.sharedInstance
    var availableDevices = [SparkDevice]() {
        didSet {
            self.appDelegate.hideActivityIndicator()
        }
    }
    let keys = ParticlegarageKeys()
    let customSetup = SparkSetupCustomization.sharedInstance()
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var currentDevice: SparkDevice!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red:0.25, green:0.27, blue:1.00, alpha:1.00)
        appDelegate.showActivityIndicator()
        //Hide when availableDevices didSet/ No Internet
        internetConnectionManager.delegate = self
        
        if InternetConnectionManager.sharedInstance.isReachable {
            sparkLogin()
        } else {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.appDelegate.hideActivityIndicator()
                print("INTERNET NOT AVAILABLE")
            })
        }
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

    func refresh(sender: AnyObject) {
        SparkCloud.sharedInstance().getDevices { (devices, error) -> Void in
            if error == nil {
                var newDevices = [SparkDevice]()
                for device in devices as! [SparkDevice] {
                    newDevices.append(device)
                }
                self.availableDevices = newDevices
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
    
    func getImageForDevice() -> UIImage {
        var deviceImage = UIImage(named: "defaultDeviceImage")
        switch availableDevices[0].type {
        case .Core:
            deviceImage = UIImage(named: "coreWifiCloud")
        case .Photon:
            deviceImage = UIImage(named: "cloudWifi2")
        case .Electron:
            deviceImage = UIImage(named: "cellPhoneCloud")
        }
        return deviceImage!
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
