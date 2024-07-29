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
    let getAllCharactersRelay = PublishRelay<Void>() //Fire from the View
    let searchTextFieldRelay = PublishRelay<String>() //Fire from the View
    let errorPublisher = PublishRelay<Error?>() //Publish the error to the view
    let noDataPublisher = PublishRelay<Bool>() 
    
    private var nextUrlStr :String? = APIk.getCharsStr
    var characters = [CharacterResult]()
    var reloadTableClosure:((Bool) ->Void)?
    

    init(){
        fetchCharacters()
        searchForCharacter()
    }
        
    
    
    private func fetchCharacters(){
        
        getAllCharactersRelay
            .flatMapLatest {[weak self] _ -> Observable<CharacterModel> in
                guard let nextUrl = self?.nextUrlStr else {
                    return Observable.empty()
                }
                return APICharacters.shared.fetchAllCharacters(nextUrl: nextUrl)
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
                self?.nextUrlStr = characters.next
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
