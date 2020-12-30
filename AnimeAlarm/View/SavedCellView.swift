//
//  SavedCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/16/20.
//

import UIKit

class SavedCellView: BaseCellView {
    let savedAnimeView = SavedAnimeView()
    var animeData: [MediaItem]? {
        didSet {
            savedAnimeView.animeData = animeData
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override func setUpViews() {
        addSubview(savedAnimeView)
        savedAnimeView.translatesAutoresizingMaskIntoConstraints = false
        //MARK: Constraints
        NSLayoutConstraint.activate([
            savedAnimeView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            savedAnimeView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            savedAnimeView.topAnchor.constraint(equalTo: self.topAnchor),
            savedAnimeView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
    }
}
