//
//  AppDelegate.swift
//  ParticleController
//
//  Created by Jakkrits on 3/19/2559 BE.
//  Copyright © 2559 App Illustrator. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var activityView = UIView(frame: UIScreen.mainScreen().bounds)
    var activityIndicatorView = IndicatorView()
    let keys = ParticlegarageKeys()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        InternetConnectionManager.sharedInstance.initializeReachabilityMonitor()
        SparkCloud.sharedInstance().OAuthClientId = keys.oAuthClientId()
        SparkCloud.sharedInstance().OAuthClientSecret = keys.oAuthSecret()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    //Indicator View
    func showActivityIndicator() {
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        activityView.alpha = 0.65
        activityView.backgroundColor = UIColor.blackColor()
        activityIndicatorView = IndicatorView(frame: CGRectMake(activityView.frame.midX, activityView.frame.midY, 200, 100))
        activityIndicatorView.addFlashingAnimationAnimation()
        activityView.addSubview(activityIndicatorView)
        
        UIView.animateWithDuration(0.5) { () -> Void in
            self.activityView.hidden = false
        }
        
        self.window?.addSubview(activityView)
        
        activityIndicatorView.center = activityView.center
        activityView.center = self.window!.center
        
    }
    
    func hideActivityIndicator() {
        UIView.animateWithDuration(0.5) { () -> Void in
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
            self.activityView.hidden = true
        }
        activityIndicatorView.removeFromSuperview()
    }
}

