//
//  PopupController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/22/20.
//

import UIKit
 
class PopupController: UIViewController {
    
    //MARK: Properties
    private let popupView = CreateAlarmView()
    var selectedDate: AlarmDate?
    var animeData: MediaItem?
    var newSelectedDate: AlarmDate?
    
    
    //MARK: Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPopUpView()
    }
    
    private func setUpPopUpView() {
        popupView.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        popupView.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        popupView.textField.setUpNewDatePicker(target: self, selector: #selector(doneAction))
        view.addSubview(popupView)

        popupView.backgroundColor = .systemGroupedBackground
        popupView.layer.cornerRadius = 10
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            popupView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            popupView.widthAnchor.constraint(equalToConstant: self.view.frame.width - 50),
            popupView.heightAnchor.constraint(equalToConstant: 275)
        ])
        
    }
    //set the selected date
    @objc private func doneAction() {
        if let datePicker = self.popupView.textField.inputView as? CustomDatePickerView {
            let alarmDate: AlarmDate = datePicker.date
            self.popupView.textField.text = String(describing: alarmDate)
            self.selectedDate = alarmDate
        }
        self.popupView.textField.resignFirstResponder()
    }
    
    @objc private func saveAction() {
        guard let animeData = self.animeData else {
            print("No Data Passed")
            return
        }
        guard let label = animeData.title.romaji else {return}
        
        if let selectedDate = self.selectedDate {
            let alarm = Alarm(on: selectedDate, for: label, with: animeData.id, isActive: false)
            //writing alarm sets the alarm.alarmID property
            DBClient.shared.writeAlarm(alarm: alarm)
            
            let localNotifications = LocalNotifications()
            localNotifications.createNotificationRequestUsingAlarm(alarm: alarm)
            
        }
        
        dismissView()
    }
    

    @objc private func cancelAction() {
        print("Cancel Action")
        dismissView()
    }
    
    private func dismissView() {
        self.dismiss(animated: true, completion: nil)
    }
}

 

extension UITextField {
    
    
    func setUpNewDatePicker(target: Any, selector: Selector) {
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = CustomDatePickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 215))
        
        self.inputView = datePicker
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
