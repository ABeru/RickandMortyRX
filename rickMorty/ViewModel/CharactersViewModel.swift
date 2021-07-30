//
//  CharactersViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
class CharactersViewModel {
    var characters = [CharactersM]()
    var filtered = [CharactersM]()
    var charIds: [Int]
    var selectedIndex = 0
    var episode: EpisodeRes
    init(charIds: [Int], episode: EpisodeRes) {
        self.charIds = charIds
        self.episode = episode
    }
    func modelAt(_ index: Int) {
        selectedIndex = index
    }
    func search(_ query: String) {
        if query.isEmpty == false {
            filtered.removeAll()
            filterChar(for: query)
        }
    }
    func fetchChar(completion: @escaping () -> Void) {
        let charUrl = Constants.Urls.urlForChar(ids: charIds)
        let charResource = Resource<[CharactersM]>(url: charUrl) { data in
            let charResp = try? JSONDecoder().decode([CharactersM].self, from: data)
            return charResp
        }
        ApiServices.load(resource: charResource) { (result) in
            if result != nil {
                self.characters.append(contentsOf: result!)
              completion()
            }
        }
        
    }
    func filterChar(for query: String) {
        let filterURL = Constants.Urls.urlForFilterChar(query: query)
        let filterResource = Resource<FilterM>(url: filterURL) { data in
            let filterResp = try? JSONDecoder().decode(FilterM.self, from: data)
            return filterResp
        }
        ApiServices.load(resource: filterResource) { (result) in
            if result != nil {
                self.filtered.append(contentsOf: result!.results)
            }
        }
    }
}
