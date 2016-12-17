//
//  ViewController.swift
//  Meetup.guang.codeTest
//
//  Created by Guang on 11/27/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import UIKit

var eventList = [Event]() //Not safe for real app.

class ViewController: UIViewController, Locationable, LoadingAPI {
    
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.spinner.startAnimating()
        locateDevice {[weak self](coordinate) in
            print(coordinate.lat, coordinate.long, coordinate.city)
            self?.loadApiWithLocation(coordinate.lat, long: coordinate.long)
        }

        tableView.delegate = self
        tableView.dataSource = self
        self.spinner.hidesWhenStopped = true
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }
    
    
    func loadApiWithLocation(lat:Double, long: Double) {
        //TODO: make api key into a pretty format, also put into a private file.
        let api = String(format:"https://api.meetup.com/2/open_events?and_text=False&offset=0&format=json&lon=%.6f&limited_events=False&photo-host=secure&page=10&lat=%.6f&order=distance&desc=False&status=upcoming&sig_id=159414762&sig=e759d2d408d1dc4576e33c424acd5e440f9cbf9a",long,lat)
        let eventResource = Resource<[Event]>(url: NSURL(string: api)!, parseJson: { json in
            let eventResults = json["results"] as! NSArray
            guard let dictionaries = eventResults as? [NSDictionary] else {return nil}
            return dictionaries.flatMap(Event.init)
        })
        self.updateEvents(eventResource)
    }
    
    private func updateEvents(eventResource: Resource<[Event]>){
        eventList.removeAll()
        loadEvents(eventResource) { [weak self] events in
            dispatch_async(dispatch_get_main_queue(), {
                self?.locationLabel.text = events.first.flatMap{ x in
                    return String(format: "Meetups near %@", x.city)
                }

                eventList = events

                self?.tableView.reloadData()
                self?.spinner.stopAnimating()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toEvent") {
            let destinationVC = segue.destinationViewController as? EventViewController
            if let row = tableView.indexPathForSelectedRow?.row{
                destinationVC?.eventIndex = row
                destinationVC?.eventDetail = eventList[row] as Event
            }
        }
    }
}

protocol Locationable {}
extension Locationable where Self: UIViewController {
    func locateDevice(completion: (DeviceLocation) -> ()){
        let location = Location.sharedInstance
        location.startListening { (city) in

            let coord = location.currentLocation.coordinate
            completion(DeviceLocation.init(lat: coord.latitude, long: coord.longitude, city: city))
        }
    }
}

let shareMeetupService = MeetupService()
protocol LoadingAPI {}
extension LoadingAPI where Self: UIViewController {
    func loadEvents(resource: Resource<[Event]>, completion: ([Event]) -> ()) {
        shareMeetupService.load(resource){ result in
            guard let events = result else {return}
            completion(events)
        }
    }
}
