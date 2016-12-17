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
        manager.requestLocation()
        currentLocation = (manager.location)!
        cityName = reverseGEO(currentLocation) //see note from reverseGEO function below
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var currentLocation = CLLocation()

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations.first, locations.first?.timestamp, locations.first?.coordinate)
        if let findLocation = locations.first{
            currentLocation = findLocation
            manager.stopUpdatingLocation()
            manager.delegate = nil
        }
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error finding location: \(error.localizedDescription)")
    }
    //This method takes time to return; the result is not being updated to the UI, but I kept it here as an example of one way to get cityName from the device's location coordinates.
    private func reverseGEO(location:CLLocation) -> String {
        var city = ""
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemarks, error in
            if error == nil && placemarks!.count > 0 {
                self.manager.stopUpdatingLocation()
                if let cityX = placemarks?.first?.locality {
                    city = cityX
                }
            }
        })
        return city
    }
}

