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
    
    // dictionary key is media id and [Node] has schedule data
    var airingSchedule: [Int: [Node]]
    var todaysDate: Date
    
    //MARK: Methods
    private init() {
        print("Do Nothing")
        //get todays date
        self.todaysDate = Date()
        airingSchedule = [:]
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
    
    func buildAiringSchedule() {
        guard let animeData = self.animeData else { return }
        for item in animeData {
            var nodes: [Node] = []
            if let edges = item.airingSchedule?.edges {
                for node in edges {
                    nodes.append(node)
                }
            }
            self.airingSchedule[item.id] = nodes
        }
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
    

    func buildAiringToday() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        print("TODAY: \(dateFormatter.string(from: Date()))")
        let todayString = dateFormatter.string(from: Date())
        for (key, nodes) in self.airingSchedule {
            guard let table = animeDataIndex else {
                print("NO INDEX")
                return
            }
            
            guard let index = table[key] else {
                print ("WAS NOT ABLE TO FIND INDEX")
                return
            }
            guard let animeData = self.animeData else {
                print("NO ANIME DATA")
                return
            }
            let mediaItem = animeData[index]
            //print("PROCESSING TITLE: \(mediaItem.title.romaji ?? "NO TITLE")")
            for node in nodes {
                let airingDate = Alarm.airingDay(seconds: node.node.airingAt)
                let airingString = dateFormatter.string(from: airingDate)
                if airingString == todayString {
                    print(" \(mediaItem.title.romaji ?? "N/A") episode: \(node.node.episode) is airing today")
                    self.airingToday?.append(mediaItem)
                }
            }
        }
    }
    
    
    
}
