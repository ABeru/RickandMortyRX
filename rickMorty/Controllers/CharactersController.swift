//
//  CharactersController.swift
//  rickMorty
//
//  Created by Alexandre on 09.07.21.
//

import UIKit
import LUAutocompleteView
import RxSwift
import RxCocoa
import SDWebImage
class CharactersController: UIViewController {
    @IBOutlet weak var charColl: UICollectionView!
    @IBOutlet private weak var season: UILabel!
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var airDate: UILabel!
    @IBOutlet private weak var searchField: UITextField!
    var vm = CharactersViewModel()
    var db = DisposeBag()
    private let autoCompView = LUAutocompleteView()
    private var datasource: CollViewDataSource<CharactersCell, CharactersM>!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(autoCompView)
        Assign()
        vm.episode
            .subscribe(onNext: { [self] response in
                AttachUI(item: response!)
            }).disposed(by: db)
        vm.charIds
            .subscribe(onNext: { [self] response in
                loadData()
            }).disposed(by: db)
    }
    private func Assign() {
        charColl.delegate = self
        charColl.assignLayout(size: view.frame.width, height: 270)
        autoCompView.assign(textField: searchField)
        autoCompView.delegate = self
        autoCompView.dataSource = self
        
        }
    private func AttachUI(item: EpisodeRes) {
        airDate.text = item.airDate
        season.text = item.episode
        name.text = item.name
    }
    private func DisplayCell() {
        datasource = CollViewDataSource(cellIdentifier: "charCell", items: vm.character.value) { cell, vm in
            cell.charName.text = vm.name
            if vm.status != "Alive" {
                cell.charStatus.textColor = .red
            }
            else {
                cell.charStatus.textColor = .green
            }
            cell.charStatus.text = vm.status
            cell.charImg.sd_setImage(with: URL(string: vm.image))
            }
    
        charColl.dataSource = datasource
    }
    private func loadData() {
        vm.fetchChar()
        vm.character
                .subscribe(onNext: { result in
                    DispatchQueue.main.async { [self] in
                self.DisplayCell()
                self.charColl.reloadData()
                }
            }).disposed(by: self.db)
    }
    @IBAction private func Back(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override  func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let DetailsVc = segue.destination as! DetailsController
        DetailsVc.vm.charDetail.accept(vm.passedArray[vm.selectedIndex])
        vm.passedArray = vm.character.value
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
        let elementsThatMatchInput = vm.filtered.value.map{$0.name}.filter { $0.lowercased().contains(text.lowercased()) }
        completion(elementsThatMatchInput)
    }
}

// MARK: - LUAutocompleteViewDelegate
extension CharactersController: LUAutocompleteViewDelegate {
    func autocompleteView(_ autocompleteView: LUAutocompleteView, didSelect text: String) {
        vm.selectedIndex = vm.filtered.value.firstIndex(where: {$0.name == text})!
        vm.passedArray = vm.filtered.value
        searchField.text = ""
        performSegue(withIdentifier: "goDetails", sender: nil)
    }
}
