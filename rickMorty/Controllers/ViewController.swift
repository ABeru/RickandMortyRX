//
//  ViewController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
class ViewController: UIViewController {
    @IBOutlet private weak var searchName: UITextField!
    @IBOutlet private weak var epCollection: UICollectionView!
    private let autoCompView = LUAutocompleteView()
    var vm = EpsViewModel()
    private var datasource: CollViewDataSource<epCollCell,EpisodeRes>!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
        Assign()
        loadEpisodes()
        Display()
    }
    private func Assign() {
        epCollection.assignLayout(size: self.view.frame.width, height: 140)
        epCollection.delegate = self
        autoCompView.delegate = self
        autoCompView.dataSource = self
        autoCompView.assign(textField: searchName)
    }
    private func Display() {
        datasource = CollViewDataSource(cellIdentifier: "episodesCell", items: self.vm.episodes) { cell, vm in
            cell.airDate.text = vm.airDate
            cell.episode.text = vm.episode
            cell.name.text = vm.name
        }
        epCollection.dataSource = datasource
    }
    private func loadEpisodes() {
        vm.fetchEpisodes(completion: {
            DispatchQueue.main.async { [weak self] in
                self?.datasource.updateItems((self?.vm.episodes)!)
                self?.epCollection.reloadData()
            }
        })
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CharVc = segue.destination as? CharactersController{
            CharVc.vm = CharactersViewModel(charIds: vm.getIds(vm.selectedIndex), episode: vm.episodes[vm.selectedIndex])
        }
    }
    @IBAction private func searchTextChanged(_ sender: UITextField) {
        vm.search(sender.text ?? "")
    }
}


extension ViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.modelAt(indexPath.row)
        performSegue(withIdentifier: "goChar", sender: self)
    }
}
extension ViewController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = vm.filtered.map{$0.name}.filter { $0.lowercased().contains(text.lowercased())
        }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension ViewController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        vm.selectedIndex = vm.filtered.firstIndex(where: {$0.name == text})!
        vm.episodes = vm.filtered
        searchName.text = ""
        performSegue(withIdentifier: "goChar", sender: nil)
    }
}
