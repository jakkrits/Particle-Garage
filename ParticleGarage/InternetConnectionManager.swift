//
//  InternetConnectionManager.swift
//  iParticle
//
//  Created by JakkritS on 3/14/2559 BE.
//  Copyright © 2559 AppIllustrator. All rights reserved.
//

import Foundation
import ReachabilitySwift
import UIKit

@objc protocol InternetConnectionManagerDelegate: NSObjectProtocol {
    func reachabilityStatusChangeHandler(reachability: Reachability)
}

class InternetConnectionManager: NSObject {
    var delegate: InternetConnectionManagerDelegate? = nil
    private var _useClosure = false
    private var reachability: Reachability?
    private var _isReachable = false
    
    var isReachable: Bool {
        return _isReachable
    }
    
    static let sharedInstance = InternetConnectionManager()
    
    func initializeReachabilityMonitor() {
        print("initialize reachability monitoring")
        do {
            let reachability = try Reachability.reachabilityForInternetConnection()
            self.reachability = reachability
        } catch ReachabilityError.FailedToCreateWithAddress(let address) {
            print("Unable to create Reachability with address: \(address)")
            return
        } catch {
            print("Reachabiity Error")
        }
        
        if (_useClosure) {
            reachability?.whenReachable = { reachability in
                self.notifyReachability(reachability)
            }
            reachability?.whenUnreachable = { reachability in
                self.notifyReachability(reachability)
            }
        } else {
            self.notifyReachability(reachability!)
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("unable to start notifier")
            return
        }
    }
    
    func notifyReachability(reachability: Reachability) {
        if reachability.isReachable() {
            self._isReachable = true
        } else {
            self._isReachable = false
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityChanged:", name: ReachabilityChangedNotification, object: reachability)
    }
    
    func reachabilityChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.delegate?.reachabilityStatusChangeHandler(reachability)
        }
        
    }
}























