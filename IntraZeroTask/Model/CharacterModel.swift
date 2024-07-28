//
//  CharacterModel.swift
//  IntraZeroTask
//
//  Created by Moataz Mohamed on 28/07/2024.
//

import Foundation


struct CharacterModel:Codable{
    let results: [CharacterResult]?
}

struct CharacterResult: Codable {
    let name, height, mass, hairColor: String?
    let skinColor, eyeColor, birthYear, gender: String?
 
    
    enum CodingKeys: String, CodingKey {
        case name, height, mass
        case hairColor = "hair_color"
        case skinColor = "skin_color"
        case eyeColor = "eye_color"
        case birthYear = "birth_year"
        case gender
    }

}
