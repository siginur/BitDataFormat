//
//  BitDataAlphabet.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import Foundation

struct BitDataAlphabet {
    let closeCharacter: UInt8
    let closeCharacterSizeInBits: UInt8
    let characterSizeInBits: UInt8
    let characters: [Character: UInt8]
    let charactersReversed: [UInt8: Character]
    let charactersSet: Set<Character>
    
    init(closeCharacter: UInt8, closeCharacterSizeInBits: UInt8, characterSizeInBits: UInt8, characters: [Character : UInt8]) {
        self.closeCharacter = closeCharacter
        self.closeCharacterSizeInBits = closeCharacterSizeInBits
        self.characterSizeInBits = characterSizeInBits
        self.characters = characters
        self.charactersReversed = Dictionary(uniqueKeysWithValues: characters.map { ($0.value, $0.key) })
        
        self.charactersSet = Set(characters.keys)
    }
}
