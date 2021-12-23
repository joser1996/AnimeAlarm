//
//  CustomPickerView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/23/21.
//

import Foundation
import UIKit

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
