//
//  CharactersCell.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import SDWebImage
class CharactersCell: UICollectionViewCell {
    @IBOutlet weak var charImg: UIImageView!
    @IBOutlet weak var charName: UILabel!
    @IBOutlet weak var charStatus: UILabel!
    func upate(with item: CharactersM) {
        charImg.sd_setImage(with: URL(string: item.image))
        charName.text = item.name
        if item.status != "Alive" {
            charStatus.textColor = .red
        }
        else {
            charStatus.textColor = .green
        }
        charStatus.text = item.status
    }
}
