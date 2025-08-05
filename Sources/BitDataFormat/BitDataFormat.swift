// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SMBitData

fileprivate let currentVresionSizeInBits: UInt8 = 2
fileprivate let currentVresion: UInt8 = 0

enum BitDataType {
    case primitive
    case number
    case string
    case array
    case dictionary
    
    static let sizeInBits: UInt8 = 3
    
    var secondaryTypeSizeInBits: UInt8 {
        switch self {
        case .primitive:
            return BitDataSecondType.primitiveNull.sizeInBits
        case .number:
            return BitDataSecondType.numberZero.sizeInBits
        case .string:
            return BitDataSecondType.stringEmpty.sizeInBits
        case .array, .dictionary:
            return BitDataSecondType.collectionEmpty.sizeInBits
        }
    }
    
    var bits: UInt8 {
        switch self {
        case .primitive: 0 // 000
        case .number: 1 // 001
        case .string: 2 // 010
        case .array: 3 // 011
        case .dictionary: 4 // 100
        }
    }
    
    init?(bits: UInt8) {
        switch bits {
        case 0: self = .primitive
        case 1: self = .number
        case 2: self = .string
        case 3: self = .array
        case 4: self = .dictionary
        default:
            return nil
        }
    }
}

enum BitDataSecondType {
    case primitiveNull
    case primitiveTrue
    case primitiveFalse
    case numberZero
    case numberDigits
    case number16Bits
    case number24Bits
    case number32Bits
    case number64Bits
    case stringEmpty
    case stringDigits
    case stringLowercased
    case stringUppercased
    case stringCombined
    case stringASCII
    case stringUTF8
    case collectionEmpty
    case collectionSingle
    case collectionSeparator
    case collection8BitsSize
    case collection12BitsSize
    case collection16BitsSize
    
    var sizeInBits: UInt8 {
        switch self {
        case .primitiveNull, .primitiveTrue, .primitiveFalse:
            return 2
        default:
            return 3
        }
    }
    
    var bits: UInt8 {
        switch self {
        case .primitiveNull: 0 // 00
        case .primitiveTrue: 1 // 01
        case .primitiveFalse: 2 // 10
        //case .primitiveReserved
        case .numberZero: 0 // 000
        case .numberDigits: 1 // 001
        case .number16Bits: 2 // 010
        case .number24Bits: 3 // 011
        case .number32Bits: 4 // 100
        case .number64Bits: 5 // 101
        //case .numberReserved
        //case .numberReserved
        case .stringEmpty: 0 // 000
        case .stringDigits: 1 // 001
        case .stringLowercased: 2 // 010
        case .stringUppercased: 3 // 011
        case .stringCombined: 4 // 100
        case .stringASCII: 5 // 101
        case .stringUTF8: 6 // 110
        //case .stringReserved
        case .collectionEmpty: 0 // 000
        case .collectionSingle: 1 // 001
        case .collectionSeparator: 2 // 010
        case .collection8BitsSize: 3 // 011
        case .collection12BitsSize: 4 // 100
        case .collection16BitsSize: 5 // 101
        //case .collectionReserved
        //case .collectionReserved
        }
    }
        
    init?(type: BitDataType, bits: UInt8) {
        switch type {
        case .primitive:
            switch bits {
            case 0: self = .primitiveNull
            case 1: self = .primitiveTrue
            case 2: self = .primitiveFalse
            default: return nil
            }
        case .number:
            switch bits {
            case 0: self = .numberZero
            case 1: self = .numberDigits
            case 2: self = .number16Bits
            case 3: self = .number24Bits
            case 4: self = .number32Bits
            case 5: self = .number64Bits
            default: return nil
            }
        case .string:
            switch bits {
            case 0: self = .stringEmpty
            case 1: self = .stringDigits
            case 2: self = .stringLowercased
            case 3: self = .stringUppercased
            case 4: self = .stringCombined
            case 5: self = .stringASCII
            case 6: self = .stringUTF8
            default: return nil
            }
        case .array, .dictionary:
            switch bits {
            case 0: self = .collectionEmpty
            case 1: self = .collectionSingle
            case 2: self = .collectionSeparator
            case 3: self = .collection8BitsSize
            case 4: self = .collection12BitsSize
            case 5: self = .collection16BitsSize
            default: return nil
            }
        }
    }
}

public enum BitDataEncodingError: Error {
    case unsupportedType
    case unsupportedCharacter(Character)
    case unableToConvertToUTF8String(String)
    case invalidAlphabet
    case stringIsTooLong(Int)
    case unsupportedCollectionSize(Int)
    case invalidByteConversion
    case invalidNumber
}

public enum BitDataDecodingError: Error {
    case unsupportedVersion
    case unsupportedType
    case unsupportedSecondaryType
    case unsupportedThirdType
    case unsupportedCharacter(UInt8)
    case failedToReadUTF8String
    case invalidByteConversion
    case invalidNumber
    case invalidNumberString(String)
}

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

struct BitDataConstants {
    struct Boolean {
        static let `true`: UInt8 = 1
        static let `false`: UInt8 = 0
        
        private init() { }
    }
    
    struct Number {
        static let signPositive: UInt8 = BitDataConstants.Boolean.true
        static let signNegative: UInt8 = BitDataConstants.Boolean.false
        
        static let digitsMaxValue = 999
        static let bits16MaxValue = UInt16.max
        static let bits24MaxValue = 16_777_216 - 1
        static let bits32MaxValue = UInt32.max
        static let bits64MaxValue = UInt64.max
        
        static let digitsAlphabet: BitDataAlphabet = .init(
            closeCharacter: 3, // 11
            closeCharacterSizeInBits: 2,
            characterSizeInBits: 4,
            characters: [
                "0": 0, // 0000
                "1": 1, // 0001
                "2": 2, // 0010
                "3": 3, // 0011
                "4": 4, // 0100
                "5": 5, // 0101
                "6": 6, // 0110
                "7": 7, // 0111
                "8": 8, // 1000
                "9": 9, // 1001
                ".": 10,// 1010
                "-": 11,// 1011
            ]
        )
        
        private init() { }
    }
    
    struct String {
        static let lengthSizeInBits: UInt8 = 2
        static let length4Bits: UInt8 = 0 // 00
        static let length8Bits: UInt8 = 1 // 01
        static let length12Bits: UInt8 = 2 // 10
        static let length16Bits: UInt8 = 3 // 11
        
        static let digitsAlphabet: BitDataAlphabet = .init(
            closeCharacter: 15, // 1111
            closeCharacterSizeInBits: 4,
            characterSizeInBits: 4,
            characters: [
                "0": 0, // 0000
                "1": 1, // 0001
                "2": 2, // 0010
                "3": 3, // 0011
                "4": 4, // 0100
                "5": 5, // 0101
                "6": 6, // 0110
                "7": 7, // 0111
                "8": 8, // 1000
                "9": 9, // 1001
                ".": 10, // 1010
                "-": 11, // 1011
                " ": 12, // 1100
                ",": 13, // 1101
                //"reserved": 14
            ]
        )
        static let lowercasedAlphabet: BitDataAlphabet = .init(
            closeCharacter: 31, // 11111
            closeCharacterSizeInBits: 5,
            characterSizeInBits: 5,
            characters: [
                "a": 0, // 00000
                "b": 1, // 00001
                "c": 2, // 00010
                "d": 3, // 00011
                "e": 4, // 00100
                "f": 5, // 00101
                "g": 6, // 00110
                "h": 7, // 00111
                "i": 8, // 01000
                "j": 9, // 01001
                "k": 10, // 01010
                "l": 11, // 01011
                "m": 12, // 01100
                "n": 13, // 01101
                "o": 14, // 01110
                "p": 15, // 01111
                "q": 16, // 10000
                "r": 17, // 10001
                "s": 18, // 10010
                "t": 19, // 10011
                "u": 20, // 10100
                "v": 21, // 10101
                "w": 22, // 10110
                "x": 23, // 10111
                "y": 24, // 11000
                "z": 25, // 11001
                " ": 26, // 11010
                ".": 27, // 11011
                ",": 28, // 11100
                "-": 29, // 11101
                //"reserved": 30, // 11110
            ]
        )
        static let uppercasedAlphabet: BitDataAlphabet = .init(
            closeCharacter: 31, // 11111
            closeCharacterSizeInBits: 5,
            characterSizeInBits: 5,
            characters: [
                "A": 0, // 00000
                "B": 1, // 00001
                "C": 2, // 00010
                "D": 3, // 00011
                "E": 4, // 00100
                "F": 5, // 00101
                "G": 6, // 00110
                "H": 7, // 00111
                "I": 8, // 01000
                "J": 9, // 01001
                "K": 10, // 01010
                "L": 11, // 01011
                "M": 12, // 01100
                "N": 13, // 01101
                "O": 14, // 01110
                "P": 15, // 01111
                "Q": 16, // 10000
                "R": 17, // 10001
                "S": 18, // 10010
                "T": 19, // 10011
                "U": 20, // 10100
                "V": 21, // 10101
                "W": 22, // 10110
                "X": 23, // 10111
                "Y": 24, // 11000
                "Z": 25, // 11001
                " ": 26, // 11010
                ".": 27, // 11011
                ",": 28, // 11100
                "-": 29, // 11101
                //"reserved": 30, // 11110
            ]
        )
        static let combinedAlphabet: BitDataAlphabet = .init(
            closeCharacter: 63,
            closeCharacterSizeInBits: 6,
            characterSizeInBits: 6,
            characters: [
                "0": 0, // 000000
                "1": 1, // 000001
                "2": 2, // 000010
                "3": 3, // 000011
                "4": 4, // 000100
                "5": 5, // 000101
                "6": 6, // 000110
                "7": 7, // 000111
                "8": 8, // 001000
                "9": 9, // 001001
                "a": 10, // 001010
                "b": 11, // 001011
                "c": 12, // 001100
                "d": 13, // 001101
                "e": 14, // 001110
                "f": 15, // 001111
                "g": 16, // 010000
                "h": 17, // 010001
                "i": 18, // 010010
                "j": 19, // 010011
                "k": 20, // 010100
                "l": 21, // 010101
                "m": 22, // 010110
                "n": 23, // 010111
                "o": 24, // 011000
                "p": 25, // 011001
                "q": 26, // 011010
                "r": 27, // 011011
                "s": 28, // 011100
                "t": 29, // 011101
                "u": 30, // 011110
                "v": 31, // 011111
                "w": 32, // 100000
                "x": 33, // 100001
                "y": 34, // 100010
                "z": 35, // 100011
                "A": 36, // 100100
                "B": 37, // 100101
                "C": 38, // 100110
                "D": 39, // 100111
                "E": 40, // 101000
                "F": 41, // 101001
                "G": 42, // 101010
                "H": 43, // 101011
                "I": 44, // 101100
                "J": 45, // 101101
                "K": 46, // 101110
                "L": 47, // 101111
                "M": 48, // 110000
                "N": 49, // 110001
                "O": 50, // 110010
                "P": 51, // 110011
                "Q": 52, // 110100
                "R": 53, // 110101
                "S": 54, // 110110
                "T": 55, // 110111
                "U": 56, // 111000
                "V": 57, // 111001
                "W": 58, // 111010
                "X": 59, // 111011
                "Y": 60, // 111100
                "Z": 61, // 111101
                //"reserved": 62,
            ]
        )
        static let asciiAlphabet: BitDataAlphabet = .init(
            closeCharacter: 3,
            closeCharacterSizeInBits: 7,
            characterSizeInBits: 7,
            characters: {
                var set = [Character: UInt8]()
                for value in 0...127 {
                    guard value != 3 else { continue }
                    if let scalar = UnicodeScalar(value) {
                        set[Character(scalar)] = UInt8(value)
                    }
                }
                return set
            }()
        )
        
        private init() { }
    }
    
    struct Collection {
        static let maxSizeForUsingSeparator: Int = 8
        
        static let sameValueType: UInt8 = BitDataConstants.Boolean.true
        static let differentValueTypes: UInt8 = BitDataConstants.Boolean.false
        
        static let separatorLastElement: UInt8 = BitDataConstants.Boolean.true
        static let separatorMiddleElement: UInt8 = BitDataConstants.Boolean.false
        
        private init() { }
    }
    
    private init() { }
}

class BDFSerialization {
    static func data(withBSDObject object: Any?) throws -> Data {
        return try self.dataWithStats(withBSDObject: object).data
    }
    
    static func dataWithStats(withBSDObject object: Any?) throws -> (bits: UInt64, data: Data) {
        let data = SMBitDataWriter()
        data.writeBits(currentVresion, count: currentVresionSizeInBits) // Version
        try self.encode(object: object, includeType: true, to: data) // Content
        return (data.sizeInBits, data.data)
    }
    
    static func object(with data: Data) throws -> Any {
        let data = SMBitDataReader(data: data)
        let dataVersion = try data.readBits(currentVresionSizeInBits)
        guard dataVersion <= currentVresion else {
            throw BitDataDecodingError.unsupportedVersion
        }
        return try self.decode(from: data, as: nil)
    }
    
    private static func encode(object: Any?, includeType: Bool, to data: SMBitDataWriter) throws {
        switch object {
            // Primitive types
        case let v as Bool:
            if includeType {
                data.writeTypeSignature(.primitive)
            }
            data.writeTypeSignature(v == true ? .primitiveTrue : .primitiveFalse)
        case _ as NSNull, nil:
            if includeType {
                data.writeTypeSignature(.primitive)
            }
            data.writeTypeSignature(.primitiveNull)
            
            // Number types
        case let v as Int:
            if includeType {
                data.writeTypeSignature(.number)
            }
            let absolute = v > 0 ? v : -v
            try self.encode(number: UInt64(absolute), isPositive: v >= 0, to: data)
        case let v as Int8:
            if includeType {
                data.writeTypeSignature(.number)
            }
            let absolute = v > 0 ? v : -v
            try self.encode(number: UInt64(absolute), isPositive: v >= 0, to: data)
        case let v as Int16:
            if includeType {
                data.writeTypeSignature(.number)
            }
            let absolute = v > 0 ? v : -v
            try self.encode(number: UInt64(absolute), isPositive: v >= 0, to: data)
        case let v as Int32:
            if includeType {
                data.writeTypeSignature(.number)
            }
            let absolute = v > 0 ? v : -v
            try self.encode(number: UInt64(absolute), isPositive: v >= 0, to: data)
        case let v as Int64:
            if includeType {
                data.writeTypeSignature(.number)
            }
            let absolute = v > 0 ? v : -v
            try self.encode(number: UInt64(absolute), isPositive: v >= 0, to: data)
        case let v as UInt:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(number: UInt64(v), isPositive: true, to: data)
        case let v as UInt8:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(number: UInt64(v), isPositive: true, to: data)
        case let v as UInt16:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(number: UInt64(v), isPositive: true, to: data)
        case let v as UInt32:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(number: UInt64(v), isPositive: true, to: data)
        case let v as UInt64:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(number: v, isPositive: true, to: data)
        case let v as Float:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(digits: String(v), to: data)
        case let v as Double:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(digits: String(v), to: data)
        case let v as CGFloat:
            if includeType {
                data.writeTypeSignature(.number)
            }
            try self.encode(digits: String(Double(v)), to: data)
            
            // Strings
        case let v as String:
            if includeType {
                data.writeTypeSignature(.string)
            }
            try self.encode(string: v, to: data)
        case let v as NSString:
            if includeType {
                data.writeTypeSignature(.string)
            }
            try self.encode(string: v as String, to: data)
            
            // Arrays
        case let v as [Any]:
            if includeType {
                data.writeTypeSignature(.array)
            }
            try self.encode(array: v, to: data)
        case let v as NSArray:
            if includeType {
                data.writeTypeSignature(.array)
            }
            try self.encode(array: v as Array, to: data)
            
            // Objects
        case let v as [String: Any]:
            if includeType {
                data.writeTypeSignature(.dictionary)
            }
            try self.encode(dictionary: v, to: data)
            
        default:
            throw BitDataEncodingError.unsupportedType
        }
    }
    
    private static func dataType(of object: Any?) -> BitDataType? {
        return switch object {
            // Primitive
        case _ as Bool, _ as NSNull, nil: .primitive
            // Number
        case _ as Int, _ as Int8, _ as Int16, _ as Int32, _ as Int64, _ as UInt, _ as UInt8, _ as UInt16, _ as UInt32, _ as UInt64, _ as Float, _ as Double, _ as CGFloat: .number
            // String
        case _ as String, _ as NSString: .string
            // Array
        case _ as [Any], _ as NSArray: .array
            // Object
        case _ as [String: Any]: .dictionary
            // Unsupported
        default:
            nil
        }
    }
    
    private static func encode(number num: UInt64, isPositive: Bool, to data: SMBitDataWriter) throws {
        let sign = isPositive == true ? BitDataConstants.Number.signPositive : BitDataConstants.Number.signNegative
        
        if num == 0 {
            data.writeTypeSignature(.numberZero)
        }
        else if num <= BitDataConstants.Number.digitsMaxValue {
            try self.encode(digits: (isPositive ? "" : "-") + String(num), to: data)
        }
        else if num <= BitDataConstants.Number.bits16MaxValue {
            data.writeTypeSignature(.number16Bits)
            data.writeBit(sign)
            data.writeBytes(UInt16(num))
        }
        else if num <= BitDataConstants.Number.bits24MaxValue {
            data.writeTypeSignature(.number24Bits)
            data.writeBit(sign)
            data.writeUInt24(UInt32(num))
        }
        else if num <= BitDataConstants.Number.bits32MaxValue {
            data.writeTypeSignature(.number32Bits)
            data.writeBit(sign)
            data.writeBytes(UInt32(num))
        }
        else if num <= BitDataConstants.Number.bits64MaxValue {
            data.writeTypeSignature(.number64Bits)
            data.writeBit(sign)
            data.writeBytes(UInt64(num))
        }
        else {
            throw BitDataEncodingError.invalidNumber
        }
    }
    
    private static func encode(digits string: String, to data: SMBitDataWriter) throws {
        data.writeTypeSignature(.numberDigits)
        return try self.encode(string: string, with: BitDataConstants.Number.digitsAlphabet, to: data)
    }
    
    private static func encode(string: String, to data: SMBitDataWriter) throws {
        guard string.isEmpty == false else {
            data.writeTypeSignature(.stringEmpty)
            return
        }
        
        let alphabets: [(type: BitDataSecondType, alphabet: BitDataAlphabet)] = [
            (.stringDigits, BitDataConstants.String.digitsAlphabet),
            (.stringLowercased, BitDataConstants.String.lowercasedAlphabet),
            (.stringUppercased, BitDataConstants.String.uppercasedAlphabet),
            (.stringCombined, BitDataConstants.String.combinedAlphabet),
            (.stringASCII, BitDataConstants.String.asciiAlphabet)
        ].sorted { a, b in
            a.alphabet.charactersSet.count < b.alphabet.charactersSet.count
        }
        
        var match: (type: BitDataSecondType, alphabet: BitDataAlphabet)? = nil
        let requiredCharacters = Set(string)
        
        for (dataSecondType, alphabet) in alphabets {
            if requiredCharacters.isSubset(of: alphabet.charactersSet) {
                match = (dataSecondType, alphabet)
                break
            }
        }
        
        guard let (dataSecondType, alphabet) = match else {
            // UTF8 encoding
            data.writeTypeSignature(.stringUTF8)
            guard let stringData = string.data(using: .utf8) else {
                throw BitDataEncodingError.unableToConvertToUTF8String(string)
            }
            let stringLength = stringData.count
            if stringLength < 16 {
                data.writeBits(BitDataConstants.String.length4Bits, count: BitDataConstants.String.lengthSizeInBits)
                data.writeBits(UInt8(stringLength), count: 4)
            }
            else if stringLength < 256 {
                data.writeBits(BitDataConstants.String.length8Bits, count: BitDataConstants.String.lengthSizeInBits)
                data.writeBits(UInt8(stringLength), count: 8)
            }
            else if stringLength < 4096 {
                data.writeBits(BitDataConstants.String.length12Bits, count: BitDataConstants.String.lengthSizeInBits)
                data.writeUInt12(UInt16(stringLength))
            }
            else if stringLength < 65536 {
                data.writeBits(BitDataConstants.String.length16Bits, count: BitDataConstants.String.lengthSizeInBits)
                data.writeBytes(UInt16(stringLength))
            }
            else {
                throw BitDataEncodingError.stringIsTooLong(stringLength)
            }
            data.writeData(stringData)
            return
        }
        
        data.writeTypeSignature(dataSecondType)
        try self.encode(string: string, with: alphabet, to: data)
    }
    
    static private func encode(string: String, with alphabet: BitDataAlphabet, to data: SMBitDataWriter) throws {
        for char in string {
            if let bits = alphabet.characters[char] {
                data.writeBits(bits, count: alphabet.characterSizeInBits)
            }
            else {
                throw BitDataEncodingError.unsupportedCharacter(char)
            }
        }
        data.writeBits(alphabet.closeCharacter, count: alphabet.closeCharacterSizeInBits)
    }
    
    static private func encode(array: [Any], to data: SMBitDataWriter) throws {
        let (count, sameValueType, useSeparator) = try self.encode(collection: array, to: data)
        
        for i in 0..<count {
            try self.encode(object: array[i], includeType: !sameValueType || i == 0, to: data)
            if useSeparator {
                data.writeBit(i == count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
    
    static private func encode(dictionary: [String: Any], to data: SMBitDataWriter) throws {
        let (count, sameValueType, useSeparator) = try self.encode(collection: Array(dictionary.values), to: data)
        
        for (index, (key, value)) in dictionary.enumerated() {
            try self.encode(string: key, to: data)
            if index == 0 {
                guard let type = self.dataType(of: value) else {
                    throw BitDataEncodingError.unsupportedType
                }
                data.writeTypeSignature(type)
            }
            try self.encode(object: value, includeType: !sameValueType && index > 0, to: data)
            if useSeparator {
                data.writeBit(index == count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
    
    private static func encode(collection: [Any], to data: SMBitDataWriter) throws -> (count: Int, sameValueType: Bool, useSeparator: Bool) {
        let count = collection.count
        let useSeparator = count >= 2 && count <= BitDataConstants.Collection.maxSizeForUsingSeparator
        var sameValueType = true

        if count > 1 {
            for i in 1..<count {
                if self.dataType(of: collection[i]) != self.dataType(of: collection[0]) {
                    sameValueType = false
                    break
                }
            }
        }
        
        switch count {
        case 0:
            data.writeTypeSignature(.collectionEmpty)
        case 1:
            data.writeTypeSignature(.collectionSingle)
        case 2...BitDataConstants.Collection.maxSizeForUsingSeparator:
            data.writeTypeSignature(.collectionSeparator)
            data.writeBit(sameValueType == true ? BitDataConstants.Collection.sameValueType : BitDataConstants.Collection.differentValueTypes)
        case 9..<256:
            data.writeTypeSignature(.collection8BitsSize)
            data.writeByte(UInt8(count))
            data.writeBit(sameValueType == true ? BitDataConstants.Collection.sameValueType : BitDataConstants.Collection.differentValueTypes)
        case 256..<4096:
            data.writeTypeSignature(.collection12BitsSize)
            data.writeUInt12(UInt16(count))
            data.writeBit(sameValueType == true ? BitDataConstants.Collection.sameValueType : BitDataConstants.Collection.differentValueTypes)
        case 4096..<65536:
            data.writeTypeSignature(.collection16BitsSize)
            data.writeBytes(UInt16(count))
            data.writeBit(sameValueType == true ? BitDataConstants.Collection.sameValueType : BitDataConstants.Collection.differentValueTypes)
        default:
            throw BitDataEncodingError.unsupportedCollectionSize(count)
        }
        
        return (count, sameValueType, useSeparator)
    }
    
    private static func decode(from data: SMBitDataReader, as forcedDataType: BitDataType?) throws -> Any {
        let dataType: BitDataType
        if let forcedDataType {
            dataType = forcedDataType
        }
        else {
            let bits = try data.readBits(BitDataType.sizeInBits)
            guard let dt = BitDataType(bits: bits) else {
                throw BitDataDecodingError.unsupportedType
            }
            dataType = dt
        }
        
        let bits = try data.readBits(dataType.secondaryTypeSizeInBits)
        guard let secondDataType = BitDataSecondType(type: dataType, bits: bits) else {
            throw BitDataDecodingError.unsupportedSecondaryType
        }
        
        switch dataType {
        case .primitive:
            return try self.decodePrimitive(from: data, as: secondDataType)
        case .number:
            return try self.decodeNumber(from: data, as: secondDataType)
        case .string:
            return try self.decodeString(from: data, as: secondDataType)
        case .array:
            return try self.decodeArray(from: data, as: secondDataType)
        case .dictionary:
            return try self.decodeDictionary(from: data, as: secondDataType)
        }
    }
    
    private static func decodePrimitive(from data: SMBitDataReader, as secondDataType: BitDataSecondType) throws -> Any {
        switch secondDataType {
        case .primitiveNull:
            return NSNull()
        case .primitiveTrue:
            return true
        case .primitiveFalse:
            return false
        default:
            throw BitDataDecodingError.unsupportedSecondaryType
        }
    }
    
    private static func decodeNumber(from data: SMBitDataReader, as secondDataType: BitDataSecondType) throws -> Any {
        switch secondDataType {
        case .numberZero:
            return 0
        case .numberDigits:
            return try self.decodeDigits(from: data)
        case .number16Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let bytes = try data.readBytes(2)
            let rawValue = UInt16(bytes[0]) << 8 | UInt16(bytes[1])
            return isPositive ? Int(rawValue) : -Int(rawValue)
        case .number24Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let bytes = try data.readBytes(3)
            let rawValue = UInt32(bytes[0]) << 16 | UInt32(bytes[1]) << 8 | UInt32(bytes[2])
            return isPositive ? Int(rawValue) : -Int(rawValue)
        case .number32Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let bytes = try data.readBytes(4)
            let rawValue = UInt32(bytes[0]) << 24 | UInt32(bytes[1]) << 16 | UInt32(bytes[2]) << 8 | UInt32(bytes[3])
            return isPositive ? Int(rawValue) : -Int(rawValue)
        case .number64Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let bytes = try data.readBytes(8)
            let rawValue = UInt64(bytes[0]) << 56 |
                           UInt64(bytes[1]) << 48 |
                           UInt64(bytes[2]) << 40 |
                           UInt64(bytes[3]) << 32 |
                           UInt64(bytes[4]) << 24 |
                           UInt64(bytes[5]) << 16 |
                           UInt64(bytes[6]) << 8  |
                           UInt64(bytes[7])
            if rawValue <= Int.max {
                return isPositive ? Int(rawValue) : -Int(rawValue)
            }
            else if isPositive {
                return UInt(rawValue)
            }
            else if #available(macOS 15.0, iOS 18.0, *) {
                return -Int128(rawValue)
            }
            else {
                throw BitDataDecodingError.invalidNumber
            }
        default:
            throw BitDataDecodingError.unsupportedSecondaryType
        }
    }
    
    private static func decodeDigits(from data: SMBitDataReader) throws -> Any {
        let string = try self.decodeString(from: data, with: BitDataConstants.Number.digitsAlphabet)
        
        if let value = Int(string) {
            return value
        } else if let value = UInt(string) {
            return value
        } else if let value = Double(string) {
            return value
        }
        
        throw BitDataDecodingError.invalidNumberString(string)
    }
    
    private static func decodeString(from data: SMBitDataReader, as forcedSecondDataType: BitDataSecondType?) throws -> String {
        let secondDataType: BitDataSecondType
        if let forcedSecondDataType {
            secondDataType = forcedSecondDataType
        }
        else {
            let bits = try data.readBits(BitDataType.string.secondaryTypeSizeInBits)
            guard let dt = BitDataSecondType(type: .string, bits: bits) else {
                throw BitDataDecodingError.unsupportedSecondaryType
            }
            secondDataType = dt
        }
        
        switch secondDataType {
        case .stringEmpty:
            return ""
        case .stringDigits:
            return try self.decodeString(from: data, with: BitDataConstants.String.digitsAlphabet)
        case .stringLowercased:
            return try self.decodeString(from: data, with: BitDataConstants.String.lowercasedAlphabet)
        case .stringUppercased:
            return try self.decodeString(from: data, with: BitDataConstants.String.uppercasedAlphabet)
        case .stringCombined:
            return try self.decodeString(from: data, with: BitDataConstants.String.combinedAlphabet)
        case .stringASCII:
            return try self.decodeString(from: data, with: BitDataConstants.String.asciiAlphabet)
        case .stringUTF8:
            let stringLengthInBits = try data.readBits(BitDataConstants.String.lengthSizeInBits)
            let stringLength: Int
            switch stringLengthInBits {
            case BitDataConstants.String.length4Bits:
                let rawValue = try data.readBits(4)
                stringLength = Int(rawValue)
            case BitDataConstants.String.length8Bits:
                let rawValue = try data.readByte()
                stringLength = Int(rawValue)
            case BitDataConstants.String.length12Bits:
                let firstByte = try data.readByte()
                let secondByte = try data.readBits(4)
                stringLength = Int(firstByte) << 4 | Int(secondByte)
            case BitDataConstants.String.length16Bits:
                let firstByte = try data.readByte()
                let secondByte = try data.readByte()
                stringLength = Int(UInt16(firstByte) << 8 | UInt16(secondByte))
            default:
                throw BitDataDecodingError.unsupportedThirdType
            }
            let stringData = try data.readData(length: stringLength)
            guard let string = String(data: stringData, encoding: .utf8) else {
                throw BitDataDecodingError.failedToReadUTF8String
            }
            return string
        default:
            throw BitDataDecodingError.unsupportedSecondaryType
        }
    }
    
    private static func decodeString(from data: SMBitDataReader, with alphabet: BitDataAlphabet) throws -> String {
        var string = ""
        var endOfStringFound = false
        
        while endOfStringFound == false {
            var bits = try data.readBits(alphabet.closeCharacterSizeInBits)
            guard bits != alphabet.closeCharacter else {
                endOfStringFound = true
                continue
            }
            let leftBitsToRead = alphabet.characterSizeInBits - alphabet.closeCharacterSizeInBits
            let tmp = try data.readBits(leftBitsToRead)
            bits = (bits << leftBitsToRead) | tmp
            guard let character = alphabet.charactersReversed[bits] else {
                throw BitDataDecodingError.unsupportedCharacter(bits)
            }
            string.append(character)
        }
        
        return string
    }
    
    static private func decodeArray(from data: SMBitDataReader, as secondDataType: BitDataSecondType) throws -> [Any] {
        guard secondDataType != .collectionEmpty else {
            return []
        }
        
        let (count, sameValueType) = try self.decodeCollection(from: data, as: secondDataType)
        let useSeparator = secondDataType == .collectionSeparator
        
        var array = [Any]()
        var finished = false
        var dataType: BitDataType? = nil
        
        if let count {
            array.reserveCapacity(count)
        }
        else if useSeparator {
            array.reserveCapacity(BitDataConstants.Collection.maxSizeForUsingSeparator)
        }
        
        while finished == false {
            if dataType == nil {
                let dataTypeRaw = try data.readBits(BitDataType.sizeInBits)
                guard let dt = BitDataType(bits: dataTypeRaw) else {
                    throw BitDataDecodingError.unsupportedType
                }
                dataType = dt
            }
            let element = try self.decode(from: data, as: dataType)
            array.append(element)
            if sameValueType == false {
                dataType = nil // Reset type for next element
            }
            if useSeparator {
                finished = try data.readBit() == BitDataConstants.Collection.separatorLastElement
            }
            else if let count {
                finished = array.count == count
            }
        }
        
        return array
    }
    
    static private func decodeDictionary(from data: SMBitDataReader, as secondDataType: BitDataSecondType) throws -> [String: Any] {
        guard secondDataType != .collectionEmpty else {
            return [:]
        }
        
        let (count, sameValueType) = try self.decodeCollection(from: data, as: secondDataType)
        let useSeparator = secondDataType == .collectionSeparator
        
        var dictionary = [String: Any]()
        var finished = false
        var firstValueDataType: BitDataType? = nil
        
        if let count {
            dictionary.reserveCapacity(count)
        }
        else if useSeparator {
            dictionary.reserveCapacity(BitDataConstants.Collection.maxSizeForUsingSeparator)
        }
        
        while finished == false {
            let key = try self.decodeString(from: data, as: nil)
            if firstValueDataType == nil {
                let dataTypeRaw = try data.readBits(BitDataType.sizeInBits)
                guard let dt = BitDataType(bits: dataTypeRaw) else {
                    throw BitDataDecodingError.unsupportedType
                }
                firstValueDataType = dt
            }
            let element = try self.decode(from: data, as: sameValueType || dictionary.isEmpty ? firstValueDataType : nil)
            dictionary[key] = element

            if useSeparator {
                finished = try data.readBit() == BitDataConstants.Collection.separatorLastElement
            }
            else if let count {
                finished = dictionary.count == count
            }
        }
        
        return dictionary
    }
    
    private static func decodeCollection(from data: SMBitDataReader, as secondDataType: BitDataSecondType) throws -> (count: Int?, sameValueType: Bool) {
        let count: Int?
        let sameValueType: Bool
        switch secondDataType {
        case .collectionSingle:
            count = 1
            sameValueType = true
        case .collectionSeparator:
            count = nil
            sameValueType = try data.readBit() == 1
        case .collection8BitsSize:
            let rawCount = try data.readByte()
            count = Int(rawCount)
            sameValueType = try data.readBit() == 1
        case .collection12BitsSize:
            let firstByte = try data.readBits(4)
            let lastByte = try data.readByte()
            count = Int(UInt16(firstByte) << 8 | UInt16(lastByte))
            sameValueType = try data.readBit() == 1
        case .collection16BitsSize:
            let firstByte = try data.readByte()
            let lastByte = try data.readByte()
            count = Int(UInt16(firstByte) << 8 | UInt16(lastByte))
            sameValueType = try data.readBit() == 1
        default:
            throw BitDataDecodingError.unsupportedSecondaryType
        }
        
        return (count, sameValueType)
    }
        
    
}

extension SMBitDataWriter {
    func writeTypeSignature(_ type: BitDataType) {
        self.writeBits(type.bits, count: BitDataType.sizeInBits)
    }
    
    func writeTypeSignature(_ type: BitDataSecondType) {
        self.writeBits(type.bits, count: type.sizeInBits)
    }
    
    func writeUInt12(_ value: UInt16) {
        self.writeBits(UInt8(value >> 8), count: 4)
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeUInt24(_ value: UInt32) {
        self.writeBits(UInt8((value & 0x00FF0000) >> 16), count: 8)
        self.writeBits(UInt8((value & 0x0000FF00) >> 8), count: 8)
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeBytes(_ value: UInt16) {
        self.writeByte(UInt8(value >> 8))
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeBytes(_ value: UInt32) {
        self.writeByte(UInt8(value >> 24))
        self.writeByte(UInt8((value & 0x00FF0000) >> 16))
        self.writeByte(UInt8((value & 0x0000FF00) >> 8))
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeBytes(_ value: UInt64) {
        self.writeByte(UInt8(value >> 56))
        self.writeByte(UInt8((value & 0x00FF000000000000) >> 48))
        self.writeByte(UInt8((value & 0x0000FF0000000000) >> 40))
        self.writeByte(UInt8((value & 0x000000FF00000000) >> 32))
        self.writeByte(UInt8((value & 0x00000000FF000000) >> 24))
        self.writeByte(UInt8((value & 0x0000000000FF0000) >> 16))
        self.writeByte(UInt8((value & 0x000000000000FF00) >> 8))
        self.writeByte(UInt8(value & 0xFF))
    }
}
