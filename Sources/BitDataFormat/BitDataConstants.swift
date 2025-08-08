//
//  BitDataConstants.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

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
