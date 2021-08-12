//
//  TableViewDataSource.swift
//  rickMorty
//
//  Created by Alexandre on 19.07.21.
//

import Foundation
import UIKit
import SkeletonView
class CollViewDataSource<CellType,ViewModel>: NSObject, UICollectionViewDataSource where CellType: UICollectionViewCell {
    
    let cellIdentifier: String
    var items: [ViewModel]
    let configureCell: (CellType, ViewModel) -> ()
    
    init(cellIdentifier: String, items: [ViewModel], configureCell: @escaping (CellType,ViewModel) -> ()) {
        
        self.cellIdentifier = cellIdentifier
        self.items = items
        self.configureCell = configureCell
    }
    
    func updateItems(_ items: [ViewModel]) {
        self.items = items
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdentifier, for: indexPath) as? CellType else {
            fatalError("Cell with identifier \(cellIdentifier) not found")
        }
        let vm = items[indexPath.row]
        self.configureCell(cell, vm)
        return cell
        
    }
    
}
extension CollViewDataSource: SkeletonCollectionViewDataSource {
    func numSections(in collectionSkeletonView: UICollectionView) -> Int {
        return 1
    }
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
   
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return cellIdentifier
    }
    
    
}
