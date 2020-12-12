//
//  RowCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/11/20.
//

import UIKit

class RowCellView: BaseCellView {
    
    //MARK: Properties
    lazy var titleView: UILabel = {
        let tv = UILabel(frame: .zero)
        //DELETE
        tv.backgroundColor = .yellow
        tv.textColor = .black

        tv.text = "This is an Anime Title"
        tv.font = .systemFont(ofSize: 25)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    //MARK: Methods
    override func setUpViews() {
        //adding titleview to my RowCellView
        addSubview(titleView)
        
        //MARK: Constraints
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(lessThanOrEqualTo: self.leadingAnchor, constant: 8),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
}

