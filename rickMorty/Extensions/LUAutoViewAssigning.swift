//
//  LUAutoViewAssigning.swift
//  rickMorty
//
//  Created by Alexandre on 18.08.21.
//

import Foundation
import LUAutocompleteView

extension LUAutocompleteView {
    func assign(textField: UITextField) {
        self.autocompleteCell = CustomAutocompleteTableViewCell.self
        self.rowHeight = 45
        self.maximumHeight = 300
        self.textField = textField
        
    }
}
