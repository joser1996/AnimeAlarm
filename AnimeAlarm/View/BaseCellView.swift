//
//  BaseCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/11/20.
//

import UIKit


class BaseCellView: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    func setUpViews() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
