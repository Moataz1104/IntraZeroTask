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
