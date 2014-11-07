//
//  TodayViewController.swift
//  Glastometer Widget
//
//  Created by Joe on 11/10/2014.
//  Copyright (c) 2014 Joe. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    @IBOutlet weak var mainLabel: UILabel!
    
    let thisCountdown = CountdownCalculator()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        super.preferredContentSize = CGSizeMake(0, 32);
        
        var targetDate = SavedSettings().targetDate
        thisCountdown.Config(targetDate)
        var rt = thisCountdown.RemainingDays()
        
        var sharingMessageEnd = SavedSettings().sharingMessage
        mainLabel.text = "\(rt.days) \(rt.daysStr) " + sharingMessageEnd
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!)
    {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }
    
}
