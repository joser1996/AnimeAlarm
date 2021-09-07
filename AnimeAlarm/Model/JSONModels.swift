//
//  JSONModels.swift
//  AnimeAlarm
//
//  Created by Jose Torres-Vargas on 12/31/20.
//

import Foundation

struct ResponseFormat: Decodable {
    let data: ResponseData
}

struct ResponseData: Decodable {
    let Page: PageData
}

struct PageData: Decodable {
    let pageInfo: PageInfo?
    let media: [MediaItem]
}

struct PageInfo: Decodable {
    let total: Int
    let currentPage: Int
    let lastPage: Int?
    let hasNextPage: Bool
    let perPage: Int
}

struct MediaItem: Decodable {
    let id: Int
    let title: Title
    let airingSchedule: Schedule?
    let nextAiringEpisode: NextAiring?
    let episodes: Int?
    let description: String?
    let coverImage: CoverImage
    let endDate: AnimeDate
    let startDate: AnimeDate
}

struct Schedule: Decodable {
    let pageInfo: PageInfo
    let edges: [Node]
}

struct Node: Decodable {
    let node: NodeData
}

struct NodeData: Decodable {
    let id: Int?
    let airingAt: Double
    let episode: Int
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
