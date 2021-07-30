//
//  DetailsController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
class DetailsController: UIViewController {
    @IBOutlet private weak var charImg: UIImageView!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var species: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var episodesColl: UICollectionView!
    var vm: DetailsViewModel!
    private var datasource: CollViewDataSource<DetailsCell, EpisodeRes>!
    private let autoCompView = LUAutocompleteView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
        Assign()
    }
    private func Assign() {
        episodesColl.delegate = self
        autoCompView.assign(textField: searchField)
        autoCompView.delegate = self
        autoCompView.dataSource = self
        loadEpisodes()
        Display()
    }
    private func Display() {
        datasource = CollViewDataSource(cellIdentifier: "detailCell", items: vm.detEpisodes) { cell, vm in
            cell.airDate.text = vm.airDate
            cell.episode.text = vm.episode
            cell.name.text = vm.name
        }
        episodesColl.dataSource = self.datasource
        gender.text = vm.charDetail.gender
        name.text = vm.charDetail.name
        location.text = vm.charDetail.location.name
        species.text = vm.charDetail.species
        if vm.charDetail.status != "Alive" {
            status.textColor = .red
        }
        else {
            status.textColor = .green
        }
        status.text = vm.charDetail.status
        vm.charDetail.image.downloadImage { (image) in
            DispatchQueue.main.async { [weak self] in
                self?.charImg.image = image
            }
        }
    }
    @IBAction private func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    private func loadEpisodes() {
        vm.fetchEp(completion: {
                DispatchQueue.main.async { [weak self] in
                    self?.datasource.updateItems((self?.vm.detEpisodes)!)
                    self?.episodesColl.reloadData()
                }
        })
            }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CharVc = segue.destination as? CharactersController{
            CharVc.vm = CharactersViewModel(charIds: vm.getIds(vm.selectedIndex), episode: vm.detEpisodes[vm.selectedIndex])
        }
    }
    @IBAction private func searchText(_ sender: UITextField) {
        vm.search(sender.text ?? "")
    }
}
extension DetailsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.modelAt(indexPath.row)
        performSegue(withIdentifier: "charGo", sender: nil)
    }
    
}
extension DetailsController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = vm.chars.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension DetailsController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        vm.selectedIndex = vm.chars.firstIndex(where: {$0.name == text})!
        vm.charDetail = vm.chars[vm.selectedIndex]
        searchField.text = ""
        Assign()
    }
}
