//
//  ViewController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
import SkeletonView
import RxCocoa
import RxSwift
import RxReachability
import Reachability
class ViewController: UIViewController {
    @IBOutlet private weak var searchName: UITextField!
    @IBOutlet private weak var epCollection: UICollectionView!
    private let autoCompView = LUAutocompleteView()
    var vm = EpsViewModel()
    var db = DisposeBag()
    private var datasource: CollViewDataSource<epCollCell,EpisodeRes>!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
        Assign()
        Display()
        Reachability.rx.isReachable
            .subscribe(onNext: { connection in
                if connection == false {
                self.ShowConnectionAlert()
                }
                else {
                    self.loadEpisodes()
                }
            }).disposed(by: db)

    }
    private func Assign() {
        epCollection.assignLayout(size: self.view.frame.width, height: 140)
        epCollection.delegate = self
        autoCompView.delegate = self
        autoCompView.dataSource = self
        autoCompView.assign(textField: searchName)
    }
    private func Display() {
        datasource = CollViewDataSource(cellIdentifier: "episodesCell", items: self.vm.episodes.value) { cell, vm in
            cell.update(with: vm)
        }
        epCollection.dataSource = datasource
    }
    private func loadEpisodes() {
        
        vm.fetchEpisodes()
        vm.episodes
            .subscribe(onNext: { response in
                DispatchQueue.main.async {
                self.datasource.updateItems(self.vm.episodes.value)
                self.epCollection.reloadData()
                }
            }).disposed(by: db)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let CharVc = segue.destination as? CharactersController{
            CharVc.vm.charIds.accept(vm.getIds(vm.selectedIndex))
            CharVc.vm.episode.accept(vm.episodes.value[vm.selectedIndex])
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
        let elementsThatMatchInput = vm.filtered.value.map{$0.name}.filter { $0.lowercased().contains(text.lowercased())
        }
        
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension ViewController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        vm.selectedIndex = vm.filtered.value.firstIndex(where: {$0.name == text})!
        vm.episodes = vm.filtered
        searchName.text = ""
        performSegue(withIdentifier: "goChar", sender: nil)
    }
}
