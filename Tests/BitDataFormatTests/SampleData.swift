//
//  SampleData.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 07/08/2025.
//

import Foundation
@testable import BitDataFormat

struct SampleData {
    nonisolated(unsafe) static let shared = SampleData()
    
    let latinCharacters: String
    let greekCharacters: String
    let chineseCharacters: String
    let emojiAndSymbols: String
    let hebrewCharacters: String
    let sampleDataPrimitives: [Any]
    let sampleDataNumbers: [Any]
    let sampleDataStrings: [String]
    let sampleDataDates: [Date]
    let allTypes: [Any]
    
    private init() {
        let latinCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz" // 1 byte characters
        let greekCharacters = "ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩαβγδεζηθικλμνξοπρστυφχψω" // 2 bytes characters
        let chineseCharacters = "你好世界中文测试数据字符汉字编程输入输出" // 3 bytes characters
        let emojiAndSymbols = "😀😂🚀❤️👍🏻🌍📦✨©️®️™️" // 4 bytes characters
        let hebrewCharacters = "אבגדהוזחטיךכלםמןנסעףפץצקרשת" // 2 bytes characters, RTL
        
        let sampleDataPrimitives: [Any] = [
            NSNull(),
            true,
            false
        ]
        
        let sampleDataNumbers: [Any] = [
            0,
            BitDataConstants.Number.digitsMaxValue,
            BitDataConstants.Number.bits16MaxValue,
            BitDataConstants.Number.bits24MaxValue,
            BitDataConstants.Number.bits32MaxValue,
            BitDataConstants.Number.bits64MaxValue,
            -BitDataConstants.Number.digitsMaxValue + 1,
            -Int(BitDataConstants.Number.bits16MaxValue) + 1,
            -BitDataConstants.Number.bits24MaxValue + 1,
            -Int(BitDataConstants.Number.bits32MaxValue) + 1,
        ]
        
        let sampleDataStrings: [String] = [
            "",
            BitDataConstants.String.digitsAlphabet.charactersSet.map(String.init).joined(),
            BitDataConstants.String.lowercasedAlphabet.charactersSet.map(String.init).joined(),
            BitDataConstants.String.uppercasedAlphabet.charactersSet.map(String.init).joined(),
            BitDataConstants.String.combinedAlphabet.charactersSet.map(String.init).joined(),
            BitDataConstants.String.asciiAlphabet.charactersSet.map(String.init).joined(),
            Self.generateString(maxByteSize: 15, characters: emojiAndSymbols),
            Self.generateString(maxByteSize: 255, characters: chineseCharacters),
            Self.generateString(maxByteSize: 4095, characters: greekCharacters),
            Self.generateString(maxByteSize: 65535, characters: hebrewCharacters)
        ]
        
        let sampleDataDates: [Date] = [
            Date(timeIntervalSince1970: 1_123_456),
            Date(timeIntervalSince1970: 6_543_210.847)
        ]
        
        self.latinCharacters = latinCharacters
        self.greekCharacters = greekCharacters
        self.chineseCharacters = chineseCharacters
        self.emojiAndSymbols = emojiAndSymbols
        self.hebrewCharacters = hebrewCharacters
        self.sampleDataPrimitives = sampleDataPrimitives
        self.sampleDataNumbers = sampleDataNumbers
        self.sampleDataStrings = sampleDataStrings
        self.sampleDataDates = sampleDataDates
        self.allTypes = [
            sampleDataPrimitives,
            sampleDataNumbers,
            sampleDataStrings,
            sampleDataDates,
            [[Any]()],
            [[String: Any]()]
        ].reduce([], +)
    }
    
    static func generateString(maxByteSize: Int, characters: String) -> String {
        var utf8String = ""
        var nextLength = String(Array(characters)[0]).data(using: .utf8)!.count
        var nextLetter = String(Array(characters)[1])
        repeat {
            utf8String += nextLetter
            nextLetter = String(Array(characters)[(nextLength + 1) % characters.count])
            nextLength += nextLetter.data(using: .utf8)!.count
        } while nextLength <= maxByteSize
        return utf8String
    }
}

class Animal: Codable, Equatable {
    let species: String
    
    init(species: String) {
        self.species = species
    }
    
    static func == (lhs: Animal, rhs: Animal) -> Bool {
        lhs.species == rhs.species
    }
}

final class Dog: Animal {
    let breed: String
    
    init(species: String, breed: String) {
        self.breed = breed
        super.init(species: species)
    }
    
    private enum CodingKeys: String, CodingKey {
        case breed
        case species
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.breed = try container.decode(String.self, forKey: .breed)
        let species = try container.decode(String.self, forKey: .species)
        super.init(species: species)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(breed, forKey: .breed)
        try container.encode(species, forKey: .species)
    }
    
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        lhs.species == rhs.species && lhs.breed == rhs.breed
    }
}

struct Person: Codable, Equatable {
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case name
    }
}

struct User: Codable, Equatable {
    var id: Int
    var tags: [String]
    var groups: [[Int]]
    var details: [String: String]
    var comment: String
    var children: [Person]
    var parent: Person
    
    init(id: Int, tags: [String], groups: [[Int]], details: [String: String], comment: String, children: [Person], parent: Person) {
        self.id = id
        self.tags = tags
        self.groups = groups
        self.details = details
        self.comment = comment
        self.children = children
        self.parent = parent
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case tags
        case groups
        case details
        case comment
        case children
        case parent
    }
        
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.tags = try container.decode([String].self, forKey: .tags)
        self.groups = try container.decode([[Int]].self, forKey: .groups)
        self.details = try container.decode([String: String].self, forKey: .details)
        self.comment = try container.decode(String.self, forKey: .comment)
        self.children = try container.decode([Person].self, forKey: .children)
        self.parent = try Person(from: container.superDecoder(forKey: .parent))
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(tags, forKey: .tags)
        try container.encode(groups, forKey: .groups)
        try container.encode(details, forKey: .details)
        try container.encode(comment, forKey: .comment)
        try container.encode(children, forKey: .children)
        try container.encode(parent, forKey: .parent)
    }
}
