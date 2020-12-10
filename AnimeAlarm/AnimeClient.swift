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
}

struct Title: Decodable {
    let romaji: String?
    let native: String?
    let english: String?
}

struct NextAiring: Decodable {
    let airingAt: Int
    let episode: Int
}

struct AnimeRequest: Codable {
    var query: String
    var variables: [String: Int]
}

class AnimeScheduler {
    var responseItem: ResponseFormat? = nil
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
                }
            }
        }
    """
    
    let variables = ["page": 1, "perPage": 100]

    func toJSON() -> Data? {
        let animeReq = AnimeRequest(query: self.query, variables: self.variables)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try? encoder.encode(animeReq)
        return data
    }
    
    func getAnimeFor(season: String) -> ResponseFormat? {
        guard let data = toJSON() else {
            print("Couldn't convert request to JSON")
            return nil
        }
        let url = URL(string: self.baseURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        var done = false
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, respone, error in
            print("Task: ")
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
                //print("Media List: \n", result.data.Page.media)
                done = true
            } catch {
                print("JSON Error: \(error.localizedDescription)")
                done = true
            }
        }
        task.resume()
        repeat {
            print("Waiting")
        } while !done
        return self.responseItem
    }
    
}
