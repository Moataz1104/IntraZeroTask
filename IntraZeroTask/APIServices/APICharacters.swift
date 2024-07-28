//
//  APICharacters.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class APICharacters{
    static let shared = APICharacters()
    private init(){}
    
    
    
    
    func fetchAllCharacters(nextUrl: String) -> Observable<CharacterModel> {
        let url = URL(string: nextUrl)!
        
        return Observable.create { observer in
            let request = AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: CharacterModel.self) { response in
                    switch response.result {
                    case .success(let characters):
                        observer.onNext(characters)
                        observer.onCompleted()
                    case .failure(let error):
                        let statusCode = response.response?.statusCode
                        if let statusCode = statusCode, !(200..<300).contains(statusCode) {
                            observer.onError(NetworkingErrors.serverError(statusCode))
                        } else if (error.asAFError?.isResponseSerializationError ?? false) {
                            observer.onError(NetworkingErrors.decodingError(error))
                        } else {
                            observer.onError(NetworkingErrors.networkError(error))
                        }
                    }
                }
            
            return Disposables.create {
                request.cancel()
            }
        }
    }

    func fetchCharactersFromSearch(input: String) -> Observable<CharacterModel> {
        let baseURLString = APIk.getCharsStr
        
        var components = URLComponents(string: baseURLString)
        components?.queryItems = [URLQueryItem(name: "search", value: input)]
        
        guard let url = components?.url else {
            return .error(NetworkingErrors.invalidURL)
        }
        
        return Observable.create { observer in
            let request = AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: CharacterModel.self) { response in
                    switch response.result {
                    case .success(let characters):
                        observer.onNext(characters)
                        observer.onCompleted()
                    case .failure(let error):
                        let statusCode = response.response?.statusCode
                        if let statusCode = statusCode, !(200..<300).contains(statusCode) {
                            observer.onError(NetworkingErrors.serverError(statusCode))
                        } else if (error.asAFError?.isResponseSerializationError ?? false) {
                            observer.onError(NetworkingErrors.decodingError(error))
                        } else {
                            observer.onError(NetworkingErrors.networkError(error))
                        }
                    }
                }
        
            
            return Disposables.create {
                request.cancel()
            }
        }
    }
}


