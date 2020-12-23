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
