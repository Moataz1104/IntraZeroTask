//
//  DetailView.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import UIKit

class DetailView: UIViewController {

//    MARK: - Attributes
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let characterItem:CharacterResult?
    let shipItem:ShipResult?
    
    var propertyKeys: [String] = []
    var propertyValues: [String] = []

//    MARK: - View Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSetup()
        registerCell()
        setupPropertyArrays()
        
        
    }
    init( characterItem: CharacterResult?, shipItem: ShipResult?) {
        self.characterItem = characterItem
        self.shipItem = shipItem
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
    }
//    MARK: - Privates
    
    private func configureSetup(){
        navigationController?.navigationBar.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        titleLabel.text = characterItem?.name ?? shipItem?.name ?? ""
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
