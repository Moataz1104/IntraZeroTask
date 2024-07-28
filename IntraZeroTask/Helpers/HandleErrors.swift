//
//  HandleErrors.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation


enum NetworkingErrors : Error {
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case invalidURL
    
    
    var localizedDescription:String {
        switch self {
        case .networkError(let error):
            return "\(error.localizedDescription)"
        case .decodingError(let error):
            return "\(error.localizedDescription)"
        case .serverError(let statusCode):
            return "status code: \(statusCode)"
        case .invalidURL:
            return "Invalid URL"
        }
    }
    
    var title:String{
        switch self {
        case .networkError(_):
            return "Network error"
        case .decodingError(_):
            return "Decoding error"
        case .serverError(_):
            return "Server error"
        case .invalidURL:
            return "Error"
        }
    }
}

