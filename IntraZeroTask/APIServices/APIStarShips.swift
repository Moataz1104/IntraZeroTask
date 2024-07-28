//
//  APIStarShips.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class APIStarShips{
    static let shared = APIStarShips()
    private init(){}
    
    
    
    
    func fetchAllShips(page: String) -> Observable<ShipModel> {
        let baseURLString = APIk.getShipsStr
        
        var components = URLComponents(string: baseURLString)
        components?.queryItems = [URLQueryItem(name: "page", value: page)]
        
        guard let url = components?.url else {
            return .error(NetworkingErrors.invalidURL)
        }
        
        return Observable.create { observer in
            let request = AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ShipModel.self) { response in
                    switch response.result {
                    case .success(let ships):
                        observer.onNext(ships)
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

    func fetchShipsFromSearch(input: String) -> Observable<ShipModel> {
        let baseURLString = APIk.getShipsStr
        
        var components = URLComponents(string: baseURLString)
        components?.queryItems = [URLQueryItem(name: "search", value: input)]
        
        guard let url = components?.url else {
            return .error(NetworkingErrors.invalidURL)
        }
        
        return Observable.create { observer in
            let request = AF.request(url)
                .validate(statusCode: 200..<300)
                .responseDecodable(of: ShipModel.self) { response in
                    switch response.result {
                    case .success(let ships):
                        observer.onNext(ships)
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


