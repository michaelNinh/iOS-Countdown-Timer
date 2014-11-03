//
//  SettingsViewController.swift
//  Glastometer
//
//  Created by Joe on 14/10/2014.
//  Copyright (c) 2014 Joe. All rights reserved.
//

import Foundation
import UIKit

protocol SettingsViewControllerDelegate{
    func myVCDidFinish(controller:SettingsViewController)
}

class SettingsViewController : UITableViewController, UITextFieldDelegate, UIActionSheetDelegate
{
    
    var editTargetDate:Bool = false;
    //var defaults: NSUserDefaults = NSUserDefaults(suiteName: "group.glastometer.com")!
    var showIconBadge: Bool!
    //var sharingMessage: String!
    
    
    //Constants
    let SECTION_FOR_DATE = 1
    let ROW_FOR_DATE = 0
    let ROW_FOR_DATE_PICKER = 1
    
    let thisCountdown = CountdownCalculator()
    let iconBadge = IconBadge()
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateDetail: UILabel!
    @IBOutlet weak var iconBadgeSwitch: UISwitch!
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var shareMessageTextField: UITextField!
    
    
    override func viewDidLoad() {
        
        eventNameTextField.delegate = self //this is required so the keyboard can be dismissed
        shareMessageTextField.delegate = self
        
        // Get the icon badge switch state from NSUserDefaults
        showIconBadge = SavedSettings().showIconBadge
        iconBadgeSwitch.setOn(showIconBadge!, animated: true)
        
        //sharingMessage = SavedSettings().sharingMessage
        
        // Get the target date from NSUserDefaults
        var targetDateString = SavedSettings().targetDate
        var targetDate = thisCountdown.DateFromString(targetDateString)
        
        //Set the target date in the countdown object
        thisCountdown.Config(targetDateString)
        
        //Set the date in the datePicker
        datePicker.setDate(targetDate, animated: true)
        
        //Set the date in the change date cell
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = "dd MMM yy HH:mm"
        dateDetail.text = dateFmt.stringFromDate(targetDate)
        
        //Add a target to be called when the date picker changes date.
        datePicker.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        //Set the eventName and shareMessage text fields
        eventNameTextField.text = SavedSettings().eventName
        shareMessageTextField.text = SavedSettings().sharingMessage
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false;
    }
    
    
    func datePickerChanged(datePicker:UIDatePicker)
    {
        var dateFmt = NSDateFormatter()
        dateFmt.timeZone = NSTimeZone.defaultTimeZone()
        dateFmt.dateFormat = "dd MMM yy HH:mm"
       
        var dateStringDisplay = dateFmt.stringFromDate(datePicker.date)
        NSLog(dateStringDisplay)
        dateDetail.text = dateStringDisplay
        
        dateFmt.dateFormat = "yyyy-MM-dd HH:mm"
        var dateStringToSave = dateFmt.stringFromDate(datePicker.date)
        NSLog(dateStringToSave)
        
        SavedSettings().targetDate = dateStringToSave
        
        //Set the target date in the countdown object
        thisCountdown.Config(dateStringToSave)
        
        showHideIconBadge()
    }

    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        if (indexPath.section == SECTION_FOR_DATE && indexPath.row == ROW_FOR_DATE_PICKER)
        {
            if (editTargetDate) {
                return self.tableView.rowHeight
            }
            else{
                return 0.0
            }
        }
        return self.tableView.rowHeight
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if (indexPath.section == SECTION_FOR_DATE && indexPath.row == ROW_FOR_DATE)
        {   //The Date row was clicked, toggle the display bit and call reloadData, this then run the above function
            editTargetDate = !editTargetDate
            self.tableView.reloadData()
        }
    }

    
    @IBAction func iconBadgeSwitchPressed(sender: AnyObject)
    {
        showIconBadge = !showIconBadge
        
        SavedSettings().showIconBadge = showIconBadge
        
        /*
        defaults.setObject(showIconBadge, forKey: "showIconBadge")
        defaults.synchronize()
        */
        
        showHideIconBadge()
    }
    
    
    func showHideIconBadge()
    {
        iconBadge.setBadge()
    }
   
    
    func textFieldDidEndEditing(textField: UITextField) {
        NSLog("textFieldDidEndEditing")
        
        textField.resignFirstResponder()
        
        if textField == eventNameTextField
        {
            NSLog("event Name text field")
            SavedSettings().eventName = textField.text
        }
        
        if textField == shareMessageTextField
        {
            NSLog("share message text field")
            SavedSettings().sharingMessage = textField.text
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        NSLog("textFieldShouldReturn")
        textField.resignFirstResponder()

        return true
    }

    @IBAction func doneButton(sender: AnyObject) {
        if((self.presentingViewController) != nil){
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
