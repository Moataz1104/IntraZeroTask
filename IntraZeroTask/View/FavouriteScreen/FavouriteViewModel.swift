//
//  FavouriteViewModel.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 29/07/2024.
//

import Foundation
import CoreData


class FavouriteViewModel{
    
    
    let modelContext:NSManagedObjectContext
    var characterItems:[CharacterEntity]?
    var shipItems:[StarShipEntity]?

    
    init(modelContext: NSManagedObjectContext) {
        self.modelContext = modelContext
        fetchItems()
    }
    
    func transformToCharResult(character:CharacterEntity)-> CharacterResult{
       
        return CharacterResult(name: character.name,
                               height: character.birthYear,
                               mass: character.eyeColor,
                               hairColor: character.gender,
                               skinColor: character.hairColor,
                               eyeColor: character.height,
                               birthYear: character.mass,
                               gender: character.skinColor)
        
    }
    func transformToShipResult(ship:StarShipEntity)-> ShipResult{
       
        return ShipResult(name: ship.name,
                          model: ship.model,
                          manufacturer: ship.manufacturer,
                          costInCredits: ship.costInCredits,
                          length: ship.length,
                          maxAtmospheringSpeed: ship.maxAtmospheringSpeed,
                          crew: ship.crew,
                          passengers: ship.passengers,
                          cargoCapacity: ship.cargoCapacity,
                          consumables: ship.consumables,
                          hyperdriveRating: ship.hyperdriveRating,
                          mglt: ship.mglt,
                          starshipClass: ship.starshipClass)
    }

    
    
    
    
//    MARK: - Core Data
    private func fetchItems(){
        do{
            characterItems = try modelContext.fetch(CharacterEntity.fetchRequest())
            shipItems = try modelContext.fetch(StarShipEntity.fetchRequest())
            
        }catch{
            
        }
    }
    func deleteItem(character:CharacterEntity?,ship:StarShipEntity?){
        if let ch = character{
            modelContext.delete(ch)
        }else{
            modelContext.delete(ship!)
        }
        
    }


    
}
