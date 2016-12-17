//
//  LocationService.swift
//  Meetup.guang.codeTest
//
//  Created by Guang on 11/27/16.
//  Copyright © 2016 Guang. All rights reserved.
//

import Foundation
import CoreLocation

struct DeviceLocation {
    let lat: Double
    let long: Double
    let city: String?
    init(lat: Double, long: Double, city: String) {
        self.lat = lat
        self.long = long
        self.city = city
    }
}

final class Location: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = Location()
    let manager = CLLocationManager()
    var cityName = String()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var locationFoundCallback: ((city: String) -> Void)?

    /// Start the local notifications, and keep track of the callback for later
    func startListening(completion: (city: String) -> Void){
        self.locationFoundCallback = completion

        manager.requestLocation()
    }

    var currentLocation = CLLocation()
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first, locations.first?.timestamp, locations.first?.coordinate)

        if let findLocation = locations.first{
            currentLocation = findLocation
            manager.stopUpdatingLocation()
            manager.delegate = nil

            // Start async reverse-lookup
            reverseGEO(currentLocation)
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }

    //This method takes time to return; the result is not being updated to the UI, but I kept it here as an example of one way to get cityName from the device's location coordinates.
    private func reverseGEO(location:CLLocation) -> Void {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if error == nil && placemarks!.count > 0 {
                if let cityX = placemarks?.first?.locality, let callback = self.locationFoundCallback {
                    callback(city: cityX)
                }
            }
        })
    }
}

