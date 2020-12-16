//
//  SavedCellView.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/16/20.
//

import UIKit

class SavedCellView: BaseCellView {
    let savedAnimeView = SavedAnimeView()
    
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
