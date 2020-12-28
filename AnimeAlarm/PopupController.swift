//
//  PopupController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/22/20.
//

import UIKit

class PopupController: UIViewController {
    
    private let popupView = CreateAlarmView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPopUpView()
    }
    
    private func setUpPopUpView() {
        popupView.saveButton.addTarget(self, action: #selector(saveAction), for: .touchUpInside)
        popupView.defautlButton.addTarget(self, action: #selector(defaultAction), for: .touchUpInside)
        popupView.cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        popupView.textField.setUpDatePicker(target: self, selector: #selector(doneAction))
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
    @objc private func doneAction() {
        if let datePicker = self.popupView.textField.inputView as? UIDatePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .short
            //print("Date: \(dateFormatter.string(from: datePicker.date))")
            self.popupView.textField.text = dateFormatter.string(from: datePicker.date)
        }
        self.popupView.textField.resignFirstResponder()
    }
    
    @objc private func saveAction() {
        print("Save action!")
        dismissView()
    }
    
    @objc private func defaultAction() {
        print("Default Action!")
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
    func setUpDatePicker(target: Any, selector: Selector) {
        //create datepicker obj
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 215))
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        //for ios14
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.sizeToFit()
        }
        self.inputView = datePicker
        //create a toolbar
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        //createbuttons
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        
        //assign buttons to toolbar
        toolBar.setItems([cancelButton, flexSpace, doneButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
}
