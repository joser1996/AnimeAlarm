//
//  AlarmManager.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/17/20.
//

import Foundation

//going to use sqlite to store data
//table alarms [anime_id, Date, "Label"] date might have to be broken up
class AlarmManager {
    
    var alarms: [Int: Alarm]
    
    init() {
        //load alarms if any exist
        
        //otherwise create a new dictionary
        self.alarms = [:]
    }
    
    private func loadAlarms() {
        
    }
    
    func addAlarm(for anime: MediaItem) {
        let nextEp = anime.nextAiringEpisode?.airingAt ?? 0 //if next airing not available ask user to specify time
        let airingDate = Alarm.airingDay(seconds: nextEp)
        let title = anime.title.romaji ?? "No Title"
        let alarm: Alarm = Alarm(on: airingDate, for: title)
        self.alarms[anime.id] = alarm
    }
    
    func removeAlarm(for id: Int) {
        if self.alarms.removeValue(forKey: id) != nil {
            print("Alarm for id \(id) was removed")
        }
    }
    
    func printAlarms() {
        for (_, alarm) in self.alarms {
            print("Label: \(alarm.label)")
            print("Date: \(alarm.alertDate)")
        }
    }
    
    func loadAlarms() -> [Int: Alarm] {
        
        return [:]
    }
    
    func writeAlarms() {
        
    }
}
