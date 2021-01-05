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
        guard let airingDate = alarm.airingDate else {return nil}
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        
        let title = "Reminder: " + alarm.label
        let body = "The next episode of \(alarm.label) starts at \(dateFormatter.string(from: airingDate))"
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        return content
    }
    
    private func getTrigger(using date: Date) -> UNCalendarNotificationTrigger{
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.calendar = Calendar.current
        
        dateComponents.hour = calendar.component(.hour, from: date)
        dateComponents.minute = calendar.component(.minute, from: date)
        dateComponents.month = calendar.component(.month, from: date)
        dateComponents.year = calendar.component(.year, from: date)
        dateComponents.day = calendar.component(.day, from: date)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        return trigger
    }
    
    func createNotificationRequestUsingAlarm(alarm: Alarm) {
        //create content
        guard let content = self.createContentFrom(alarm: alarm) else {
            print("Failed to create content")
            return
        }
        //create trigger
        let trigger = self.getTrigger(using: alarm.alertDate)
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

