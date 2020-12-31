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
    var animeData: [MediaItem]?
    var animeDataIndex: [Int: Int]?
    
    //MARK: Methods
    private init() {
        print("Do Nothing")
    }
    
    //returns JSON object that will be request
    func createJSON() -> Data? {
        let query = queryHelper.getQueryObj()
        let animeReq = AnimeRequest(query: query.request, variables: query.variables)
        let encoder = JSONEncoder()
        let dataJSON = try? encoder.encode(animeReq)
        return dataJSON
    }
    
    //sends request and gets data
    func getAnimeFor(season: String, vc: HomeController) {
        guard let data = createJSON() else { return }
        
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
                var tempArr: [MediaItem] = []
                var tempIndex: [Int: Int] = [:]
                for (index, item) in mediaArray.enumerated() {
                    tempArr.append(item)
                    tempIndex[item.id] = index
                }
                //saving array of anime objs
                self.animeData = tempArr
                self.animeDataIndex = tempIndex
                DispatchQueue.main.async {
                    vc.collectionView.reloadData()
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
    
}
