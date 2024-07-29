//
//  CharacterEntity+CoreDataProperties.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 29/07/2024.
//
//

import Foundation
import CoreData


extension CharacterEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CharacterEntity> {
        return NSFetchRequest<CharacterEntity>(entityName: "CharacterEntity")
    }

    @NSManaged public var gender: String?
    @NSManaged public var birthYear: String?
    @NSManaged public var eyeColor: String?
    @NSManaged public var skinColor: String?
    @NSManaged public var hairColor: String?
    @NSManaged public var mass: String?
    @NSManaged public var height: String?
    @NSManaged public var name: String?

}

extension CharacterEntity : Identifiable {

}
