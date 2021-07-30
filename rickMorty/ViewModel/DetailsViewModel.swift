//
//  epViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 12.07.21.
//

import Foundation
class DetailsViewModel {
    var detEpisodes = [EpisodeRes]()
    var chars = [CharactersM]()
    var selectedIndex = 0
    var charDetail: CharactersM
    init(charDetail: CharactersM) {
        self.charDetail = charDetail
    }
    func modelAt(_ index: Int) {
        selectedIndex = index
    }
    func search(_ query: String) {
        if query.isEmpty == false {
            chars.removeAll()
            filterChar(for: query)
             }
        else {
            chars.removeAll()
        }
    }
    func fetchEp(completion: @escaping () -> Void) {
        let lastChar = charDetail.episode[0].lastIndex(of: "/")
        let tempArr = charDetail.episode.map{String($0[lastChar!...].dropFirst())}
        let tempArr2 = tempArr.map{Int($0)!}
        if tempArr2.count == 1 {
            detEpisodes.removeAll()
            fetchSingleEpisode(id: tempArr2[0]) { (result) in
                self.detEpisodes.append(result)
                completion()
            }
        }
        else {
            detEpisodes.removeAll()
            fetchEpisodes(ids: tempArr2) { (result) in
                self.detEpisodes.append(contentsOf: result)
            completion()
        }
        }
    }
    func getIds(_ index: Int) -> [Int] {
        let lastChar = self.detEpisodes[0].characters[0].lastIndex(of: "/")
        let arr = self.detEpisodes.map{$0.characters.map{String($0[lastChar!...].dropFirst())}}
        let intArr = arr[index].map{Int($0)!}
        return intArr
    }
    func fetchSingleEpisode(id: Int, completion: @escaping (EpisodeRes) -> Void) {
        let charUrl = Constants.Urls.urlForSingleEp(id: id)
        let charResource = Resource<EpisodeRes>(url: charUrl) { data in
            let charResp = try? JSONDecoder().decode(EpisodeRes.self, from: data)
            return charResp
        }
        ApiServices.load(resource: charResource) { (result) in
            if result != nil {
                completion(result!)
            }
        }
    }
    func fetchEpisodes(ids: [Int], completion: @escaping ([EpisodeRes]) -> Void) {
            let charUrl = Constants.Urls.urlForEpisode(ids: ids)
            let charResource = Resource<[EpisodeRes]>(url: charUrl) { data in
                let charResp = try? JSONDecoder().decode([EpisodeRes].self, from: data)
                return charResp
            }
            ApiServices.load(resource: charResource) { (result) in
                if result != nil {
                    completion(result!)
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
                self.chars.append(contentsOf: result!.results)
            }
        }
    }

}
