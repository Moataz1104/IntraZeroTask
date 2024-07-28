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
    let homeworld: String?
    let created, edited: String?
}
