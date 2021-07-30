//
//  episodeModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
struct Episodes: Codable {
    let results: [EpisodeRes]
}
struct EpisodeRes: Codable {
    let name, airDate, episode: String
    let characters: [String]

    enum CodingKeys: String, CodingKey {
        case name
        case airDate = "air_date"
        case episode, characters
    }
}
