//
//  BDFSchemaEncoder.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 08/08/2025.
//

import Foundation
import SMBitData

public protocol BDFSchemaCodable: BDFSchemaEncodable, BDFSchemaDecodable { }

public protocol BDFSchemaEncodable {
    func encode(to encoder: any BDFSchemaEncoder) throws
}

public protocol BDFSchemaEncoder {
    func encode(_ value: Bool) throws
    func encode(_ value: Int) throws
    func encode(_ value: Int8) throws
    func encode(_ value: Int16) throws
    func encode(_ value: Int32) throws
    func encode(_ value: Int64) throws
    func encode(_ value: UInt) throws
    func encode(_ value: UInt8) throws
    func encode(_ value: UInt16) throws
    func encode(_ value: UInt32) throws
    func encode(_ value: UInt64) throws
    func encode(_ value: Float) throws
    func encode(_ value: Double) throws
    func encode(_ value: CGFloat) throws
    func encode(_ value: String) throws
    func encode(_ value: Date) throws
    func encode(_ value: [Bool]) throws
    func encode(_ value: [Int]) throws
    func encode(_ value: [Int8]) throws
    func encode(_ value: [Int16]) throws
    func encode(_ value: [Int32]) throws
    func encode(_ value: [Int64]) throws
    func encode(_ value: [UInt]) throws
    func encode(_ value: [UInt8]) throws
    func encode(_ value: [UInt16]) throws
    func encode(_ value: [UInt32]) throws
    func encode(_ value: [UInt64]) throws
    func encode(_ value: [Float]) throws
    func encode(_ value: [Double]) throws
    func encode(_ value: [CGFloat]) throws
    func encode(_ value: [String]) throws
    func encode(_ value: [Date]) throws
    func encode(_ value: [String: Bool]) throws
    func encode(_ value: [String: Int]) throws
    func encode(_ value: [String: Int8]) throws
    func encode(_ value: [String: Int16]) throws
    func encode(_ value: [String: Int32]) throws
    func encode(_ value: [String: Int64]) throws
    func encode(_ value: [String: UInt]) throws
    func encode(_ value: [String: UInt8]) throws
    func encode(_ value: [String: UInt16]) throws
    func encode(_ value: [String: UInt32]) throws
    func encode(_ value: [String: UInt64]) throws
    func encode(_ value: [String: Float]) throws
    func encode(_ value: [String: Double]) throws
    func encode(_ value: [String: CGFloat]) throws
    func encode(_ value: [String: String]) throws
    func encode(_ value: [String: Date]) throws
    func encodeIfPresent(_ value: Bool?) throws
    func encodeIfPresent(_ value: Int?) throws
    func encodeIfPresent(_ value: Int8?) throws
    func encodeIfPresent(_ value: Int16?) throws
    func encodeIfPresent(_ value: Int32?) throws
    func encodeIfPresent(_ value: Int64?) throws
    func encodeIfPresent(_ value: UInt?) throws
    func encodeIfPresent(_ value: UInt8?) throws
    func encodeIfPresent(_ value: UInt16?) throws
    func encodeIfPresent(_ value: UInt32?) throws
    func encodeIfPresent(_ value: UInt64?) throws
    func encodeIfPresent(_ value: Float?) throws
    func encodeIfPresent(_ value: Double?) throws
    func encodeIfPresent(_ value: CGFloat?) throws
    func encodeIfPresent(_ value: String?) throws
    func encodeIfPresent(_ value: Date?) throws
    func encodeIfPresent(_ value: [Bool]?) throws
    func encodeIfPresent(_ value: [Int]?) throws
    func encodeIfPresent(_ value: [Int8]?) throws
    func encodeIfPresent(_ value: [Int16]?) throws
    func encodeIfPresent(_ value: [Int32]?) throws
    func encodeIfPresent(_ value: [Int64]?) throws
    func encodeIfPresent(_ value: [UInt]?) throws
    func encodeIfPresent(_ value: [UInt8]?) throws
    func encodeIfPresent(_ value: [UInt16]?) throws
    func encodeIfPresent(_ value: [UInt32]?) throws
    func encodeIfPresent(_ value: [UInt64]?) throws
    func encodeIfPresent(_ value: [Float]?) throws
    func encodeIfPresent(_ value: [Double]?) throws
    func encodeIfPresent(_ value: [CGFloat]?) throws
    func encodeIfPresent(_ value: [String]?) throws
    func encodeIfPresent(_ value: [Date]?) throws
    func encodeIfPresent(_ value: [String: Bool]?) throws
    func encodeIfPresent(_ value: [String: Int]?) throws
    func encodeIfPresent(_ value: [String: Int8]?) throws
    func encodeIfPresent(_ value: [String: Int16]?) throws
    func encodeIfPresent(_ value: [String: Int32]?) throws
    func encodeIfPresent(_ value: [String: Int64]?) throws
    func encodeIfPresent(_ value: [String: UInt]?) throws
    func encodeIfPresent(_ value: [String: UInt8]?) throws
    func encodeIfPresent(_ value: [String: UInt16]?) throws
    func encodeIfPresent(_ value: [String: UInt32]?) throws
    func encodeIfPresent(_ value: [String: UInt64]?) throws
    func encodeIfPresent(_ value: [String: Float]?) throws
    func encodeIfPresent(_ value: [String: Double]?) throws
    func encodeIfPresent(_ value: [String: CGFloat]?) throws
    func encodeIfPresent(_ value: [String: String]?) throws
    func encodeIfPresent(_ value: [String: Date]?) throws
    func encode(_ value: any BDFSchemaEncodable) throws
    func encode(_ value: [any BDFSchemaEncodable]) throws
    func encode(_ value: [String: any BDFSchemaEncodable]) throws
    func encodeIfPresent(_ value: (any BDFSchemaEncodable)?) throws
    func encodeIfPresent(_ value: [any BDFSchemaEncodable]?) throws
    func encodeIfPresent(_ value: [String: any BDFSchemaEncodable]?) throws
}

public class BDFArchiver {
    public init() { }
    
    public func encode(_ value: any BDFSchemaEncodable) throws -> Data {
        let encoder = _BDFSchemaEncoder()
        try value.encode(to: encoder)
        return encoder.data.data
    }
}

class _BDFSchemaEncoder: BDFSchemaEncoder {
    let data: SMBitDataWriter
    
    init() {
        self.data = SMBitDataWriter()
    }
    
    func encode(_ value: Bool) throws {
        data.writeDataSubTypeSignature(value == true ? .primitiveTrue : .primitiveFalse)
    }
    
    func encode(_ value: Int) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: Int8) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: Int16) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: Int32) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: Int64) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: UInt) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: UInt8) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: UInt16) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: UInt32) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: UInt64) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: Float) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: Double) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: CGFloat) throws {
        try BDFSerialization.encode(number: value, to: self.data)
    }
    
    func encode(_ value: String) throws {
        try BDFSerialization.encode(string: value, to: data)
    }
    
    func encode(_ value: Date) throws {
        try BDFSerialization.encode(date: value, to: data)
    }
    
    func encode(_ value: [Bool]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Int]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Int8]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Int16]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Int32]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Int64]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [UInt]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [UInt8]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [UInt16]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [UInt32]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [UInt64]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Float]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Double]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [CGFloat]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [String]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [Date]) throws {
        try BDFSerialization.encode(array: value, to: self.data)
    }
    
    func encode(_ value: [String: Bool]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Int]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Int8]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Int16]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Int32]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Int64]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: UInt]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: UInt8]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: UInt16]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: UInt32]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: UInt64]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Float]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Double]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: CGFloat]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: String]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encode(_ value: [String: Date]) throws {
        try BDFSerialization.encode(dictionary: value, to: self.data)
    }
    
    func encodeIfPresent(_ value: Bool?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Int?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Int8?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Int16?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Int32?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Int64?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: UInt?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: UInt8?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: UInt16?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: UInt32?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: UInt64?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Float?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Double?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: CGFloat?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: String?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: Date?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Bool]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Int]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Int8]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Int16]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Int32]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Int64]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [UInt]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [UInt8]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [UInt16]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [UInt32]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [UInt64]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Float]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Double]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [CGFloat]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [Date]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Bool]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Int]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Int8]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Int16]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Int32]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Int64]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: UInt]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: UInt8]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: UInt16]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: UInt32]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: UInt64]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Float]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Double]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: CGFloat]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: String]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String: Date]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encode(_ value: any BDFSchemaEncodable) throws {
        try value.encode(to: self)
    }
    
    func encode(_ value: [any BDFSchemaEncodable]) throws {
        let count = value.count
        let dataSubType = try BDFSerialization.encode(collectionBasedOnSize: count, to: self.data)
        guard BitDataType.array.subTypes.contains(dataSubType) else {
            throw BitDataEncodingError.unsupportedSubType
        }
        let useSeparator = dataSubType == .collectionSeparator
        
        for i in 0..<count {
            try value[i].encode(to: self)
            if useSeparator {
                data.writeBit(i == count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
    
    func encode(_ value: [String: any BDFSchemaEncodable]) throws {
        let count = value.count
        let dataSubType = try BDFSerialization.encode(collectionBasedOnSize: count, to: self.data)
        guard BitDataType.dictionary.subTypes.contains(dataSubType) else {
            throw BitDataEncodingError.unsupportedSubType
        }
        let useSeparator = dataSubType == .collectionSeparator
        
        for (index, (key, value)) in value.enumerated() {
            try BDFSerialization.encode(string: key, to: self.data)
            try value.encode(to: self)
            if useSeparator {
                data.writeBit(index == count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
    
    func encodeIfPresent(_ value: (any BDFSchemaEncodable)?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [any BDFSchemaEncodable]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }
    
    func encodeIfPresent(_ value: [String:any BDFSchemaEncodable]?) throws {
        guard let value else {
            self.data.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.data.writeBit(BitDataConstants.Boolean.true)
        try self.encode(value)
    }

}
