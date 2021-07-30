//
//  CharactersModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
struct FilterM: Codable {
    let info: Info
    let results: [CharactersM]
}

struct Info: Codable {
    let count, pages: Int
}
struct CharactersM: Codable {
    let id: Int
    let name, status, species, type: String
    let gender: String
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

struct Location: Codable {
    let name: String
    let url: String
}

