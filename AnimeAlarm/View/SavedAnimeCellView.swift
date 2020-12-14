//
//  SavedAnimeCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/12/20.
//

import UIKit

class SavedAnimeViewCell: BaseCellView {
    
    //MARK: Properties
    lazy var thumbNailView: UIImageView = {
        let tn = UIImageView()
        //DELETE THIS
        //tn.backgroundColor = .blue
        tn.translatesAutoresizingMaskIntoConstraints = false
        
        //set image here for now(dummy)
        tn.image = UIImage(named: "danmachi")
        tn.contentMode = .scaleAspectFill
        tn.clipsToBounds = true
        return tn
    }()
    
    override func setUpViews() {
        super.setUpViews()
        addSubview(thumbNailView)
        
        //MARK: Constraints
        NSLayoutConstraint.activate([
            thumbNailView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            thumbNailView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4),
            thumbNailView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            thumbNailView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
    }
}