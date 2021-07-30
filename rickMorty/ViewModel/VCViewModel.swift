//
//  EpViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
import UIKit
class EpsViewModel {
    var episodes = [EpisodeRes]()
    var filtered = [EpisodeRes]()
    var selectedIndex = 0
    func modelAt(_ index: Int) {
        selectedIndex = index
    }
    func getIds(_ index: Int) -> [Int] {
        let lastChar = self.episodes[0].characters[0].lastIndex(of: "/")
        let arr = self.episodes.map{$0.characters.map{String($0[lastChar!...].dropFirst())}}
        let intArr = arr[index].map{Int($0)!}
        return intArr
    }
    func search(_ query: String) {
        if query.isEmpty == false {
            filtered.removeAll()
            filterEp(for: query)
        
            }

    }
    
    func fetchEpisodes(completion: @escaping () -> ()) {
        let charUrl = Constants.Urls.urlForEpisodes()
        let charResource = Resource<Episodes>(url: charUrl) { data in
            let charResp = try? JSONDecoder().decode(Episodes.self, from: data)
            return charResp
        }
        ApiServices.load(resource: charResource) { (result) in
            if result != nil {
                self.episodes.append(contentsOf: result!.results)
                completion()
            }
        }
    }
    func filterEp(for query: String) {
        let filterURL = Constants.Urls.urlForFilterEp(query: query)
        let filterResource = Resource<Episodes>(url: filterURL) { data in
            let filterResp = try? JSONDecoder().decode(Episodes.self, from: data)
            return filterResp
        }
        ApiServices.load(resource: filterResource) { (result) in
            if result != nil {
                self.filtered.append(contentsOf: result!.results)
            }
        }
    }
}


