//
//  BitDataType.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import Foundation

enum BitDataType {
    case primitive
    case number
    case string
    case array
    case dictionary
    
    static let sizeInBits: UInt8 = 3
    
    var subTypeSizeInBits: UInt8 {
        switch self {
        case .primitive:
            return BitDataSubType.primitiveNull.sizeInBits
        case .number:
            return BitDataSubType.numberZero.sizeInBits
        case .string:
            return BitDataSubType.stringEmpty.sizeInBits
        case .array, .dictionary:
            return BitDataSubType.collectionEmpty.sizeInBits
        }
    }
    
    var subTypes: Set<BitDataSubType> {
        switch self {
        case .primitive:
            return [.primitiveNull, .primitiveTrue, .primitiveFalse]
        case .number:
            return [.numberZero, .numberDigits, .number16Bits, .number24Bits, .number32Bits, .number64Bits]
        case .string:
            return [.stringEmpty, .stringDigits, .stringLowercased, .stringUppercased, .stringCombined, .stringASCII, .stringUTF8]
        case .array, .dictionary:
            return [.collectionEmpty, .collectionSingle, .collectionSeparator, .collection8BitsSize, .collection12BitsSize, .collection16BitsSize]
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
    
    init?(object: Any?) {
        switch object {
            // Primitive
        case _ as Bool, _ as NSNull, nil:
            self = .primitive
            // Number
        case _ as Int, _ as Int8, _ as Int16, _ as Int32, _ as Int64, _ as UInt, _ as UInt8, _ as UInt16, _ as UInt32, _ as UInt64, _ as Float, _ as Double, _ as CGFloat:
            self = .number
            // String
        case _ as String, _ as NSString:
            self = .string
            // Array
        case _ as [Any], _ as NSArray:
            self = .array
            // Object
        case _ as [String: Any]:
            self = .dictionary
            // Unsupported
        default:
            return nil
        }
    }
}

enum BitDataSubType {
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
