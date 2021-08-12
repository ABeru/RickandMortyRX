//
//  Extensions.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import Foundation
import UIKit
import LUAutocompleteView
extension String {
    func downloadImage(completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: self) else {return}
        URLSession.shared.dataTask(with: url) { (data, res, err) in
            guard let data = data else {return}
            completion(UIImage(data: data))
        }.resume()
    }
    
}
extension UICollectionView {
    func assignLayout(size: CGFloat,height: Int) {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (Int(size) / 2) - 32, height: height)
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.collectionViewLayout = layout
    }
}
extension LUAutocompleteView {
    func assign(textField: UITextField) {
        self.autocompleteCell = CustomAutocompleteTableViewCell.self
        self.rowHeight = 45
        self.maximumHeight = 300
        self.textField = textField
        
    }
}
