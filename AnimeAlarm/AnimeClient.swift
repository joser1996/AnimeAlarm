//
//  AnimeClient.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/9/20.
//

import Foundation


struct ResponseFormat: Decodable {
    let data: ResponseData
}

struct ResponseData: Decodable {
    let Page: PageData
}

struct PageData: Decodable {
    let pageInfo: PageInfo
    let media: [MediaItem]
}

struct PageInfo: Decodable {
    let total: Int
    let currentPage: Int
    let lastPage: Int
    let hasNextPage: Bool
    let perPage: Int
}

struct MediaItem: Decodable {
    let id: Int
    let title: Title
    let nextAiringEpisode: NextAiring?
    let episodes: Int?
    let description: String?
    let coverImage: CoverImage
    let endDate: AnimeDate
    let startDate: AnimeDate
}

struct Title: Decodable {
    let romaji: String?
    let native: String?
    let english: String?
}

struct NextAiring: Decodable {
    let airingAt: Double
    let episode: Int
}

struct CoverImage: Decodable {
    let extraLarge: String?
    let large: String?
    let medium: String?
}

struct AnimeDate: Decodable {
    let year: Int?
    let month: Int?
    let day: Int?
}

struct AnimeRequest: Codable {
    var query: String
    var variables: [String: Int]
}





class AnimeScheduler {
    
    //MARK: Properties
    var responseItem: ResponseFormat?
    let baseURL: String = "https://graphql.anilist.co"
    let query = """
        query($page: Int, $perPage: Int) {
            Page(page: $page, perPage: $perPage) {
                pageInfo {
                    total
                    currentPage
                    lastPage
                    hasNextPage
                    perPage
                }

                media(season: WINTER, seasonYear: 2021, type: ANIME) {
                    id
                    title {
                        romaji
                        native
                        english
                    }
                    nextAiringEpisode {
                        airingAt
                        episode
                    }
                    episodes
                    description(asHtml: false)
                    coverImage {
                        extraLarge
                        large
                        medium
                    }
                    endDate {
                        year
                        month
                        day
                    }
                    startDate {
                        year
                        month
                        day
                    }
                }
            }
        }
    """
    
    let variables = ["page": 1, "perPage": 100]
    var animeObjs: [MediaItem]?
    
    
    //MARK: Methods
    //returns JSON object that will be request
    func toJSON() -> Data? {
        let animeReq = AnimeRequest(query: self.query, variables: self.variables)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(animeReq)
        return data
    }
    
    //sends request and gets data
    func getAnimeFor(season: String, vc: HomeController) {
        print("Using Data!!!")
        guard let data = toJSON() else {
            print("Couldn't convert request to JSON")
            return
        }
        
        var request = URLRequest(url: URL(string: self.baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.uploadTask(with: request, from: data) { data, respone, error in
            if let error = error {
                print("error: \(error)")
                return
            }
            
            guard let data = data else {
                print("Data: nil")
                return
            }

            do {
                let result = try JSONDecoder().decode(ResponseFormat.self, from: data)
                self.responseItem = result
                //want to build an array of media items
                let mediaArray = result.data.Page.media
                var tempArr: [MediaItem] = []
                var airingDates: [Int: Date] = [:]
                for item in mediaArray {
                    tempArr.append(item)
                    let airingDate = Alarm.airingDay(seconds: item.nextAiringEpisode?.airingAt ?? Double(0))
                    airingDates[item.id] = airingDate
                }
                //saving array of anime objs
                self.animeObjs = tempArr
                vc.animeData = self.animeObjs
                vc.airingDates = airingDates
                DispatchQueue.main.async {
                    vc.collectionView.reloadData()
                }
            } catch {
                print("JSON Error: \(error.localizedDescription)")
            }
        }.resume()
    }
    
}
