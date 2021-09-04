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

enum Months: Int {
     case January = 1
     case February
     case March
     case April
     case May
     case June
     case July
     case August
     case September
     case October
     case November
     case December
}

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



class SeasonsPopoverController: UITableViewController {
    
    let seasonStrings: [String] = ["WINTER", "SPRING", "SUMMER", "FALL"]
    var seasons: [Season]?
    
    func getSeasons() -> [Season]{
        let currentSeason: Season? = getCurrentSeason()
        var currentYear: Int = currentSeason!.year
        
        var seasonIndex:Int
        switch currentSeason!.season {
        case "WINTER":
            seasonIndex = 0
        case "SPRING":
            seasonIndex = 1
        case "SUMMER":
            seasonIndex = 2
        case "FALL":
            seasonIndex = 3
        default:
            seasonIndex = 0
        }
        
        var seasons: [Season] = []
        for _ in 1...4 {
            seasons.append(Season(season: seasonStrings[seasonIndex], year: currentYear))
            seasonIndex += 1
            if seasonIndex > 3 {
                seasonIndex = 0
                currentYear += 1
            }
        }
        return seasons
    }
    
    private func getCurrentSeason() -> Season? {
        guard let monthNumber = Calendar.current.dateComponents([.month], from: Date()).month else {return nil}
        guard let currentYear = Calendar.current.dateComponents([.year], from: Date()).year else {return nil}
        print("Current Season: \(monthNumber)-\(currentYear)")
        
        if monthNumber >= Months.January.rawValue && monthNumber <= Months.March.rawValue {
            //Winter
            return Season(season: "WINTER", year: currentYear)
        } else if monthNumber >= Months.April.rawValue && monthNumber <= Months.June.rawValue {
            //Spring
            return Season(season: "SPRING", year: currentYear)
        } else if monthNumber >= Months.July.rawValue && monthNumber <= Months.September.rawValue {
            //Summer
            return Season(season: "SUMMER", year: currentYear)
        } else if monthNumber >= Months.October.rawValue && monthNumber <= Months.December.rawValue {
            //Fall
            return Season(season: "FALL", year: currentYear)
        }
        return Season(season: "FALL", year: currentYear)
    }
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.register(SeasonViewCell.self, forCellReuseIdentifier: "seasonCell")
        tableView.rowHeight = CGFloat(50)
        self.seasons = getSeasons()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.seasonStrings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "seasonCell", for: indexPath) as! SeasonViewCell
        cell.setUpView(season: self.seasons?[indexPath.row])
        return cell
    }
}
