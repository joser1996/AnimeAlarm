//
//  CustomPickerView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/23/21.
//

import Foundation
import UIKit
import GRDB
enum Day: Int, CustomStringConvertible {
    case Sunday = 1
    case Monday = 2
    case Tuesday = 3
    case Wednesday = 4
    case Thursday = 5
    case Friday = 6
    case Saturday = 7
    
    
    var description: String {
        switch self {
        case .Monday: return "Monday"
        case .Tuesday: return "Tuesday"
        case .Wednesday: return "Wednesday"
        case .Thursday: return "Thursday"
        case .Friday: return "Friday"
        case .Saturday: return "Saturday"
        case .Sunday: return "Sunday"
        }
    }
}

struct AlarmDate {
    let dayWeek: Day
    let hour: Int
    let min: Int
    let am: Bool
}

extension AlarmDate: Comparable, CustomStringConvertible {
    static func < (lhs: AlarmDate, rhs: AlarmDate) -> Bool {
        let lHour = lhs.am ? lhs.hour : lhs.hour + 12
        let rHour = rhs.am ? rhs.hour : rhs.hour + 12
        if lhs.dayWeek != lhs.dayWeek {
            return lhs.dayWeek.rawValue < rhs.dayWeek.rawValue
        } else if (lHour != rHour) {
            return lHour < rHour
        } else {
            return lhs.min < rhs.min
        }
    }
    
    var description: String {
        let hourStr = String(self.hour)
        let minStr = self.min < 10 ? "0\(String(self.min))": String(self.min)
        let amStr = self.am ? "AM" : "PM"
        let str: String = "\(self.dayWeek)@ \(hourStr):\(minStr) \(amStr)"
        return str
    }
    
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
    
    //MARK: Style Stuff
    var selectedTextColor: UIColor?
    var textColor: UIColor?
    var selectedFont: UIFont?
    var textFont: UIFont?
    
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
        self.selectedTextColor = .blue
        self.textColor = .black
        self.selectedFont = .boldSystemFont(ofSize: 17)
        self.textFont = .boldSystemFont(ofSize: 17)
    }
    
    func labelForComponent(component: NSInteger) -> UILabel {
        let frame = CGRect(x: 0.0, y: 0.0, width: bounds.size.width, height: CGFloat(rowHeight))
        let label = UILabel(frame: frame)
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.isUserInteractionEnabled = false
        return label
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
            let min = Int(minutes[row]) ?? 10
            title = min < 10 ? "0\(minutes[row])" : minutes[row]
        } else {
            title = ampm[row]
        }
        
        let returnView: UILabel = labelForComponent(component: component)
        returnView.text = title
        returnView.font = self.textFont
        
        return returnView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return CGFloat(rowHeight)
    }
    
}
