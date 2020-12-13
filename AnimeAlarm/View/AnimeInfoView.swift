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
    
    //MARK: Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleView)
        addSubview(thumbNail)
        
        //MARK: Constraints
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            thumbNail.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 15),
            thumbNail.widthAnchor.constraint(equalToConstant: 180),
            thumbNail.heightAnchor.constraint(equalToConstant: 250),
            thumbNail.centerXAnchor.constraint(equalTo: titleView.centerXAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
