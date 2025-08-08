//
//  BDFSerialization+Decode.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import Foundation
import SMBitData

extension BDFSerialization {
    
    static func decode(from data: SMBitDataReader, as forcedDataType: BitDataType?) throws -> Any {
        let dataType: BitDataType
        if let forcedDataType {
            dataType = forcedDataType
        }
        else {
            guard let dt = try data.readDataTypeSignature() else {
                throw BitDataDecodingError.unknownBitDataType
            }
            dataType = dt
        }
        
        let bits = try data.readBits(dataType.subTypeSizeInBits)
        guard let dataSubType = BitDataSubType(type: dataType, bits: bits) else {
            throw BitDataDecodingError.unknownBitDataSubType
        }
        
        switch dataType {
        case .primitive:
            return try self.decodePrimitive(from: data, as: dataSubType)
        case .number:
            return try self.decodeNumber(from: data, as: dataSubType)
        case .string:
            return try self.decodeString(from: data, as: dataSubType)
        case .date:
            return try self.decodeDate(from: data, as: dataSubType)
        case .array:
            return try self.decodeArray(from: data, as: dataSubType)
        case .dictionary:
            return try self.decodeDictionary(from: data, as: dataSubType)
        }
    }
    
    static func decodePrimitive(from data: SMBitDataReader, as dataSubType: BitDataSubType) throws -> Any {
        switch dataSubType {
        case .primitiveNull:
            return NSNull()
        case .primitiveTrue:
            return true
        case .primitiveFalse:
            return false
        default:
            throw BitDataDecodingError.unknownBitDataSubType
        }
    }
    
    static func decodeNumber(from data: SMBitDataReader, as dataSubType: BitDataSubType) throws -> Any {
        switch dataSubType {
        case .numberZero:
            return 0
        case .numberDigits:
            return try self.decodeDigits(from: data)
        case .number16Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let rawValue = try data.readUInt16()
            return isPositive ? Int(rawValue) : -Int(rawValue)
        case .number24Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let rawValue = try data.readUInt24()
            return isPositive ? Int(rawValue) : -Int(rawValue)
        case .number32Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let rawValue = try data.readUInt32()
            return isPositive ? Int(rawValue) : -Int(rawValue)
        case .number64Bits:
            let isPositive = try data.readBit() == BitDataConstants.Number.signPositive
            let rawValue = try data.readUInt64()
            if rawValue <= Int.max {
                return isPositive ? Int(rawValue) : -Int(rawValue)
            }
            else if isPositive {
                return UInt(rawValue)
            }
            else if #available(iOS 18.0, watchOS 11.0, macOS 15.0, macCatalyst 18.0, tvOS 18.0, visionOS 2.0, *) {
                return -Int128(rawValue)
            }
            else {
                throw BitDataDecodingError.numberIsTooBig
            }
        default:
            throw BitDataDecodingError.unknownBitDataSubType
        }
    }
    
    static func decodeDigits(from data: SMBitDataReader) throws -> Any {
        let string = try self.decodeString(from: data, with: BitDataConstants.Number.digitsAlphabet)
        
        if let value = Int(string) {
            return value
        } else if let value = UInt(string) {
            return value
        } else if let value = Double(string) {
            return value
        }
        
        throw BitDataDecodingError.failedToDecodeNumber(string)
    }
    
    static func decodeString(from data: SMBitDataReader, as predefinedDataSubType: BitDataSubType?) throws -> String {
        let dataSubType: BitDataSubType
        if let predefinedDataSubType {
            dataSubType = predefinedDataSubType
        }
        else {
            let bits = try data.readBits(BitDataType.string.subTypeSizeInBits)
            guard let dt = BitDataSubType(type: .string, bits: bits) else {
                throw BitDataDecodingError.unknownBitDataSubType
            }
            dataSubType = dt
        }
        
        switch dataSubType {
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
                throw BitDataDecodingError.unknownBitDataSubType
            }
            let stringData = try data.readData(length: stringLength)
            guard let string = String(data: stringData, encoding: .utf8) else {
                throw BitDataDecodingError.failedToDecodeUTF8String
            }
            return string
        default:
            throw BitDataDecodingError.unknownBitDataSubType
        }
    }
    
    static func decodeString(from data: SMBitDataReader, with alphabet: BitDataAlphabet) throws -> String {
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
                throw BitDataDecodingError.characterNotFoundInAlphabet(bits)
            }
            string.append(character)
        }
        
        return string
    }
    
    static func decodeDate(from data: SMBitDataReader, as dataSubType: BitDataSubType) throws -> Date {
        switch dataSubType {
        case .dateInSeconds:
            let seconds = try data.readUInt32()
            return Date(timeIntervalSince1970: TimeInterval(seconds))
        case .dateInMilliseconds:
            var milliseconds = UInt64(try data.readUInt32())
            milliseconds <<= 10
            milliseconds |= UInt64(try data.readByte()) << 2
            milliseconds |= UInt64(try data.readBits(2))
            return Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000.0)
        default:
            throw BitDataDecodingError.unknownBitDataSubType
        }
    }
    
    static func decodeArray(from data: SMBitDataReader, as dataSubType: BitDataSubType) throws -> [Any] {
        guard dataSubType != .collectionEmpty else {
            return []
        }
        
        let (count, sameValueType) = try self.decodeCollection(from: data, as: dataSubType)
        let useSeparator = dataSubType == .collectionSeparator
        
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
                guard let dt = try data.readDataTypeSignature() else {
                    throw BitDataDecodingError.unknownBitDataType
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
    
    static func decodeDictionary(from data: SMBitDataReader, as dataSubType: BitDataSubType) throws -> [String: Any] {
        guard dataSubType != .collectionEmpty else {
            return [:]
        }
        
        let (count, sameValueType) = try self.decodeCollection(from: data, as: dataSubType)
        let useSeparator = dataSubType == .collectionSeparator
        
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
                guard let dt = try data.readDataTypeSignature() else {
                    throw BitDataDecodingError.unknownBitDataType
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
    
    static func decodeCollection(from data: SMBitDataReader, as dataSubType: BitDataSubType) throws -> (count: Int?, sameValueType: Bool) {
        let count: Int?
        let sameValueType: Bool
        switch dataSubType {
        case .collectionSingle:
            count = 1
            sameValueType = true
        case .collectionSeparator:
            count = nil
            sameValueType = try data.readBit() == BitDataConstants.Collection.sameValueType
        case .collection8BitsSize:
            let rawCount = try data.readByte()
            count = Int(rawCount)
            sameValueType = try data.readBit() == BitDataConstants.Collection.sameValueType
        case .collection12BitsSize:
            let firstByte = try data.readBits(4)
            let lastByte = try data.readByte()
            count = Int(UInt16(firstByte) << 8 | UInt16(lastByte))
            sameValueType = try data.readBit() == BitDataConstants.Collection.sameValueType
        case .collection16BitsSize:
            let firstByte = try data.readByte()
            let lastByte = try data.readByte()
            count = Int(UInt16(firstByte) << 8 | UInt16(lastByte))
            sameValueType = try data.readBit() == BitDataConstants.Collection.sameValueType
        default:
            throw BitDataDecodingError.unknownBitDataSubType
        }
        
        return (count, sameValueType)
    }
}
