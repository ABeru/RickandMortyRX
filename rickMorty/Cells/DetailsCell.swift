//
//  DetailsCell.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit

class DetailsCell: UICollectionViewCell {
    @IBOutlet weak var episode: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var airDate: UILabel!
    
    func update(with item: EpisodeRes) {
        episode.text = item.episode
        name.text = item.name
        airDate.text = item.airDate
    }
}
