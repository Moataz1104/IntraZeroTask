//
//  ShipModel.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation

struct ShipModel:Codable{
    let results: [ShipResult]?

}

struct ShipResult: Codable {
    let name, model, manufacturer, costInCredits: String?
    let length, maxAtmospheringSpeed, crew, passengers: String?
    let cargoCapacity, consumables, hyperdriveRating, mglt: String?
    let starshipClass: String?
    let created, edited: String?
}
