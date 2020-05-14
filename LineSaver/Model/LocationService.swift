//
//  LocationService.swift
//  LineSaver
//
//  Created by Cat  on 4/22/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation
import CoreLocation

// Core location logic

class LocationService: NSObject, CLLocationManagerDelegate {
    
    // Swift Singleton pattern
    static let shared = LocationService()
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getUserLocation() -> CLLocation? {
        if !CLLocationManager.locationServicesEnabled(){
            locationManager.requestWhenInUseAuthorization()
        }
        else {
            locationManager.startUpdatingLocation()
            return locationManager.location
        }
        print("location not authorized")
        return nil
    }
    
    // given the coordinates of a store, uses reverse geocoding to return set the zip code of the store
    func latLongToZip(store: Store, onSuccess: @escaping (Store) -> Void) {
        let location:CLLocation = CLLocation(latitude: store.latitude, longitude: store.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("unable to get zipcode")
                }
                else {
                    // most reverse geocoding requests will only return one placemark!
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        if let postalCode = (placemark.postalCode) {
                            store.zip = Int(postalCode) ?? 0
                            onSuccess(store)
                        }
                        
                    }
                }
            }
        }
    }
    
    // calculates the distances between the user and the store 
    func distance(latitude:Double, longitude:Double) -> Double {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        //guard let myLocation = locationManager.location
        let myLocation = CLLocation(latitude: 34.1110541, longitude: -118.0390907)
        let distance:Double = myLocation.distance(from: location)
        return distance * 0.000621
    }
    
    
}
