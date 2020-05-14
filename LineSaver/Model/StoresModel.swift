//
//  StoresModel.swift
//  LineSaver
//
//  Created by Cat  on 4/22/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class StoresModel: NSObject, CLLocationManagerDelegate {
    let ACCESS_KEY = ""
    let BASE_URL = "https://maps.googleapis.com"
    
    var stores = [Store]()
    
    override init() {
        super.init()
    }
    
    func randomBool() -> Bool {
        return arc4random_uniform(2) == 0
    }
    
    // Swift Singleton pattern
    static let shared = StoresModel()
    
    // Decide which way to fetch data
    func getStores(onSuccess: @escaping ([Store]) -> Void) {
        //let userLoc = LocationService.shared.getUserLocation()
        //guard let location = userLoc else {return}
        let latitude = 34.1110541
        let longitude = -118.0390907
        //let coord = location.coordinate //34.1110541//34.0256262 //
        //let longitude = coord.longitude//-118.2872327// -118.0390907
        //let latitude = coord.latitude
        let distance = 16000 // 10 miles
        // type=grocery_or_supermarket
        if let url = URL(string: "\(BASE_URL)/maps/api/place/nearbysearch/json?location=\(latitude),\(longitude)&radius=\(distance)&keyword=Grocery%20Store&key=\(ACCESS_KEY)" ) {
            print(url)
            let urlRequest = URLRequest(url: url)
            URLSession.shared.dataTask(with: urlRequest, completionHandler: {(data,response,error) in
                if let data = data{
                    // we have data!!
                    do {
                        let json = JSON(data)
                        // Parsing the relevant data from the JSON object
                        let unsortedStores: [Store]  =  json["results"].arrayValue.map {
                            let lat = $0["geometry"]["location"]["lat"].doubleValue
                            let long = $0["geometry"]["location"]["lng"].doubleValue
                            let name = $0["name"].stringValue
                            let placeID = $0["place_id"].stringValue
                            let address = $0["vicinity"].stringValue
                            //let distance = self.distance(lat1: latitude, lon1: longitude, lat2: lat, lon2: long, unit: "M")
                            let store = Store(placeID: placeID, name: name, address: address, latitude: lat, longitude: long)
                            if self.randomBool() {
                                store.queuingEnabled = true
                            }
                            else {
                                store.queuingEnabled = false
                            }
                            LocationService.shared.latLongToZip(store: store) { (updatedStore) in
                                FBDatabaseService.shared.addToStoreDatabase(newStore: updatedStore) }
                            return store
                        }
                        onSuccess(unsortedStores)
                        print(data)
                    }
                }
                else {
                    print(error ?? "Generic error")
                }
            }).resume()
        }
    }
    
    func degToRadian( _ deg:Double)->Double {
        return deg * Double.pi/180
    }
    
    func radToDegree(_ rad:Double)->Double {
        return rad * 180 / Double.pi
    }
    
    func distance(lat1:Double, lon1:Double, lat2:Double, lon2:Double, unit:String) -> Double {
        let theta = lon1-lon2
        var dist = sin(degToRadian(lat1)) * sin(degToRadian(lat2)) + cos(degToRadian(lat1)) * cos(degToRadian(lat2)) * cos(degToRadian(theta))
        dist = acos(dist)
        dist = radToDegree(dist)
        dist = dist * 60 * 1.1515
        // Convert to Kilometers
        if unit == "K" {
            dist = dist*1.609344
        }
        // Default is miles
        return dist
    }
    
    func setStores(stores: [Store]) {
        self.stores = stores
    }
    
    // returns store at given index
    func store(at index: Int) -> Store? {
        if( index < stores.count && index >= 0) {
            return stores[index]
        }
        else {
            return nil
        }
    }
    
    func getNumStores() -> Int {
        return stores.count
    }

}
