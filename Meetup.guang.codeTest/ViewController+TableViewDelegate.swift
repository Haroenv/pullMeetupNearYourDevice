//
//  ViewController+TableViewDelegate.swift
//  Meetup.guang.codeTest
//
//  Created by Guang on 11/28/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import  UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableview: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(eventList.count)
        return eventList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell", forIndexPath: indexPath)
        if (eventList.isEmpty){
            cell.textLabel?.text = "..."
        } else {
            let event = eventList[indexPath.row]
            print(event.name)
            cell.textLabel?.font = UIFont.init(name: "Arial", size: 16)
            cell.textLabel?.text = event.name
        }
        return cell
    }
}
