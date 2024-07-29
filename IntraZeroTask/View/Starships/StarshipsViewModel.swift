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
    let getAllShipsRelay = PublishRelay<Void>()
    let searchTextFieldRelay = PublishRelay<String>()
    let errorPublisher = PublishRelay<Error?>()
    let noDataPublisher = PublishRelay<Bool>()
    
    private var nextUrlStr :String? = APIk.getShipsStr
    var ships = [ShipResult]()
    var reloadTableClosure:((Bool) ->Void)?

    init(){
        fetchShips()
        searchForShips()
    }
    
    private func fetchShips(){
        
        getAllShipsRelay
            .flatMapLatest { [weak self] _ -> Observable<ShipModel> in
                guard let nextUrl = self?.nextUrlStr else {
                    return Observable.empty()
                }
                
                return APIStarShips.shared.fetchAllShips(nextUrl: nextUrl)
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
                self?.nextUrlStr = ships.next
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
