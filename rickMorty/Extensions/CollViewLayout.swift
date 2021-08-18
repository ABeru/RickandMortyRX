//
//  CollViewLayout.swift
//  rickMorty
//
//  Created by Alexandre on 18.08.21.
//

import Foundation
import UIKit
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
