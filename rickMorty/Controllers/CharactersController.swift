//
//  CharactersController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
class CharactersController: UIViewController {
    @IBOutlet private weak var charColl: UICollectionView!
    @IBOutlet private weak var season: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var airDate: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    var vm: CharactersViewModel!
    private let autoCompView = LUAutocompleteView()
    private var datasource: CollViewDataSource<CharactersCell, CharactersM>!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
        Assign()
        loadData()
        Display()
    }
    private func Assign() {
        charColl.delegate = self
        charColl.assignLayout(size: view.frame.width, height: 270)
        autoCompView.assign(textField: searchField)
        autoCompView.delegate = self
        autoCompView.dataSource = self
        
        }
    private func Display() {
        airDate.text = vm.episode.airDate
        season.text = vm.episode.episode
        name.text = vm.episode.name
        datasource = CollViewDataSource(cellIdentifier: "charCell", items: vm.characters) { cell, vm in
            cell.charName.text = vm.name
            if vm.status != "Alive" {
                cell.charStatus.textColor = .red
            }
            else {
                cell.charStatus.textColor = .green
            }
            cell.charStatus.text = vm.status
            vm.image.downloadImage{(image) in
                DispatchQueue.main.async {
                    cell.charImg.image = image
                }
            }
            }
    
        charColl.dataSource = datasource
    }
    private func loadData() {
        vm.fetchChar(completion: {
            DispatchQueue.main.async { [weak self] in
                self?.datasource.updateItems((self?.vm.characters)!)
                self?.charColl.reloadData()
            }
        })
    }
    @IBAction private func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let DetailsVc = segue.destination as? DetailsController{
            DetailsVc.vm = DetailsViewModel(charDetail: vm.characters[vm.selectedIndex])
        }
    }
    @IBAction private func searchText(_ sender: UITextField) {
        vm.search(sender.text ?? "")
    }
}
extension CharactersController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        vm.modelAt(indexPath.row)
        performSegue(withIdentifier: "goDetails", sender: nil)
    }
    
}
extension CharactersController: LUAutocompleteViewDataSource {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, elementsFor text: String, completion: @escaping ([String]) -> Void) {
        let elementsThatMatchInput = vm.filtered.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension CharactersController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        vm.selectedIndex = vm.filtered.firstIndex(where: {$0.name == text})!
        vm.characters = vm.filtered
        searchField.text = ""
        performSegue(withIdentifier: "goDetails", sender: nil)
    }
}
