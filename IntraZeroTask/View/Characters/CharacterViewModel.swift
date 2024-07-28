//
//  CharacterViewModel.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation
import RxSwift
import RxCocoa


class CharacterViewModel{
    
    private let disposeBag = DisposeBag()
    let getAllCharactersRelay = PublishRelay<String>()
    let searchTextFieldRelay = PublishRelay<String>()
    let errorPublisher = PublishRelay<Error?>()
    let noDataPublisher = PublishRelay<Bool>()
    
    var characters = [CharacterResult]()
    var reloadTableClosure:((Bool) ->Void)?
    
    init(){
        fetchCharacters()
        searchForCharacter()
    }
    deinit{
        print("6%&%*&^%*&^%*&^%*&^%*&%*^%*&*&^%")
    }
    
    
    
    private func fetchCharacters(){
        
        getAllCharactersRelay
            .flatMapLatest { page -> Observable<CharacterModel> in
                APICharacters.shared.fetchAllCharacters(page: page)
                    .subscribe(on:ConcurrentDispatchQueueScheduler(qos: .background))
                    .observe(on: MainScheduler.instance)
                    .catch {[weak self] error in
                        print(error.localizedDescription)
                        self?.errorPublisher.accept(error)
                        return Observable.empty()
                    }
            }
            .subscribe {[weak self] characters in
                if let results = characters.results{
                    self?.errorPublisher.accept(nil)
                    self?.characters.append(contentsOf: results)
                }
                self?.reloadTableClosure?(false)
            }onError: {[weak self] error in
                print(error.localizedDescription)
                self?.errorPublisher.accept(error)

            }
            .disposed(by: disposeBag)
            
        
    }
    
    private func searchForCharacter() {
        searchTextFieldRelay
            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.instance)
            .retry()
            .flatMapLatest { input -> Observable<CharacterModel> in
                APICharacters.shared.fetchCharactersFromSearch(input: input)
                    .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .background))
                    .observe(on: MainScheduler.instance)
                    .catch {[weak self] error in
                        print(error.localizedDescription)
                        self?.errorPublisher.accept(error)
                        return Observable.empty()
                    }

            }
            .subscribe {[weak self] characters in
                if let results = characters.results,results.count > 0{
                    self?.errorPublisher.accept(nil)
                    self?.characters = results
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
