//
//  SeasonsPopoverController.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 9/4/21.
//

import Foundation
import UIKit

struct Season {
    let season: String
    let year: Int
    init(season: String, year: Int) {
        self.season = season
        self.year = year
    }
}

class SeasonViewCell: UITableViewCell {
    lazy var seasonLabel: UILabel = {
        let label = UILabel()
        label.text = "Season"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setUpView() {
        addSubview(seasonLabel)
        
        NSLayoutConstraint.activate([
            seasonLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            seasonLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            seasonLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }
}

class SeasonsPopoverController: UITableViewController {
    
    let seasonStrings: [String] = ["SPRING", "SUMMER", "FALL", "WINTER"]
    
    func getSeasons() -> [Season]{
        let monthNumber = Calendar.current.dateComponents([.month], from: Date()).month
        let year = 2021
        print("Current Month: ", monthNumber!)
        var seasons: [Season] = []
        for index in 0...4 {
            seasons.append(Season(season: seasonStrings[index], year: year))
        }
        return seasons
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.register(SeasonViewCell.self, forCellReuseIdentifier: "seasonCell")
        tableView.rowHeight = CGFloat(50)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasonStrings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! SeasonViewCell
        cell.setUpView()
        return cell
    }
}
