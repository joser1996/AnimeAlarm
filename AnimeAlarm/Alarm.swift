//
//  Alarm.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/14/20.
//

import Foundation

//
//struct DateObj {
//    let month: Int
//    let day: Int
//    let year: Int
//    let time: TimeObj
//}
//
//struct TimeObj {
//    let hour: Int
//    let min: Int
//}

class Alarm {
    
    //init(for date: DateObj)
    //MARK: Properties
    var alertDate: Date
    var label: String
    
    //MARK: Initializer
    init(on date: Date, for label: String) {
        self.alertDate = date
        self.label = label
    }
    
    //MARK: Methods
    
    private func setalarmfor(date: Date) {
        print("Setting alarm for: \(date)")
    }
    
    //Returns date for when next episode airs in local timezone terms
    static func airingDay(seconds until: Double) -> (Date) {
        let timeZoneOffset = TimeZone.current.secondsFromGMT()
        let timeZoneEpochOffset = (until + Double(timeZoneOffset))
        let airingDate = Date(timeIntervalSince1970: timeZoneEpochOffset)
        //print("Airing Date: \(airingDate)")
        return airingDate
    }
    
    // howLong()
}
