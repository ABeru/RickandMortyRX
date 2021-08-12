//
//  EpViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class EpsViewModel {
    var episodes = BehaviorRelay<[EpisodeRes]>(value: [])
    var filtered = BehaviorRelay(value: [EpisodeRes]())
    var db = DisposeBag()
    var selectedIndex = 0
    func modelAt(_ index: Int) {
        selectedIndex = index
    }
    func getIds(_ index: Int) -> [Int] {
        let lastChar = self.episodes.value[0].characters[0].lastIndex(of: "/")
        let arr = self.episodes.value.map{$0.characters.map{String($0[lastChar!...].dropFirst())}}
        let intArr = arr[index].map{Int($0)!}
        return intArr
    }
    func search(_ query: String) {
        if query.isEmpty == false {
            filterEp(for: query)
            }

    }
    
    func fetchEpisodes() {
        guard let url = Constants.Urls.urlForEpisodes(apiAddress: Constants.apiAddress) else {return}
        ApiServices.load(url: url, model: Episodes.self)
            .subscribe(onNext: { response in
                self.episodes.accept(response.results)
            }).disposed(by: db)
    }
    func filterEp(for query: String) {
        guard let url = Constants.Urls.urlForFilterEp(apiAddress: Constants.apiAddress, query: query) else {return}
        ApiServices.load(url: url, model: Episodes.self)
            .subscribe(onNext: { response in
                self.filtered.accept(response.results)
            }).disposed(by: db)
    }
}


