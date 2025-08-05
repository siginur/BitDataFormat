//
//  BDFSerialization+Encode.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import Foundation
import SMBitData

extension BDFSerialization {
    static func encode(object: Any?, includeType: Bool, to data: SMBitDataWriter) throws {
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
    
    static func encode(number num: UInt64, isPositive: Bool, to data: SMBitDataWriter) throws {
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
            throw BitDataEncodingError.numberIsTooBig
        }
    }
    
    static func encode(digits string: String, to data: SMBitDataWriter) throws {
        data.writeTypeSignature(.numberDigits)
        return try self.encode(string: string, with: BitDataConstants.Number.digitsAlphabet, to: data)
    }
    
    static func encode(string: String, to data: SMBitDataWriter) throws {
        guard string.isEmpty == false else {
            data.writeTypeSignature(.stringEmpty)
            return
        }
        
        let alphabets: [(type: BitDataSubType, alphabet: BitDataAlphabet)] = [
            (.stringDigits, BitDataConstants.String.digitsAlphabet),
            (.stringLowercased, BitDataConstants.String.lowercasedAlphabet),
            (.stringUppercased, BitDataConstants.String.uppercasedAlphabet),
            (.stringCombined, BitDataConstants.String.combinedAlphabet),
            (.stringASCII, BitDataConstants.String.asciiAlphabet)
        ].sorted { a, b in
            a.alphabet.charactersSet.count < b.alphabet.charactersSet.count
        }
        
        var match: (type: BitDataSubType, alphabet: BitDataAlphabet)? = nil
        let requiredCharacters = Set(string)
        
        for (dataSubType, alphabet) in alphabets {
            if requiredCharacters.isSubset(of: alphabet.charactersSet) {
                match = (dataSubType, alphabet)
                break
            }
        }
        
        guard let (dataSubType, alphabet) = match else {
            // UTF8 encoding
            data.writeTypeSignature(.stringUTF8)
            guard let stringData = string.data(using: .utf8) else {
                throw BitDataEncodingError.failedToEncodeUTF8String(string)
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
        
        data.writeTypeSignature(dataSubType)
        try self.encode(string: string, with: alphabet, to: data)
    }
    
    static func encode(string: String, with alphabet: BitDataAlphabet, to data: SMBitDataWriter) throws {
        for char in string {
            if let bits = alphabet.characters[char] {
                data.writeBits(bits, count: alphabet.characterSizeInBits)
            }
            else {
                throw BitDataEncodingError.characterNotFoundInAlphabet(char)
            }
        }
        data.writeBits(alphabet.closeCharacter, count: alphabet.closeCharacterSizeInBits)
    }
    
    static func encode(array: [Any], to data: SMBitDataWriter) throws {
        let (count, sameValueType, useSeparator) = try self.encode(collection: array, to: data)
        
        for i in 0..<count {
            try self.encode(object: array[i], includeType: !sameValueType || i == 0, to: data)
            if useSeparator {
                data.writeBit(i == count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
    
    static func encode(dictionary: [String: Any], to data: SMBitDataWriter) throws {
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
    
    static func encode(collection: [Any], to data: SMBitDataWriter) throws -> (count: Int, sameValueType: Bool, useSeparator: Bool) {
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
            throw BitDataEncodingError.collectionIsTooBig(count)
        }
        
        return (count, sameValueType, useSeparator)
    }
}
