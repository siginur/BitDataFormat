//
//  BDFArchiveReadable.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 13/08/2025.
//

import Foundation

public protocol BDFArchiveReadable {
    init(from archive: any BDFArchiveReader) throws
}

// MARK: - Primitives

extension Bool: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        guard let value = try BDFSerialization.decodePrimitive(from: archive.bitDataReader, as: nil) as? Bool else {
            throw BitDataDecodingError.typeMissmatch
        }
        self = value
    }
}

// MARK: - Numbers

// Default implementation for all fixed-width integers (both signed and unsigned)
extension BDFArchiveReadable where Self: FixedWidthInteger {
    public init(from archive: any BDFArchiveReader) throws {
        guard let value = try BDFSerialization.decodeNumber(from: archive.bitDataReader, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        self = Self(value)
    }
}

// Conform all signed integer types to BDFArchiveDecodable
extension Int:   BDFArchiveReadable {}
extension Int8:  BDFArchiveReadable {}
extension Int16: BDFArchiveReadable {}
extension Int32: BDFArchiveReadable {}
extension Int64: BDFArchiveReadable {}

// Conform all unsigned integer types to BDFArchiveDecodable
//extension UInt:   BDFArchiveDecodable {}
extension UInt8:  BDFArchiveReadable {}
extension UInt16: BDFArchiveReadable {}
extension UInt32: BDFArchiveReadable {}
//extension UInt64:   BDFArchiveDecodable {}

extension UInt: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let rawValue = try BDFSerialization.decodeNumber(from: archive.bitDataReader, as: nil)
        if let value = rawValue as? Int {
            self = UInt(value)
            return
        }
        else if let value = rawValue as? UInt {
            self = UInt(value)
            return
        }
        throw BitDataDecodingError.typeMissmatch
    }
}

extension UInt64: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let rawValue = try BDFSerialization.decodeNumber(from: archive.bitDataReader, as: nil)
        if let value = rawValue as? Int {
            self = UInt64(value)
            return
        }
        else if let value = rawValue as? UInt {
            self = UInt64(value)
            return
        }
        throw BitDataDecodingError.typeMissmatch
    }
}

extension Float: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let rawValue = try BDFSerialization.decodeNumber(from: archive.bitDataReader, as: nil)
        guard let value = Float(fromAny: rawValue) else {
            throw BitDataDecodingError.typeMissmatch
        }
        self = value
    }
}

extension Double: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let rawValue = try BDFSerialization.decodeNumber(from: archive.bitDataReader, as: nil)
        guard let value = Double(fromAny: rawValue) else {
            throw BitDataDecodingError.typeMissmatch
        }
        self = value
    }
}

extension CGFloat: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let rawValue = try BDFSerialization.decodeNumber(from: archive.bitDataReader, as: nil)
        guard let value = CGFloat(fromAny: rawValue) else {
            throw BitDataDecodingError.typeMissmatch
        }
        self = value
    }
}

// MARK: - String

extension String: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        self = try BDFSerialization.decodeString(from: archive.bitDataReader, as: nil)
    }
}

// MARK: - Date

extension Date: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        self = try BDFSerialization.decodeDate(from: archive.bitDataReader, as: nil)
    }
}

// MARK: - Array

extension Array: BDFArchiveReadable, BDFArchiveCollection where Element: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let (count, useSeparator) = try Self.decodeCollection(from: archive.bitDataReader, dataType: .array)
        
        var array = [Element]()
        var finished = count == 0
        
        if let count {
            array.reserveCapacity(count)
        }
        else if useSeparator {
            array.reserveCapacity(BitDataConstants.Collection.maxSizeForUsingSeparator)
        }
        
        while finished == false {
            let element = try Element(from: archive)
            array.append(element)
            if useSeparator {
                finished = try archive.bitDataReader.readBit() == BitDataConstants.Collection.separatorLastElement
            }
            else if let count {
                finished = array.count == count
            }
        }
        
        self = array
    }
}

// MARK: - Dictionary

extension Dictionary: BDFArchiveReadable, BDFArchiveCollection where Key == String, Value: BDFArchiveReadable {
    public init(from archive: any BDFArchiveReader) throws {
        let (count, useSeparator) = try Self.decodeCollection(from: archive.bitDataReader, dataType: .dictionary)
        
        var dictionary = [String: Value]()
        var finished = count == 0
        
        if let count {
            dictionary.reserveCapacity(count)
        }
        else if useSeparator {
            dictionary.reserveCapacity(BitDataConstants.Collection.maxSizeForUsingSeparator)
        }
        
        while finished == false {
            let key = try BDFSerialization.decodeString(from: archive.bitDataReader, as: nil)
            let element = try Value(from: archive)
            dictionary[key] = element

            if useSeparator {
                finished = try archive.bitDataReader.readBit() == BitDataConstants.Collection.separatorLastElement
            }
            else if let count {
                finished = dictionary.count == count
            }
        }
        
        self = dictionary
    }
}

// MARK: - Helper Protocols

import SMBitData

protocol BDFArchiveCollection {
    static func decodeCollection(from: SMBitDataReader, dataType: BitDataType) throws -> (count: Int?, useSeparator: Bool)
}

extension BDFArchiveCollection {
    static func decodeCollection(from data: SMBitDataReader, dataType: BitDataType) throws -> (count: Int?, useSeparator: Bool) {
        guard let dataSubType = try data.readDataSubTypeSignature(for: dataType) else {
            throw BitDataDecodingError.unknownBitDataSubType
        }

        let count: Int?
        switch dataSubType {
        case .collectionEmpty:
            count = 0
        case .collectionSingle:
            count = 1
        case .collectionSeparator:
            count = nil
        case .collection8BitsSize:
            let rawCount = try data.readByte()
            count = Int(rawCount)
        case .collection12BitsSize:
            let firstByte = try data.readBits(4)
            let lastByte = try data.readByte()
            count = Int(UInt16(firstByte) << 8 | UInt16(lastByte))
        case .collection16BitsSize:
            let firstByte = try data.readByte()
            let lastByte = try data.readByte()
            count = Int(UInt16(firstByte) << 8 | UInt16(lastByte))
        default:
            throw BitDataDecodingError.unknownBitDataSubType
        }
        let useSeparator = dataSubType == .collectionSeparator
        return (count, useSeparator)
    }
}
