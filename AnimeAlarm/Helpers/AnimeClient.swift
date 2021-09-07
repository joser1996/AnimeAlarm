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
     
    func clearData() {
        self.animeData = []
        self.animeDataIndex = [:]
    }
    
    //returns JSON object that will be request
    func createJSON(currentPage: Int, season: Season) -> Data? {
        let query = queryHelper.getQueryObj(currentPage: currentPage, season: season)
        let animeReq = AnimeRequest(query: query.request, variables: query.variables)
        let encoder = JSONEncoder()
        let dataJSON = try? encoder.encode(animeReq)
        return dataJSON
    }
    
    func getAnimeAiringSchedule(season: Season) {
        let query = queryHelper.airingScheduleQuery(season: season)
        let animeRequest = AnimeRequest(query: query.request, variables: query.variables)
        let encoder = JSONEncoder()
        guard let dataJSON = try? encoder.encode(animeRequest) else {return}
        
        var request = URLRequest(url: URL(string: self.baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.uploadTask(with: request, from: dataJSON) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Data is nil")
                return
            }
            
            do {
                let responseData = String(data: data, encoding: String.Encoding.utf8)
                print("Raw: ", responseData)
                
                
                let result = try JSONDecoder().decode(ResponseFormat.self, from: data)
                print("Result: ", result)
            } catch {
                print("Something went wrong.")
                print(error)
            }
        }.resume()
        
    }
    
    //sends request and gets data
    func getAnimeFor(season: Season, currentPage: Int, completionBlock: @escaping ([MediaItem]?) -> Void) {
        guard let data = createJSON(currentPage: currentPage, season: season) else { return }
        var request = URLRequest(url: URL(string: self.baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                let notDone: Bool = result.data.Page.pageInfo!.hasNextPage
                //Saving Anime Data to class
                for (index, item) in mediaArray.enumerated() {
                    print("Name: ", item.title.romaji)
                    if let edges = item.airingSchedule?.edges {
                        print("Schedule: ")
                        for node in edges {
                            print("Episode: \(node.node.episode) Airing at: ", node.node.airingAt)
                            
                        }
                    }
                    self.animeData?.append(item)
                    self.animeDataIndex?[item.id] = index
                }
                if notDone {
                    //continue
                    self.getAnimeFor(season: season, currentPage: currentPage + 1) { data in
                        completionBlock(data)
                    }
                } else {
                    completionBlock(self.animeData)
                }
            } catch {
                print("TEST: ", error)
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
