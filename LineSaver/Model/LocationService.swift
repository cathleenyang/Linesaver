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
    lazy var geocoder = CLGeocoder()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getUserLocation() -> CLLocation? {
        if CLLocationManager.authorizationStatus() == .authorizedAlways || CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return locationManager.location
        }
        print("location not authorized")
        return nil
    }
    
    func latLongToZip(store: Store, onSuccess: @escaping (Int) -> Void) {
        let location:CLLocation = CLLocation(latitude: store.getLat(), longitude: store.getLong())
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            DispatchQueue.main.async {
                if error != nil {
                    print("unable to get zipcode")
                }
                else {
                    // most reverse geocoding requests will only return one placemark!
                    if let placemarks = placemarks, let placemark = placemarks.first {
                        if let postalCode = (placemark.postalCode) {
                            onSuccess(Int(postalCode) ?? 0)
                        }
                        
                    }
                }
            }
        }
    }
    
    
    
}
