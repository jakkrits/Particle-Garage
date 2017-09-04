//
//  ResultViewController.swift
//  ParticleController
//
//  Created by Jakkrits on 3/19/2559 BE.
//  Copyright © 2559 App Illustrator. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    
    var command: String!
    var selectedDevice: SparkDevice!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ThemeColor.GreenColor
        
        setupDigitalWriteUI()
        
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
    
    func setupDigitalWriteUI() {
        firstButton.setTitle("ON", forState: .Normal)
        firstButton.addTarget(self, action: "turnD7On", forControlEvents: .TouchUpInside)
        secondButton.setTitle("OFF", forState: .Normal)
        secondButton.addTarget(self, action: "turnD7Off", forControlEvents: .TouchUpInside)
    }
    
    func turnD7On() {
        print("ON PRESSED")
        selectedDevice.callFunction(command, withArguments: ["D7", "HIGH"]) { (code, error) -> Void in
            if error == nil {
                print("Successfully code: \(code)")
            } else {
                print(error)
            }
        }
    }
    
    func turnD7Off() {
        print("OFF PRESSED")
        selectedDevice.callFunction(command, withArguments: ["D7", "LOW"]) { (code, error) -> Void in
            if error == nil {
                print("Successfully code: \(code)")
            } else {
                print(error)
            }
        }
    }
    
}
