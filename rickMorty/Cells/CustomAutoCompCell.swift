//
//  CustomAutoCompCell.swift
//  rickMorty
//
//  Created by Alexandre on 13.07.21.
//
import UIKit
import LUAutocompleteView

final class CustomAutocompleteTableViewCell: LUAutocompleteTableViewCell {
    // MARK: - Base Class Overrides
  
    
        override func set(text: String) {
        textLabel?.text = text
        textLabel?.textColor = .black
        textLabel?.font = UIFont(name: "Marker Felt Thin", size: 20)
        
    }
}
