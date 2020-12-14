//
//  AnimeInfoView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/12/20.
//

import UIKit

class AnimeInfoView: UIView {

    //MARK: Properties
    lazy var titleView: UILabel = {
        let tv = UILabel()
        tv.text = "Generic Title"
        tv.adjustsFontSizeToFitWidth = true
        tv.textAlignment = .center
        //DELETE
        //tv.backgroundColor = .red
        tv.font = .systemFont(ofSize: 35)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var thumbNail: UIImageView = {
       let tn = UIImageView()
        //set image here for now(dummy)
        tn.image = UIImage(named: "danmachi")
        tn.contentMode = .scaleAspectFill
        tn.clipsToBounds = true
        tn.translatesAutoresizingMaskIntoConstraints = false
        return tn
    }()
    
    lazy var synopsis: UITextView = {
        let syn = UITextView()
        let generic = """
        This is a very generic piece of text that is meant to be used as a placeholder for the actual text. I Wonder
        how much of this stuff I'm supposed to write. Okay I'm starting to run out of things to type so I must
        resort to my ultimate move. Behold the power of copy and paste........ wait for it..... here it comes!
        Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah
        Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah Blah
        """
        syn.text = generic
        syn.font = .systemFont(ofSize: 25)
        syn.translatesAutoresizingMaskIntoConstraints = false
        syn.isSelectable = false
        //DELETE
        //syn.backgroundColor = .cyan

        return syn
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Remind Me!", for: .normal)
        button.backgroundColor = .lightGray
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = .systemFont(ofSize: 25)
        return button
    }()
    
    //MARK: Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleView)
        addSubview(thumbNail)
        addSubview(synopsis)
        addSubview(saveButton)

        
        //MARK: Constraints
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            thumbNail.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 16),
            thumbNail.widthAnchor.constraint(equalToConstant: 180),
            thumbNail.heightAnchor.constraint(equalToConstant: 250),
            thumbNail.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            synopsis.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            synopsis.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            synopsis.topAnchor.constraint(equalTo: thumbNail.bottomAnchor, constant: 16),
            synopsis.heightAnchor.constraint(equalToConstant: 300)
        ])
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: synopsis.bottomAnchor, constant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 200),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.centerXAnchor.constraint(equalTo: synopsis.centerXAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
