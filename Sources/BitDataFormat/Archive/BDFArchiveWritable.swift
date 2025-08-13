//
//  BDFArchiveWritable.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 13/08/2025.
//

import Foundation

public protocol BDFArchiveWritable {
    func write(to archive: any BDFArchiveWriter) throws
}

// MARK: - Primitives

extension Bool: BDFArchiveWritable {
    public func write(to archive: any BDFArchiveWriter) throws {
        try BDFSerialization.encode(bool: self, to: archive.bitDataWriter)
    }
}

// MARK: - Numbers

// Default implementation for all fixed-width integers (both signed and unsigned)
extension BDFArchiveWritable where Self: FixedWidthInteger {
    public func write(to archive: any BDFArchiveWriter) throws {
        try BDFSerialization.encode(number: self, to: archive.bitDataWriter)
    }
}

// Default implementation for all binary floating-point types
extension BDFArchiveWritable where Self: BinaryFloatingPoint {
    public func write(to archive: any BDFArchiveWriter) throws {
        try BDFSerialization.encode(number: self, to: archive.bitDataWriter)
    }
}

// Conform all signed integer types to BDFArchiveEncodable
extension Int:   BDFArchiveWritable {}
extension Int8:  BDFArchiveWritable {}
extension Int16: BDFArchiveWritable {}
extension Int32: BDFArchiveWritable {}
extension Int64: BDFArchiveWritable {}

// Conform all unsigned integer types to BDFArchiveEncodable
extension UInt:   BDFArchiveWritable {}
extension UInt8:  BDFArchiveWritable {}
extension UInt16: BDFArchiveWritable {}
extension UInt32: BDFArchiveWritable {}
extension UInt64: BDFArchiveWritable {}

// Conform floating-point types
extension Float:   BDFArchiveWritable {}
extension Double:  BDFArchiveWritable {}
extension CGFloat: BDFArchiveWritable {}

// MARK: - String

extension String: BDFArchiveWritable {
    public func write(to archive: any BDFArchiveWriter) throws {
        try BDFSerialization.encode(string: self, to: archive.bitDataWriter)
    }
}

// MARK: - Date

extension Date: BDFArchiveWritable {
    public func write(to archive: any BDFArchiveWriter) throws {
        try BDFSerialization.encode(date: self, to: archive.bitDataWriter)
    }
}

// MARK: - Array

extension Array: BDFArchiveWritable where Element: BDFArchiveWritable {
    public func write(to archive: any BDFArchiveWriter) throws {
        let dataSubType = try BDFSerialization.encode(collectionBasedOnSize: self.count, to: archive.bitDataWriter)
        guard BitDataType.array.subTypes.contains(dataSubType) else {
            throw BitDataEncodingError.unsupportedSubType
        }
        let useSeparator = dataSubType == .collectionSeparator
        
        for i in 0..<self.count {
            try self[i].write(to: archive)
            if useSeparator {
                archive.bitDataWriter.writeBit(i == self.count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
}

// MARK: - Dictionary

extension Dictionary: BDFArchiveWritable where Key == String, Value: BDFArchiveWritable {
    public func write(to archive: any BDFArchiveWriter) throws {
        let dataSubType = try BDFSerialization.encode(collectionBasedOnSize: self.count, to: archive.bitDataWriter)
        guard BitDataType.dictionary.subTypes.contains(dataSubType) else {
            throw BitDataEncodingError.unsupportedSubType
        }
        let useSeparator = dataSubType == .collectionSeparator
        
        for (index, (key, value)) in self.enumerated() {
            try BDFSerialization.encode(string: key, to: archive.bitDataWriter)
            try value.write(to: archive)
            if useSeparator {
                archive.bitDataWriter.writeBit(index == self.count - 1 ? BitDataConstants.Collection.separatorLastElement : BitDataConstants.Collection.separatorMiddleElement)
            }
        }
    }
}
