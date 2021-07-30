//
//  epCollCell.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit

class epCollCell: UICollectionViewCell {
    @IBOutlet weak var episode: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var airDate: UILabel!
    func configure(_ vm: EpisodeRes) {
        self.episode.text = vm.episode
        self.airDate.text = vm.airDate
        self.name.text = vm.name
        
    }
}
