//
//  FilterViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 13.07.21.
//

import Foundation
struct FilterVmChar {
    var chars: [CharactersM]
    init(chars: [CharactersM]) {
        self.chars = chars
    }
    func modelAt(_ index: Int) -> CharactersM {
        return chars[index]
    }
    func filterChar(for query: String, completion: @escaping (FilterVmChar) -> Void) {
        let filterURL = Constants.Urls.urlForFilterChar(query: query)
        let filterResource = Resource<FilterM>(url: filterURL) { data in
            let filterResp = try? JSONDecoder().decode(FilterM.self, from: data)
            return filterResp
        }
        ApiServices.load(resource: filterResource) { (result) in
            if result != nil {
                let vm = FilterVmChar(chars: result!.results)
                completion(vm)
            }
        }
    }
}
class FilterVmEp {
    var episode: [EpisodeRes]
    init(episode: [EpisodeRes]) {
        self.episode = episode
    }
    func modelAt(_ index: Int) -> EpisodeRes {
        return episode[index]
    }
    func filterEp(for query: String, completion: @escaping (FilterVmEp) -> Void) {
        let filterURL = Constants.Urls.urlForFilterEp(query: query)
        let filterResource = Resource<Episodes>(url: filterURL) { data in
            let filterResp = try? JSONDecoder().decode(Episodes.self, from: data)
            return filterResp
        }
        ApiServices.load(resource: filterResource) { (result) in
            if result != nil {
                let vm = FilterVmEp(episode: result!.results)
                completion(vm)
            }
        }
    }
}
