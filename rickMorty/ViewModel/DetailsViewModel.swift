//
//  epViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 12.07.21.
//

import Foundation
import RxCocoa
import RxSwift
class DetailsViewModel {
    var detEpisodes = BehaviorRelay(value: [EpisodeRes]())
    var chars = BehaviorRelay(value: [CharactersM]())
    var selectedIndex = 0
    var db = DisposeBag()
    var charDetail = BehaviorRelay<CharactersM?>(value: nil)
    func modelAt(_ index: Int) {
        selectedIndex = index
    }
    func search(_ query: String) {
        if query.isEmpty == false {
            filterChar(for: query)
             }
    }
    func fetchEp() {
        let lastChar = charDetail.value!.episode[0].lastIndex(of: "/")
        let tempArr = charDetail.value!.episode.map{String($0[lastChar!...].dropFirst())}
        let tempArr2 = tempArr.map{Int($0)!}
        if tempArr2.count == 1 {
            fetchSingleEpisode(id: tempArr2[0])
        }
        else {
            fetchEpisodes(ids: tempArr2) 
        }
    }
    func getIds(_ index: Int) -> [Int] {
        let lastChar = self.detEpisodes.value[0].characters[0].lastIndex(of: "/")
        let arr = self.detEpisodes.value.map{$0.characters.map{String($0[lastChar!...].dropFirst())}}
        let intArr = arr[index].map{Int($0)!}
        return intArr
    }
    func fetchSingleEpisode(id: Int) {
        guard let url = Constants.Urls.urlForSingleEp(apiAddress: Constants.apiAddress,id: id) else {return}
            ApiServices.load(url: url, model: EpisodeRes.self)
                .subscribe(onNext: {response in
                    self.detEpisodes.accept([response])
                }).disposed(by: db)
    }
    func fetchEpisodes(ids: [Int]) {
        guard let url = Constants.Urls.urlForEpisode(apiAddress: Constants.apiAddress,ids: ids) else {return}
            ApiServices.load(url: url, model: [EpisodeRes].self)
                .subscribe(onNext: {response in
                    self.detEpisodes.accept(response)
                }).disposed(by: db)
        }
    func filterChar(for query: String) {
        guard let url = Constants.Urls.urlForFilterChar(apiAddress: Constants.apiAddress, query: query) else {return}
        ApiServices.load(url: url, model: FilterM.self)
            .subscribe(onNext: { response in
                self.chars.accept(response.results)
            }).disposed(by: db)
    }

}
