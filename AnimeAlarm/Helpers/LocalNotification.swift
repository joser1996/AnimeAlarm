//
//  LocalNotification.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 1/2/21.
//

import Foundation
import NotificationCenter

class LocalNotifications {
    
    
    private func createContentFrom(alarm: Alarm) -> UNMutableNotificationContent? {
        //guard let airingDate = alarm.airingDate else {return nil}
        let alarmDate = alarm.alarmDate
        let hour: Int = alarmDate.hour
        let min: Int = alarmDate.min
        let isAM: Bool = alarmDate.am
        
        let minString: String = (min < 10) ? "0\(String(min))" : String(min)
        let amString: String = isAM ? "AM" : "PM"
        
        let title = "Reminder: " + alarm.label
        let body = "Alarm for: \(alarm.label) set at: \(String(hour)):\(minString) \(amString) "
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.categoryIdentifier = "ALARM"
        
        return content
    }
    
    private func getTrigger(using date: AlarmDate) -> UNCalendarNotificationTrigger{
        var hour = date.hour
        if (!date.am) {
            hour = hour + 12
        }
        let min = date.min
        let alarmComponents = DateComponents(hour: hour, minute: min, weekday: date.dayWeek.rawValue)
        let trigger = UNCalendarNotificationTrigger(dateMatching: alarmComponents, repeats: false)
        return trigger
    }
    
    func createNotificationRequestUsingAlarm(alarm: Alarm) {
        //create content
        guard let content = self.createContentFrom(alarm: alarm) else {
            print("Failed to create content")
            return
        }
        //create trigger
        let trigger = self.getTrigger(using: alarm.alarmDate)
        //get notification identifier
        guard let id = alarm.alarmID else {
            print("No alarm ID; Hasn't been written")
            return
        }
        let strID = String(id)
        //create request
        let request = UNNotificationRequest(identifier: strID, content: content, trigger: trigger)
        //schedule request with the system
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { error in
            if(error != nil) {
                //handle any errors here
                print("Error creating notification request: \(String(describing: error?.localizedDescription))")
                alarm.active = false
            }
            //if we didn't fail mark alarm as active
            print("Alarm is now active")
            alarm.active = true
        }
    }
    
    func cancelNotifcationRequestForAlarm(alarm: Alarm) {
        guard let alarmID = alarm.alarmID else {
            print("No Alarm ID")
            return
        }
        let notificationCenter = UNUserNotificationCenter.current()
        let identifier = String(alarmID)
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
        alarm.active = false
    }
}

