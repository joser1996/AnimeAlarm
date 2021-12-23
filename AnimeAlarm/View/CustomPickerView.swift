//
//  CustomPickerView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/23/21.
//

//TODO: Set behavior for when selected
//TODO: Set to start at current day and time

import Foundation
import UIKit
enum Day: Int {
    case Monday = 0
    case Tuesday = 1
    case Wednesday = 2
    case Thursday = 3
    case Friday = 4
    case Saturday = 5
    case Sunday = 6
}
struct AlarmDate {
    let dayWeek: Day
    let hour: Int
    let min: Int
    let am: Bool
}

class CustomDatePickerView: UIPickerView {
    enum Component: Int {
        case Day = 0
        case Hour = 1
        case Minute = 2
        case AMPM = 3
    }
    
    let numberOfComponentsRequired = 4
    //Components and options
    let days = ["Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat.", "Sun."]
    var hours: [String] = []
    var minutes:[String] = []
    let ampm = ["AM", "PM"]
    let rowHeight: NSInteger = 44

    //Will be returned in user's current TimeZone setting
    var date: AlarmDate {
        get {
            //Get selectetd day
            let selectedDay = self.days[selectedRow(inComponent: Component.Day.rawValue)]
            let day = getDay(forString: selectedDay)
            let hour  = self.hours[selectedRow(inComponent: Component.Hour.rawValue)]
            let min = self.minutes[selectedRow(inComponent: Component.Minute.rawValue)]
            let am = self.ampm[selectedRow(inComponent: Component.AMPM.rawValue)]
            return AlarmDate(dayWeek: day, hour: Int(hour)!, min: Int(min)!, am: (am == "AM"))
        }
    }
    
    func getDay(forString day: String) -> Day{
        switch day {
        case "Mon.":
            return Day.Monday
        case "Tue.":
            return Day.Tuesday
        case "Wed.":
            return Day.Wednesday
        case "Thu.":
            return Day.Thursday
        case "Fri.":
            return Day.Friday
        case "Sat.":
            return Day.Saturday
        case "Sun.":
            return Day.Sunday
        default:
            return Day.Sunday
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        for index in 1...12 {
            hours.append(String(index))
        }
        for index in 0...60 {
            minutes.append(String(index))
        }
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        self.delegate = self
        self.dataSource = self
    }
    
    
}

extension CustomDatePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return numberOfComponentsRequired
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (component == Component.Day.rawValue) {
            return days.count
        } else if (component == Component.Hour.rawValue) {
            return hours.count
        } else if (component == Component.Minute.rawValue) {
            return minutes.count
        } else if (component == Component.AMPM.rawValue) {
            return ampm.count
        } else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.bounds.size.width / CGFloat(numberOfComponentsRequired)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var title: String
        if (component == Component.Day.rawValue) {
            title = days[row]
        } else if (component == Component.Hour.rawValue) {
            title = hours[row]
        } else if (component == Component.Minute.rawValue) {
            title = minutes[row]
        } else {
            title = ampm[row]
        }
        
        let returnView: UILabel = UILabel()
        returnView.text = title
        
        return returnView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
}
