//
//  StarshipsView.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import UIKit
import RxSwift
import RxCocoa

class StarshipsView: UIViewController {
    
//    MARK: - Attributes
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeHolderImage: UIImageView!
    
    private let viewModel = StarshipsViewModel()
    private let disposeBag = DisposeBag()
    private let cellIdentifier = "ShipCell"
    private var hasReachedBottom = false
    
    
//    MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = true
        configureSetup()
        
        registerCell()
        reloadTableView()
        
        bindTextField()
        subscribeToErrorPublisher()
        subscribeToNoDataPublisher()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllShipsRelay.accept(())
    }

//    MARK: - Actions
    @IBAction func viewTapGesture(_ sender: Any) {
        view.endEditing(true)
        
    }
//    MARK: - Bind and Subscribe
    private func bindTextField(){
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.searchTextFieldRelay)
            .disposed(by: disposeBag)
    }
    
    private func subscribeToErrorPublisher() {
        viewModel.errorPublisher
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                if error != nil {
                    self?.tableView.isHidden = true
                    self?.placeHolderImage.isHidden = false
                    self?.placeHolderImage.image = UIImage(resource: .errorState)
                    self?.presentErrorAlert(error: error ?? NSError(domain: "", code: 0))
                } else {
                    self?.tableView.isHidden = false
                    self?.placeHolderImage.isHidden = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func subscribeToNoDataPublisher(){
        viewModel.noDataPublisher
            .observe(on: MainScheduler.instance)
            .subscribe {[weak self] event in
                if event.element ?? false{
                    self?.tableView.isHidden = true
                    self?.placeHolderImage.isHidden = false
                    self?.placeHolderImage.image = UIImage(resource: .noDataState)
                }else{
                    self?.tableView.isHidden = false
                    self?.placeHolderImage.isHidden = true
                    
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    
    
    
//    MARK: - Privates
    private func reloadTableView(){
        viewModel.reloadTableClosure = {[weak self] isAnimated in
            guard let self = self else{return}
            if isAnimated{
                DispatchQueue.main.async{
                    let range = NSRange(location: 0, length: self.tableView.numberOfSections)
                    let sections = IndexSet(integersIn: Range(range) ?? 0..<0)
                    self.tableView.reloadSections(sections, with: .fade)
                }
            }else{
                self.tableView.reloadData()
            }
            
        }
        
    }
    
    private func registerCell(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func configureSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        searchTextField.delegate = self
        placeHolderImage.isHidden = true
        placeHolderImage.layer.cornerRadius = 40
        placeHolderImage.clipsToBounds = true
    }
    
    private func presentErrorAlert(error:Error) {
        var alert = UIAlertController()
        if let error = error as? NetworkingErrors{
            alert = UIAlertController(
                title: error.title,
                message: error.localizedDescription,
                preferredStyle: .alert
            )
        }else{
            alert = UIAlertController(
                title: "Error",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
        }
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
}


extension StarshipsView:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel.ships.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.ships[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailView(characterItem:nil , shipItem: viewModel.ships[indexPath.row])
        
        navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


extension StarshipsView:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}



extension StarshipsView:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let bottomOffset = scrollView.contentSize.height - scrollView.bounds.height
        
        if scrollView.contentOffset.y >= bottomOffset && !hasReachedBottom {
            hasReachedBottom = true
            
            viewModel.getAllShipsRelay.accept(())
        } else if scrollView.contentOffset.y < bottomOffset {
            hasReachedBottom = false
            
        }
        
    }
}
