//
//  DetailView.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import UIKit
import CoreData
class DetailView: UIViewController {
    
    //    MARK: - Attributes
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var plusButtonOutlet: UIButton!
    
    let characterItem:CharacterResult?
    let shipItem:ShipResult?
    let modelContext:NSManagedObjectContext
    let isSaveButtonHidden:Bool
    
    var viewModel:DetailViewModel?
    
    var propertyKeys: [String] = []
    var propertyValues: [String] = []
    
    //    MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSetup()
        registerCell()
        setupPropertyArrays()
        
        
    }
    init( characterItem: CharacterResult?, shipItem: ShipResult?,context:NSManagedObjectContext,isSaveButtonHidden:Bool) {
        self.characterItem = characterItem
        self.shipItem = shipItem
        self.modelContext = context
        self.isSaveButtonHidden = isSaveButtonHidden
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //    MARK: - Actions
    
    @IBAction func backButtonAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func plusButtonAction(_ sender: Any) {
        if let character = characterItem{
            viewModel?.createCharacterEntity(item: character)
            presentSaveAlert(message: "Character saved To Favourites")
        }else if let ship = shipItem{
            viewModel?.createStarShipEntity(item: ship)
            presentSaveAlert(message: "Star Ship saved To Favourites")
        }
        
    }
    //    MARK: - Privates
    
    private func configureSetup(){
        navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.text = characterItem?.name ?? shipItem?.name ?? ""
        
        if isSaveButtonHidden{
            plusButtonOutlet.isHidden = true
        }else{
            plusButtonOutlet.isHidden = false
            self.viewModel = DetailViewModel(modelContext: modelContext)
        }
        
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: DetailTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: DetailTableViewCell.identifier)
    }
    
    private func setupPropertyArrays() {
        if let character = characterItem{
            let mirror = Mirror(reflecting: character)
            
            for child in mirror.children {
                if let label = child.label, let value = child.value as? String {
                    propertyKeys.append(label)
                    propertyValues.append(value)
                }
            }
        }else if let ship = shipItem{
            let mirror = Mirror(reflecting: ship)
            
            for child in mirror.children {
                if let label = child.label, let value = child.value as? String {
                    propertyKeys.append(label)
                    propertyValues.append(value)
                }
            }
            
        }
        
    }
    
    private func presentSaveAlert(message:String){
        let alert = UIAlertController(title: "Done", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    
    
}

extension DetailView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        propertyKeys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as! DetailTableViewCell
        
        cell.configureCell(key: propertyKeys[indexPath.row], value: propertyValues[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    
}
