//
//  Constants.swift
//  rickMorty
//
//  Created by Alexandre on 19.07.21.
//

import Foundation
struct Constants {
    struct Urls {
        static func urlForChar(ids: [Int]) -> URL? {
            let idsList = ids.map{String($0)}.joined(separator: ",")
            return URL(string: "https://rickandmortyapi.com/api/character/\(idsList)")
        }
        static func urlForEpisodes() -> URL? {
            return URL(string: "https://rickandmortyapi.com/api/episode")
        }
        static func urlForEpisode(ids: [Int]) -> URL? {
            let idsList = ids.map{String($0)}.joined(separator: ",")
            return URL(string: "https://rickandmortyapi.com/api/episode/\(idsList)")
        }
        static func urlForFilterChar(query: String) -> URL? {
            return URL(string: "https://rickandmortyapi.com/api/character/?name=\(query)")
        }
        static func urlForFilterEp(query: String) -> URL? {
            return URL(string: "https://rickandmortyapi.com/api/episode/?name=\(query)")
        }
        static func urlForSingleEp(id: Int) -> URL? {
            return URL(string: "https://rickandmortyapi.com/api/episode/\(id)")
        }
    }
}
