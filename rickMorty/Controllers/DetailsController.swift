//
//  DetailsController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
import RxSwift
import RxCocoa
import SDWebImage
class DetailsController: UIViewController {
    @IBOutlet private weak var charImg: UIImageView!
    @IBOutlet private weak var status: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var species: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var location: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    @IBOutlet private weak var episodesColl: UICollectionView!
    var vm = DetailsViewModel()
    var db = DisposeBag()
    private var datasource: CollViewDataSource<DetailsCell, EpisodeRes>!
    private let autoCompView = LUAutocompleteView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
        Assign()
        vm.charDetail
            .subscribe(onNext: { [self] response in
                AttachUI(response!)
                loadEpisodes()
            }).disposed(by: db)
    }
    private func Assign() {
        episodesColl.delegate = self
        autoCompView.assign(textField: searchField)
        autoCompView.delegate = self
        autoCompView.dataSource = self
    }
    private func AttachUI(_ item: CharactersM) {
        gender.text = item.gender
        name.text = item.name
        location.text = item.location.name
        species.text = item.species
        if item.status != "Alive" {
            status.textColor = .red
        }
        else {
            status.textColor = .green
        }
        status.text = item.status
        charImg.sd_setImage(with: URL(string: item.image))
    }
    private func DisplayCell() {
        datasource = CollViewDataSource(cellIdentifier: "detailCell", items: vm.detEpisodes.value) { cell, vm in
            cell.airDate.text = vm.airDate
            cell.episode.text = vm.episode
            cell.name.text = vm.name
        }
        episodesColl.dataSource = self.datasource
    
    }
    @IBAction private func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    private func loadEpisodes() {
        vm.fetchEp()
        vm.detEpisodes
            .subscribe(onNext: { result in
                DispatchQueue.main.async {
                self.DisplayCell()
                self.episodesColl.reloadData()
                }
            }).disposed(by: db)
            }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CharVc = segue.destination as? CharactersController{
            CharVc.vm.charIds.accept(vm.getIds(vm.selectedIndex))
            CharVc.vm.episode.accept(vm.detEpisodes.value[vm.selectedIndex])
          
        }
    }
    @IBAction private func searchText(_ sender: UITextField) {
        vm.search(sender.text ?? "")
    }
}
extension DetailsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.modelAt(indexPath.row)
        self.performSegue(withIdentifier: "charGo", sender: nil)
        

    }
    
}
extension DetailsController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = vm.chars.value.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension DetailsController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        vm.selectedIndex = vm.chars.value.firstIndex(where: {$0.name == text})!
        vm.charDetail.accept(vm.chars.value[vm.selectedIndex])
        searchField.text = ""
}
}
