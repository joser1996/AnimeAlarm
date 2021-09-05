//
//  Seasons.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 9/4/21.
//

import Foundation

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

 
class SeasonsHelper {
    let seasonStrings: [String] = ["WINTER", "SPRING", "SUMMER", "FALL"]
    var seasons: [Season]?
    var currentSeason: Season?
    
    static let shared = SeasonsHelper()
    
    private init() {
        self.seasons = getSeasons()
        self.currentSeason = getCurrentSeason()
    }
    
    private func getSeasons() -> [Season]{
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

}


