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
        //tv.backgroundColor = .yellow
        //tv.textColor = .black

        tv.text = "This is an Anime Title"
        tv.font = .systemFont(ofSize: 25)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    lazy var seperatorView: UIView = {
        let sv = UIView()
        sv.backgroundColor = .black
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    
    //MARK: Methods
    override func setUpViews() {
        //adding titleview to my RowCellView
        addSubview(titleView)
        addSubview(seperatorView)
        
        //MARK: Constraints
        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            titleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            titleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
            titleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
        
        NSLayoutConstraint.activate([
            seperatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            seperatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            seperatorView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    override var isSelected: Bool {
        didSet {
            
        }
    }
}

