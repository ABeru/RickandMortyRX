//
//  LuaDatasource.swift
//  rickMorty
//
//  Created by Alexandre on 21.07.21.
//

import Foundation
import LUAutocompleteView
class LuaDatasource: LUAutocompleteViewDataSource {
    var items: [String]
    init(items: [String]) {
        self.items = items
    }
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = items
        completion(elementsThatMatchInput)
    }
}
