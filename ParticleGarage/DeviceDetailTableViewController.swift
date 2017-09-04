//
//  DeviceDetailTableViewController.swift
//  ParticleController
//
//  Created by JakkritS on 3/19/2559 BE.
//  Copyright © 2559 App Illustrator. All rights reserved.
//

import UIKit

class DeviceDetailTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var selectedDevice: SparkDevice! {
        didSet {
            availableFunctions = selectedDevice.functions
            //availableVariables = selectedDevice.variables
            availableVariables = ["Keyasf": "Valueasdf", "Keydkjfo": "Valuesd8u", "Keyw98u": "Valuesdf83kjhjdfh"]
        }
    }
    var availableFunctions = [String]()
    var availableVariables = [String: String]() {
        didSet {
            for key in availableVariables.keys {
                variableKeys.append(key)
            }
        }
    }
    var variableKeys = [String]()
    //TODO: - Events & Publish
    
    var currentlySelected = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return availableFunctions.count
        case 1:
            return availableVariables.count
        default:
            return 1
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(CellID.DetailCellID, forIndexPath: indexPath)

        switch indexPath.section {
        case 0:
            cell.textLabel?.text = availableFunctions[indexPath.row]
        case 1:
            cell.textLabel?.text = variableKeys[indexPath.row]
        default:
            cell.textLabel?.text = ""
        }
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            let returnDescription = availableFunctions.count != 0 ? "Available Functions": ""
            return returnDescription
        case 1:
            let returnDescription = availableVariables.count != 0 ? "Available Variables": ""
            return returnDescription
        default:
            return ""
        }
    }
    

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            currentlySelected = availableFunctions[indexPath.row]
        case 1:
            currentlySelected = variableKeys[indexPath.row]
        default:
            currentlySelected = ""
        }
        
        let resultVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(StoryboardID.ResultViewController) as! ResultViewController
        resultVC.modalPresentationStyle = .Popover
        resultVC.preferredContentSize = CGSizeMake(300, 500)
        let popOverVC = resultVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.permittedArrowDirections = .Any
        popOverVC?.sourceView = tableView.cellForRowAtIndexPath(indexPath)
        popOverVC?.sourceRect = CGRectMake(50, 50, 1, 1)
        
        //Passing command & selectedDevice info
        resultVC.command = currentlySelected
        resultVC.selectedDevice = selectedDevice        
        presentViewController(resultVC, animated: true) { () -> Void in
            print("pop over")
        }
    }
    
    //MARK: - UIPopOverPresentationController
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
}
