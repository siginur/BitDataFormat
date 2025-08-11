//
//  BDFSchemaDecoder.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 11/08/2025.
//

import Foundation
import SMBitData

public protocol BDFSchemaDecodable {
    init(from decoder: any BDFSchemaDecoder) throws
}

public protocol BDFSchemaDecoder {
    func decode() throws -> Bool
    func decode() throws -> Int
    func decode() throws -> Int8
    func decode() throws -> Int16
    func decode() throws -> Int32
    func decode() throws -> Int64
    func decode() throws -> UInt
    func decode() throws -> UInt8
    func decode() throws -> UInt16
    func decode() throws -> UInt32
    func decode() throws -> UInt64
    func decode() throws -> Float
    func decode() throws -> Double
    func decode() throws -> CGFloat
    func decode() throws -> String
    func decode() throws -> Date
    func decode() throws -> [Bool]
    func decode() throws -> [Int]
    func decode() throws -> [Int8]
    func decode() throws -> [Int16]
    func decode() throws -> [Int32]
    func decode() throws -> [Int64]
    func decode() throws -> [UInt]
    func decode() throws -> [UInt8]
    func decode() throws -> [UInt16]
    func decode() throws -> [UInt32]
    func decode() throws -> [UInt64]
    func decode() throws -> [Float]
    func decode() throws -> [Double]
    func decode() throws -> [CGFloat]
    func decode() throws -> [String]
    func decode() throws -> [Date]
    func decode() throws -> [String: Bool]
    func decode() throws -> [String: Int]
    func decode() throws -> [String: Int8]
    func decode() throws -> [String: Int16]
    func decode() throws -> [String: Int32]
    func decode() throws -> [String: Int64]
    func decode() throws -> [String: UInt]
    func decode() throws -> [String: UInt8]
    func decode() throws -> [String: UInt16]
    func decode() throws -> [String: UInt32]
    func decode() throws -> [String: UInt64]
    func decode() throws -> [String: Float]
    func decode() throws -> [String: Double]
    func decode() throws -> [String: CGFloat]
    func decode() throws -> [String: String]
    func decode() throws -> [String: Date]
    func decodeIfPresent() throws -> Bool?
    func decodeIfPresent() throws -> Int?
    func decodeIfPresent() throws -> Int8?
    func decodeIfPresent() throws -> Int16?
    func decodeIfPresent() throws -> Int32?
    func decodeIfPresent() throws -> Int64?
    func decodeIfPresent() throws -> UInt?
    func decodeIfPresent() throws -> UInt8?
    func decodeIfPresent() throws -> UInt16?
    func decodeIfPresent() throws -> UInt32?
    func decodeIfPresent() throws -> UInt64?
    func decodeIfPresent() throws -> Float?
    func decodeIfPresent() throws -> Double?
    func decodeIfPresent() throws -> CGFloat?
    func decodeIfPresent() throws -> String?
    func decodeIfPresent() throws -> Date?
    func decodeIfPresent() throws -> [Bool]?
    func decodeIfPresent() throws -> [Int]?
    func decodeIfPresent() throws -> [Int8]?
    func decodeIfPresent() throws -> [Int16]?
    func decodeIfPresent() throws -> [Int32]?
    func decodeIfPresent() throws -> [Int64]?
    func decodeIfPresent() throws -> [UInt]?
    func decodeIfPresent() throws -> [UInt8]?
    func decodeIfPresent() throws -> [UInt16]?
    func decodeIfPresent() throws -> [UInt32]?
    func decodeIfPresent() throws -> [UInt64]?
    func decodeIfPresent() throws -> [Float]?
    func decodeIfPresent() throws -> [Double]?
    func decodeIfPresent() throws -> [CGFloat]?
    func decodeIfPresent() throws -> [String]?
    func decodeIfPresent() throws -> [Date]?
    func decodeIfPresent() throws -> [String: Bool]?
    func decodeIfPresent() throws -> [String: Int]?
    func decodeIfPresent() throws -> [String: Int8]?
    func decodeIfPresent() throws -> [String: Int16]?
    func decodeIfPresent() throws -> [String: Int32]?
    func decodeIfPresent() throws -> [String: Int64]?
    func decodeIfPresent() throws -> [String: UInt]?
    func decodeIfPresent() throws -> [String: UInt8]?
    func decodeIfPresent() throws -> [String: UInt16]?
    func decodeIfPresent() throws -> [String: UInt32]?
    func decodeIfPresent() throws -> [String: UInt64]?
    func decodeIfPresent() throws -> [String: Float]?
    func decodeIfPresent() throws -> [String: Double]?
    func decodeIfPresent() throws -> [String: CGFloat]?
    func decodeIfPresent() throws -> [String: String]?
    func decodeIfPresent() throws -> [String: Date]?
    func decode<T: BDFSchemaDecodable>(_ type: T.Type) throws -> T
    func decode<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [T]
    func decode<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [String: T]
    func decodeIfPresent<T: BDFSchemaDecodable>(_ type: T.Type) throws -> T?
    func decodeIfPresent<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [T]?
    func decodeIfPresent<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [String: T]?
}

public class BDFUnarchiver {
    public init() { }
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: BDFSchemaDecodable {
        let decoder = _BDFSchemaDecoder(data: data)
        return try type.init(from: decoder)
    }
}

class _BDFSchemaDecoder: BDFSchemaDecoder {
    let data: SMBitDataReader
    
    init(data: Data) {
        self.data = SMBitDataReader(data: data)
    }
    
    func decode() throws -> Bool {
        guard let value = try BDFSerialization.decodePrimitive(from: self.data, as: nil) as? Bool else {
            throw BitDataDecodingError.typeMissmatch
        }
        return value
    }
    
    func decode() throws -> Int {
        guard let value = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return value
    }
    
    func decode() throws -> Int8 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Int8(rawValue)
    }
    
    func decode() throws -> Int16 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Int16(rawValue)
    }
    
    func decode() throws -> Int32 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Int32(rawValue)
    }
    
    func decode() throws -> Int64 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Int64(rawValue)
    }
    
    func decode() throws -> UInt {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return UInt(rawValue)
    }
    
    func decode() throws -> UInt8 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return UInt8(rawValue)
    }
    
    func decode() throws -> UInt16 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return UInt16(rawValue)
    }
    
    func decode() throws -> UInt32 {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Int else {
            throw BitDataDecodingError.typeMissmatch
        }
        return UInt32(rawValue)
    }
    
    func decode() throws -> UInt64 {
        let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil)
        if let value = rawValue as? Int {
            return UInt64(value)
        }
        else if let value = rawValue as? UInt {
            return UInt64(value)
        }
        throw BitDataDecodingError.typeMissmatch
    }
    
    func decode() throws -> Float {
        guard let rawValue = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Double else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Float(rawValue)
    }
    
    func decode() throws -> Double {
        guard let value = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Double else {
            throw BitDataDecodingError.typeMissmatch
        }
        return value
    }
    
    func decode() throws -> CGFloat {
        guard let value = try BDFSerialization.decodeNumber(from: self.data, as: nil) as? Double else {
            throw BitDataDecodingError.typeMissmatch
        }
        return CGFloat(value)
    }
    
    func decode() throws -> String {
        try BDFSerialization.decodeString(from: self.data, as: nil)
    }
    
    func decode() throws -> Date {
        try BDFSerialization.decodeDate(from: self.data, as: nil)
    }
    
    func decode() throws -> [Bool] {
        try self.decodeArray()
    }
    
    func decode() throws -> [Int] {
        try self.decodeArray()
    }
    
    func decode() throws -> [Int8] {
        try self.decodeArray(Int.self) { Int8($0) }
    }
    
    func decode() throws -> [Int16] {
        try self.decodeArray(Int.self) { Int16($0) }
    }
    
    func decode() throws -> [Int32] {
        try self.decodeArray(Int.self) { Int32($0) }
    }
    
    func decode() throws -> [Int64] {
        try self.decodeArray(Int.self) { Int64($0) }
    }
    
    func decode() throws -> [UInt] {
        try self.decodeArray(Int.self) { UInt($0) }
    }
    
    func decode() throws -> [UInt8] {
        try self.decodeArray(Int.self) { UInt8($0) }
    }
    
    func decode() throws -> [UInt16] {
        try self.decodeArray(Int.self) { UInt16($0) }
    }
    
    func decode() throws -> [UInt32] {
        try self.decodeArray(Int.self) { UInt32($0) }
    }
    
    func decode() throws -> [UInt64] {
        let rawArray = try BDFSerialization.decodeArray(from: self.data, as: nil)
        return try rawArray.map { rawValue in
            if let value = rawValue as? Int {
                return UInt64(value)
            }
            else if let value = rawValue as? UInt {
                return UInt64(value)
            }
            throw BitDataDecodingError.typeMissmatch
        }
    }
    
    func decode() throws -> [Float] {
        try self.decodeArray(Double.self) { Float($0) }
    }
    
    func decode() throws -> [Double] {
        try self.decodeArray()
    }
    
    func decode() throws -> [CGFloat] {
        try self.decodeArray(Double.self) { CGFloat($0) }
    }
    
    func decode() throws -> [String] {
        try self.decodeArray()
    }
    
    func decode() throws -> [Date] {
        try self.decodeArray()
    }
    
    func decode() throws -> [String: Bool] {
        try self.decodeDictionary()
    }
    
    func decode() throws -> [String: Int] {
        try self.decodeDictionary()
    }
    
    func decode() throws -> [String: Int8] {
        try self.decodeDictionary(Int.self) { Int8($0) }
    }
    
    func decode() throws -> [String: Int16] {
        try self.decodeDictionary(Int.self) { Int16($0) }
    }
    
    func decode() throws -> [String: Int32] {
        try self.decodeDictionary(Int.self) { Int32($0) }
    }
    
    func decode() throws -> [String: Int64] {
        try self.decodeDictionary(Int.self) { Int64($0) }
    }
    
    func decode() throws -> [String: UInt] {
        try self.decodeDictionary(Int.self) { UInt($0) }
    }
    
    func decode() throws -> [String: UInt8] {
        try self.decodeDictionary(Int.self) { UInt8($0) }
    }
    
    func decode() throws -> [String: UInt16] {
        try self.decodeDictionary(Int.self) { UInt16($0) }
    }
    
    func decode() throws -> [String: UInt32] {
        try self.decodeDictionary(Int.self) { UInt32($0) }
    }
    
    func decode() throws -> [String: UInt64] {
        let rawDictionary = try BDFSerialization.decodeDictionary(from: self.data, as: nil)
        return try rawDictionary.mapValues { rawValue in
            if let value = rawValue as? Int {
                return UInt64(value)
            }
            else if let value = rawValue as? UInt {
                return UInt64(value)
            }
            throw BitDataDecodingError.typeMissmatch
        }
    }
    
    func decode() throws -> [String: Float] {
        try self.decodeDictionary(Double.self) { Float($0) }
    }
    
    func decode() throws -> [String: Double] {
        try self.decodeDictionary()
    }
    
    func decode() throws -> [String: CGFloat] {
        try self.decodeDictionary(Double.self) { CGFloat($0) }
    }
    
    func decode() throws -> [String: String] {
        try self.decodeDictionary()
    }
    
    func decode() throws -> [String: Date] {
        try self.decodeDictionary()
    }
    
    func decodeIfPresent() throws -> Bool? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Int? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Int8? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Int16? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Int32? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Int64? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> UInt? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> UInt8? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> UInt16? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> UInt32? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> UInt64? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Float? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Double? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> CGFloat? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> String? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> Date? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Bool]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Int]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Int8]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Int16]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Int32]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Int64]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [UInt]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [UInt8]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [UInt16]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [UInt32]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [UInt64]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Float]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Double]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [CGFloat]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [Date]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Bool]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Int]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Int8]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Int16]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Int32]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Int64]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: UInt]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: UInt8]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: UInt16]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: UInt32]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: UInt64]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Float]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Double]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: CGFloat]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: String]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decodeIfPresent() throws -> [String: Date]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode()
    }
    
    func decode<T: BDFSchemaDecodable>(_ type: T.Type) throws -> T {
        return try type.init(from: self)
    }
    
    func decode<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [T] {
        let (count, useSeparator) = try decodeCollection(.array)
        
        var array = [T]()
        var finished = false
        
        if let count {
            array.reserveCapacity(count)
        }
        else if useSeparator {
            array.reserveCapacity(BitDataConstants.Collection.maxSizeForUsingSeparator)
        }
        
        while finished == false {
            let element = try type.init(from: self)
            array.append(element)
            if useSeparator {
                finished = try data.readBit() == BitDataConstants.Collection.separatorLastElement
            }
            else if let count {
                finished = array.count == count
            }
        }
        
        return array
    }
    
    func decode<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [String: T] {
        let (count, useSeparator) = try decodeCollection(.dictionary)
        
        var dictionary = [String: T]()
        var finished = false
        
        if let count {
            dictionary.reserveCapacity(count)
        }
        else if useSeparator {
            dictionary.reserveCapacity(BitDataConstants.Collection.maxSizeForUsingSeparator)
        }
        
        while finished == false {
            let key = try BDFSerialization.decodeString(from: data, as: nil)
            let element = try T.init(from: self)
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
    
    func decodeIfPresent<T: BDFSchemaDecodable>(_ type: T.Type) throws -> T? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode(type)
    }
    
    func decodeIfPresent<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [T]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode(type)
    }
    
    func decodeIfPresent<T: BDFSchemaDecodable>(_ type: T.Type) throws -> [String: T]? {
        guard try self.data.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try self.decode(type)
    }
    
    // MARK: - Help methods
    
    private func decodeArray<T, K>(_ k: K.Type, convertor: (K) -> T) throws -> [T] {
        let rawArray = try BDFSerialization.decodeArray(from: self.data, as: nil)
        return try rawArray.map { rawValue in
            guard let value = rawValue as? K else {
                throw BitDataDecodingError.typeMissmatch
            }
            return convertor(value)
        }
    }
    
    private func decodeArray<T>() throws -> [T] {
        let rawArray = try BDFSerialization.decodeArray(from: self.data, as: nil)
        return try rawArray.map { rawValue in
            guard let value = rawValue as? T else {
                throw BitDataDecodingError.typeMissmatch
            }
            return value
        }
    }
    
    private func decodeDictionary<T, K>(_ k: K.Type, convertor: (K) -> T) throws -> [String: T] {
        let rawDictionary = try BDFSerialization.decodeDictionary(from: self.data, as: nil)
        return try rawDictionary.mapValues { rawValue in
            guard let value = rawValue as? K else {
                throw BitDataDecodingError.typeMissmatch
            }
            return convertor(value)
        }
    }
    
    private func decodeDictionary<T>() throws -> [String: T] {
        let rawDictionary = try BDFSerialization.decodeDictionary(from: self.data, as: nil)
        return try rawDictionary.mapValues { rawValue in
            guard let value = rawValue as? T else {
                throw BitDataDecodingError.typeMissmatch
            }
            return value
        }
    }
    
    private func decodeCollection(_ dataType: BitDataType) throws -> (count: Int?, useSeparator: Bool) {
        guard let dataSubType = try self.data.readDataSubTypeSignature(for: dataType) else {
            throw BitDataDecodingError.unknownBitDataSubType
        }

        let count: Int?
        switch dataSubType {
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
