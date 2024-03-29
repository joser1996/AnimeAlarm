//
//  Queries.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/31/20.
//

import Foundation

struct Query {
    let request: String
    let variables: [String: Int]
}
 
struct QueryHelper {

    private func airingHelper(season: Season) -> String {
        let str = """
            query ($page: Int, $perPage: Int) {
                Page (page: $page, perPage: $perPage) {
                    media (season: \(season.season), seasonYear: \(season.year), type: ANIME) {
                        id
                        title {
                            romaji
                        }
                        airingSchedule(notYetAired: false, page: 1, perPage: 25) {
                            pageInfo {
                                total
                                currentPage
                                perPage
                                hasNextPage
                            }
        
                            edges {
                                node {
                                    id
                                    airingAt
                                    episode
                                }
                            }
                        }
                    }
                }
            }
            
        """
        return str
    }
    
    func airingScheduleQuery(season: Season) -> Query {
        let queryStr:String = airingHelper(season: season)
        let vars: [String: Int] = ["page": 1, "perPage": 50 ]
        return Query(request: queryStr, variables: vars)
    }
    
    
    
    func buildQueryString(season: String, year: String) -> String {
        var str = """
            query($page: Int, $perPage: Int) {
                Page(page: $page, perPage: $perPage) {
                    pageInfo {
                        total
                        currentPage
                        lastPage
                        hasNextPage
                        perPage
                    }
            """
        str = str + "media(season: \(season), seasonYear: \(year), type: ANIME) {"
        
        str = str + """
                                id
                                title {
                                    romaji
                                    native
                                    english
                                }
                
                                airingSchedule (notYetAired: false, page: 1, perPage: 25) {
                                    pageInfo {
                                        total
                                        currentPage
                                        lastPage
                                        hasNextPage
                                        perPage
                                    }
                
                                    edges {
                                        node {
                                            id
                                            airingAt
                                            episode
                                        }
                                    }
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
        //print("Built String: ", str)
        return str
    }
    
    
    var mainQueryString = """
        query($page: Int, $perPage: Int) {
            Page(page: $page, perPage: $perPage) {
                pageInfo {
                    total
                    currentPage
                    lastPage
                    hasNextPage
                    perPage
                }

                media(season: SUMMER, seasonYear: 2021, type: ANIME) {
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
    
    var variables = ["page": 1, "perPage": 50]
    
    func getQueryObj(currentPage: Int, season: Season) -> Query{
        let vars = ["page": currentPage, "perPage": 50]
        
        return Query(request: buildQueryString(season: season.season, year: String(season.year)), variables: vars)
    }
}
