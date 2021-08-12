//
//  Constants.swift
//  rickMorty
//
//  Created by Alexandre on 19.07.21.
//

import Foundation
struct Constants {
    
    static var apiAddress = "https://rickandmortyapi.com/api/"

    struct Urls {
        static func urlForChar(apiAddress:String, ids: [Int]) -> URL? {
            let idsList = ids.map{String($0)}.joined(separator: ",")
            return URL(string: "\(apiAddress)character/\(idsList)")
        }
        static func urlForEpisodes(apiAddress:String) -> URL? {
            return URL(string: "\(apiAddress)episode")
        }
        static func urlForEpisode(apiAddress:String,ids: [Int]) -> URL? {
            let idsList = ids.map{String($0)}.joined(separator: ",")
            return URL(string: "\(apiAddress)episode/\(idsList)")
        }
        static func urlForFilterChar(apiAddress:String,query: String) -> URL? {
            return URL(string: "\(apiAddress)character/?name=\(query)")
        }
        static func urlForFilterEp(apiAddress:String,query: String) -> URL? {
            return URL(string: "\(apiAddress)episode/?name=\(query)")
        }
        static func urlForSingleEp(apiAddress:String,id: Int) -> URL? {
            return URL(string: "\(apiAddress)episode/\(id)")
        }
    }
    
}

