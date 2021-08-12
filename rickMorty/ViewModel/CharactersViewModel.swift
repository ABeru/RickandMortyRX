//
//  CharactersViewModel.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire
class CharactersViewModel {
    var character = BehaviorRelay(value: [CharactersM]())
    var filtered = BehaviorRelay(value: [CharactersM]())
    var passedArray = [CharactersM]()
    var charIds = BehaviorRelay(value: [Int]())
    var selectedIndex = 0
    var db = DisposeBag()
    var episode = BehaviorRelay<EpisodeRes?>(value: nil)
    func modelAt(_ index: Int) {
        selectedIndex = index
    }
    func search(_ query: String) {
        if query.isEmpty == false {
            filterChar(for: query)
        }
    }
    func fetchChar()  {
        guard let url = Constants.Urls.urlForChar(apiAddress: Constants.apiAddress,ids: charIds.value) else {return}
        ApiServices.load(url: url, model: [CharactersM].self)
            .subscribe(onNext: {response in
                self.character.accept(response)
                self.passedArray = self.character.value
            }).disposed(by: db)
       
    }
    func filterChar(for query: String) {
        guard let url = Constants.Urls.urlForFilterChar(apiAddress: Constants.apiAddress, query: query) else {return}
        ApiServices.load(url: url, model: FilterM.self)
            .subscribe(onNext: { response in
                self.filtered.accept(response.results)
            }).disposed(by: db)
}
}
