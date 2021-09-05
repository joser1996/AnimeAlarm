//
//  SeasonViewCell.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 9/4/21.
//

import Foundation
import UIKit

class SeasonViewCell: UITableViewCell {
    lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.text = "Season"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var yearLabel: UILabel = {
       let label = UILabel()
        label.text = "Year"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpView(season: Season?) {
        addSubview(seasonLabel)
        addSubview(yearLabel)
        
        NSLayoutConstraint.activate([
            seasonLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            seasonLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            seasonLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            // label for year
            yearLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -140),
            yearLabel.topAnchor.constraint(equalTo: seasonLabel.topAnchor),
            yearLabel.bottomAnchor.constraint(equalTo: seasonLabel.bottomAnchor)
        ])
        
        if let season = season {
            seasonLabel.text = season.season
            yearLabel.text = String(season.year)
        }
       
        
    }
}
