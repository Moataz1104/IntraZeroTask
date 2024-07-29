//
//  StarShipEntity+CoreDataProperties.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 29/07/2024.
//
//

import Foundation
import CoreData


extension StarShipEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StarShipEntity> {
        return NSFetchRequest<StarShipEntity>(entityName: "StarShipEntity")
    }

    @NSManaged public var starshipClass: String?
    @NSManaged public var mglt: String?
    @NSManaged public var hyperdriveRating: String?
    @NSManaged public var consumables: String?
    @NSManaged public var cargoCapacity: String?
    @NSManaged public var passengers: String?
    @NSManaged public var crew: String?
    @NSManaged public var maxAtmospheringSpeed: String?
    @NSManaged public var length: String?
    @NSManaged public var costInCredits: String?
    @NSManaged public var manufacturer: String?
    @NSManaged public var model: String?
    @NSManaged public var name: String?

}

extension StarShipEntity : Identifiable {

}
