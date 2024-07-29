//
//  DetailViewModel.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 29/07/2024.
//

import Foundation
import CoreData
class DetailViewModel{
    
    let modelContext:NSManagedObjectContext
    
    init(modelContext: NSManagedObjectContext) {
        self.modelContext = modelContext
    }
    //    MARK: - Core Data
    func createCharacterEntity(item:CharacterResult){
        let newItem = CharacterEntity(context: modelContext)
        
        newItem.name = item.name
        newItem.birthYear = item.birthYear
        newItem.eyeColor = item.eyeColor
        newItem.gender = item.gender
        newItem.hairColor = item.hairColor
        newItem.height = item.height
        newItem.mass = item.mass
        newItem.skinColor = item.skinColor
        
    }
    
    func createStarShipEntity(item:ShipResult){
        let newItem = StarShipEntity(context: modelContext)
        
        newItem.cargoCapacity = item.cargoCapacity
        newItem.consumables = item.consumables
        newItem.costInCredits = item.costInCredits
        newItem.crew = item.crew
        newItem.hyperdriveRating = item.hyperdriveRating
        newItem.length = item.length
        newItem.manufacturer = item.manufacturer
        newItem.maxAtmospheringSpeed = item.maxAtmospheringSpeed
        newItem.mglt = item.mglt
        newItem.model = item.model
        newItem.name = item.name
        newItem.passengers = item.passengers
        newItem.starshipClass = item.starshipClass
        
    }
}



