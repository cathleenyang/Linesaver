//
//  ReservationsModel.swift
//  
//
//  Created by Cat  on 5/6/20.
//

import Foundation

class ReservationsModel:NSObject {
    
    var reservations = [Reservation]()
    
    override init() {
        super.init()
    }
    
    // Swift Singleton pattern
    static let shared = ReservationsModel()
    
    func getReservations(onSuccess: @escaping ([Reservation]) -> Void) {
        FBDatabaseService.shared.getReservations(uniqueID: FBAuthService.shared.getCurrentUniqueID()) { (userReservations) in
            onSuccess(userReservations)
        }
    }
    
    // returns reservation at given index
    func reservation(at index: Int) -> Reservation? {
        if( index < reservations.count && index >= 0) {
            return reservations[index]
        }
        else {
            return nil
        }
    }
    
    // sets the entire reservations array
    func setReservations(reservations: [Reservation]) {
        self.reservations = reservations
    }
    
    // returns the number of reservations
    func getNumReservations() -> Int {
        return reservations.count
    }
}
