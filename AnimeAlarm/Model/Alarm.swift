//
//  Alarm.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/14/20.
//

import Foundation
import GRDB


class Alarm{
    
    //MARK: Properties
    var alarmDate: AlarmDate
    var label: String
    var animeID: Int
    var active: Bool
    
    //set after db read
    var alarmID: Int?
    //MARK: Initializer
    init(on date: AlarmDate, for label: String, with id: Int, isActive: Bool) {
        self.alarmDate = date
        self.label = label
        self.animeID = id
        self.active = isActive
    }
    
    static func airingDay(seconds until: Double) -> (Date) {
        let timeZoneOffset = TimeZone.current.secondsFromGMT()
        let timeZoneEpochOffset = (until + Double(timeZoneOffset))
        let airingDate = Date(timeIntervalSince1970: timeZoneEpochOffset)
        //print("Airing Date: \(airingDate)")
        return airingDate
    }
}
