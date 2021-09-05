//
//  AnimeClient.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/9/20.
//

import Foundation

class AnimeClient {
    //MARK: Properties
    //Singleton
    static let shared = AnimeClient()
    let queryHelper = QueryHelper()
    
    var responseItem: ResponseFormat?
    let baseURL: String = "https://graphql.anilist.co"
    var animeData: [MediaItem]? = []
    var animeDataIndex: [Int: Int]? = [:]
    var airingToday: [MediaItem]? = []
    var todaysDate: Date
    
    //MARK: Methods
    private init() {
        print("Do Nothing")
        //get todays date
        self.todaysDate = Date()
    }
     
    //returns JSON object that will be request
    func createJSON(currentPage: Int, season: Season) -> Data? {
        let query = queryHelper.getQueryObj(currentPage: currentPage, season: season)
        let animeReq = AnimeRequest(query: query.request, variables: query.variables)
        let encoder = JSONEncoder()
        let dataJSON = try? encoder.encode(animeReq)
        return dataJSON
    }
    
    //sends request and gets data
    func getAnimeFor(season: Season, vc: HomeController, currentPage: Int) {
        guard let data = createJSON(currentPage: currentPage, season: season) else { return }
        
        //creating post request
        var request = URLRequest(url: URL(string: self.baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //sending request
        URLSession.shared.uploadTask(with: request, from: data) { data, respone, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Data: nil")
                return
            }

            do {
                let result = try JSONDecoder().decode(ResponseFormat.self, from: data)
                let mediaArray = result.data.Page.media
                let notDone: Bool = result.data.Page.pageInfo.hasNextPage
                print("notDone:  \(notDone)")
                
                for (index, item) in mediaArray.enumerated() {
                    self.animeData?.append(item)
                    self.animeDataIndex?[item.id] = index
                }
                if notDone {
                    self.getAnimeFor(season: season, vc: vc, currentPage: currentPage + 1)
                } else {
                    DispatchQueue.main.async {
                        vc.collectionView.reloadData()
                    }
                }
            } catch {
                print("JSON Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func getAnimeData(forID: Int) -> MediaItem? {
        guard let animeDataIndex = self.animeDataIndex else { return nil }
        guard let animeData = self.animeData else { return nil }
        if let index = animeDataIndex[forID] {
            return animeData[index]
        }
        return nil
    }
    
    func buildAiringToday(currentDate: Date) {
        guard let animeData = self.animeData else {return}
        let calander = Calendar.current
        let today = calander.component(.day, from: currentDate)
        for item in animeData {
            if let airingAt = item.nextAiringEpisode?.airingAt {
                let airingDate = Alarm.airingDay(seconds: airingAt)
                let airingDay = calander.component(.day, from: airingDate)
                if airingDay == today {
                    self.airingToday?.append(item)
                }
            }
        }
    }
    
    
    
}
