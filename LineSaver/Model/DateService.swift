//
//  DateService.swift
//  LineSaver
//
//  Created by Cat  on 5/6/20.
//  Copyright © 2020 Cat . All rights reserved.
//

import Foundation

class DateService: NSObject {
    // Swift Singleton pattern
    static let shared = DateService()
    
    let userCalendar = Calendar.current
    
    let dateFormatter = DateFormatter()
    
    override init() {
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
    }
    
    func getDateFromDateComponents(year: Int, month: Int, day: Int, hour:Int, minute:Int) -> Date? {
        var myDateComponents = DateComponents()
        myDateComponents.year = year
        myDateComponents.month = month
        myDateComponents.day = day
        myDateComponents.hour = hour
        myDateComponents.minute = minute
        return userCalendar.date(from: myDateComponents)
    }
    
    func getDateFromUnixTimestamp(date:Double) -> Date? {
        return Date(timeIntervalSince1970: date)
    }
    
    func getFirebaseStringFromDate(date:Date)-> String{
        return String(date.timeIntervalSince1970)
    }
    
    func getReadableStringFromDate(date:Date) -> String{
        return dateFormatter.string(from: date)
    }
}
