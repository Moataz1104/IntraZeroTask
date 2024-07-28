//
//  StarshipsViewModel.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation
import RxSwift
import RxCocoa


class StarshipsViewModel{
    
    private let disposeBag = DisposeBag()
    let getAllShipsRelay = PublishRelay<String>()
    let searchTextFieldRelay = PublishRelay<String>()
    let errorPublisher = PublishRelay<Error?>()
    let noDataPublisher = PublishRelay<Bool>()
    
    var ships = [ShipResult]()
    var reloadTableClosure:((Bool) ->Void)?

    init(){
        fetchShips()
        searchForShips()
    }
    
    private func fetchShips(){
        
        getAllShipsRelay
            .flatMapLatest { page -> Observable<ShipModel> in
                APIStarShips.shared.fetchAllShips(page: page)
                    .subscribe(on:ConcurrentDispatchQueueScheduler(qos: .background))
                    .observe(on: MainScheduler.instance)
                    .catch {[weak self] error in
                        print(error.localizedDescription)
                        self?.errorPublisher.accept(error)
                        return Observable.empty()
                    }
            }
            .subscribe {[weak self] ships in
                if let results = ships.results{
                    self?.errorPublisher.accept(nil)
                    self?.ships.append(contentsOf: results)
                }
                self?.reloadTableClosure?(false)
            }onError: {[weak self] error in
                print(error.localizedDescription)
                self?.errorPublisher.accept(error)

            }
            .disposed(by: disposeBag)
            
        
    }
    
    private func searchForShips() {
        searchTextFieldRelay
            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .retry()
            .flatMapLatest { input -> Observable<ShipModel> in
                APIStarShips.shared.fetchShipsFromSearch(input: input)
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                    .observe(on: MainScheduler.instance)
                    .catch {[weak self] error in
                        print(error.localizedDescription)
                        self?.errorPublisher.accept(error)
                        return Observable.empty()
                    }

            }
            .subscribe {[weak self] ships in
                if let results = ships.results,results.count > 0{
                    self?.errorPublisher.accept(nil)
                    self?.ships = results
                    self?.noDataPublisher.accept(false)
                }else{
                    self?.noDataPublisher.accept(true)
                }
                self?.reloadTableClosure?(true)
            }onError: {[weak self] error in
                print(error.localizedDescription)
                self?.errorPublisher.accept(error)

            }
            .disposed(by: disposeBag)
    }


}
