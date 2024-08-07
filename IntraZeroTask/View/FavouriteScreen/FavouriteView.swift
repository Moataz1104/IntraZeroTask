//
//  FavouriteView.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 29/07/2024.
//

import UIKit
import CoreData
class FavouriteView: UIViewController {

//    MARK: - Attributes
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeHolderImage: UIImageView!
    
    private let identfier = "favouriteCell"
    let modelContext:NSManagedObjectContext
    
    var viewModel : FavouriteViewModel!
    
//    MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
            
        setUpView()
        checkForEmptyState()
        
    }
    
    init(modelContext: NSManagedObjectContext) {
        self.modelContext = modelContext
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Actions
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
//    MARK: - Privates
    private func checkForEmptyState(){
        if let ch = viewModel.characterItems, let sh = viewModel.shipItems{
            if ch.isEmpty && sh.isEmpty{
                placeHolderImage.isHidden = false
                placeHolderImage.image = UIImage(resource: .favState)
                tableView.isHidden = true
            }else{
                placeHolderImage.isHidden = true
                tableView.isHidden = false
            }
        }
    }
    
    private func setUpView(){
        viewModel = FavouriteViewModel(modelContext: modelContext)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: identfier)
    }
}


extension FavouriteView: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 0
        if let characterItems = viewModel.characterItems, !characterItems.isEmpty {
            sections += 1
        }
        if let shipItems = viewModel.shipItems, !shipItems.isEmpty {
            sections += 1
        }
        return sections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if let characterItems = viewModel.characterItems, !characterItems.isEmpty {
                return characterItems.count
            } else if let shipItems = viewModel.shipItems, !shipItems.isEmpty {
                return shipItems.count
            }
        } else if section == 1 {
            if let ships = viewModel.shipItems, !ships.isEmpty {
                return viewModel.shipItems?.count ?? 0
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identfier, for: indexPath)
        if indexPath.section == 0 {
            if let characterItems = viewModel.characterItems, !characterItems.isEmpty {
                cell.textLabel?.text = characterItems[indexPath.row].name
            } else if let shipItems = viewModel.shipItems, !shipItems.isEmpty {
                cell.textLabel?.text = shipItems[indexPath.row].name
            }
        } else if indexPath.section == 1 {
            cell.textLabel?.text = viewModel.shipItems?[indexPath.row].name
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            if let characterItems = viewModel.characterItems, !characterItems.isEmpty {
                return "Characters"
            } else if let shipItems = viewModel.shipItems, !shipItems.isEmpty {
                return "Star Ships"
            }
        } else if section == 1 {
            return "Star Ships"
        }
        return nil
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let characterResult: CharacterResult?
        let shipResult: ShipResult?

        if indexPath.section == 0 {
            if let characterItems = viewModel.characterItems, !characterItems.isEmpty {
                characterResult = viewModel.transformToCharResult(character: viewModel.characterItems![indexPath.row])
                shipResult = nil
            } else if let shipItems = viewModel.shipItems, !shipItems.isEmpty {
                characterResult = nil
                shipResult = viewModel.transformToShipResult(ship: viewModel.shipItems![indexPath.row])
            } else {
                return
            }
        } else if indexPath.section == 1 {
            characterResult = nil
            shipResult = viewModel.transformToShipResult(ship: viewModel.shipItems![indexPath.row])
        } else {
            return
        }

        let vc = DetailView(characterItem: characterResult,
                            shipItem: shipResult,
                            context: modelContext,
                            isSaveButtonHidden: true)
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }


    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if indexPath.section == 0 {
                if let characterItems = viewModel.characterItems, !characterItems.isEmpty {
                    viewModel.deleteItem(character: characterItems[indexPath.row], ship: nil)
                    viewModel.characterItems?.remove(at: indexPath.row)
                    
                } else if let shipItems = viewModel.shipItems, !shipItems.isEmpty {
                    viewModel.deleteItem(character: nil, ship: shipItems[indexPath.row])
                    viewModel.shipItems?.remove(at: indexPath.row)
                }
            } else if indexPath.section == 1 {
                viewModel.deleteItem(character: nil, ship: viewModel.shipItems?[indexPath.row])
                viewModel.shipItems?.remove(at: indexPath.row)
            }
            tableView.reloadData()
            checkForEmptyState()
        }
    }
    
    

    
}
