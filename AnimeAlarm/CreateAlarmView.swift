//
//  CreateAlarmView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/22/20.
//
import UIKit

class CreateAlarmView: UIView {
    
    //title
    let title: UILabel = {
        let title = UILabel()
        title.text = "Set alarm date and time"
        title.font = .systemFont(ofSize: 25)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    //textfield
    let textField: TextFieldWithPadding = {
        let tf = TextFieldWithPadding()
        tf.layer.borderColor = #colorLiteral(red: 0.2935330146, green: 0.2960240472, blue: 0.2658583929, alpha: 1)
        tf.layer.borderWidth = 1.0
        tf.layer.cornerRadius = 10
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layoutMargins.left = 15
        tf.placeholder = "Default: 30 mins before airing time"
        return tf
    }()

    //save
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = #colorLiteral(red: 0.2935330146, green: 0.2960240472, blue: 0.2658583929, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        return button
    }()
    //cancel button
    let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = #colorLiteral(red: 0.2935330146, green: 0.2960240472, blue: 0.2658583929, alpha: 1)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setUpViews() {
        self.addSubview(title)
        self.addSubview(textField)
        self.addSubview(saveButton)
        self.addSubview(cancelButton)
        
        //MARK: Constraints
        //title
        NSLayoutConstraint.activate([
            title.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 16)
        ])
        //textfield
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])
        //saveButton
        NSLayoutConstraint.activate([
            saveButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            saveButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            saveButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        //saveButton
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            cancelButton.topAnchor.constraint(equalTo: saveButton.bottomAnchor, constant: 8),
            cancelButton.widthAnchor.constraint(equalToConstant: 100)

        ])
    }
}


class TextFieldWithPadding: UITextField {
    var textPadding = UIEdgeInsets(
        top: 10,
        left: 20,
        bottom: 10,
        right: 20
    )

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
