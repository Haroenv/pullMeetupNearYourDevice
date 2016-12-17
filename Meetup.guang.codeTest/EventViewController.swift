//
//  EventViewController.swift
//  Meetup.guang.codeTest
//
//  Created by Guang on 11/28/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit

private var favState = false

final class EventViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var rsvpCountLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var favLabel: UIButton!
    
    var eventDetail = Event(dictionary:[:])
    var eventIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = eventDetail?.name
        groupNameLabel.text = eventDetail?.groupName
        
        let currentFavState = eventList[eventIndex].fav
        print(currentFavState, eventIndex)
        favLabel.setTitle("❤︎", forState: .Normal)
        favLabel.setTitleColor(favStateHelper(), forState: .Normal)

        rsvpCountLabel.text = eventDetail.flatMap{ x in
            return String(format: "☺︎  %d %@ are going",x.yes_rsvp_count, x.who)
        }
        timeLabel.text = eventDetail.flatMap{ x in
            let epocTime = NSTimeInterval(Double(x.time))/1000
            let date = NSDate(timeIntervalSince1970:  epocTime)
            let d = NSDateFormatter()
            d.dateFormat = "MMM d, H:mm a"
            return String(format:"➷  %@",d.stringFromDate(date))
        }
    }
    
    @IBAction func toggleFavStateButtonAction(_sender: AnyObject) {
        print("selected")
        favState = !favState
        eventList[eventIndex].fav = favState
        eventDetail?.fav = favState
        
        favLabel.setTitleColor(favStateHelper(), forState: .Normal)
        favLabel.setNeedsLayout()
    }
    
    func favStateHelper() -> UIColor {
        if (eventDetail?.fav == true){
            return UIColor.yellowColor()
        }
        return UIColor.whiteColor().colorWithAlphaComponent(0.3)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
