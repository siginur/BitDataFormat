//
//  BDFSingleValueDecodingContainer.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

import Foundation

class BDFSingleValueDecodingContainer: SingleValueDecodingContainer, BDFDecoderContainer {
    var codingPath: [any CodingKey]
    
    weak var decoder: _BDFDecoder?
    
    init(decoder: _BDFDecoder, codingPath: [any CodingKey]) {
        self.decoder = decoder
        self.codingPath = codingPath
    }
    
    func decodeNil() -> Bool {
        return self.decoder?.storage is NSNull
    }
    
    func decode(_ type: UInt16) throws -> UInt16 {
        guard let decoder = self.decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = decoder.storage as? (any BinaryInteger) else {
            throw BitDataDecodingError.typeMissmatch
        }
        return UInt16(value)
    }
    
    func decode(_ type: Int) throws -> Int {
        guard let decoder = self.decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = decoder.storage as? (any BinaryInteger) else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Int(value)
    }
    
    @available(iOS 18.0, watchOS 11.0, macOS 15.0, macCatalyst 18.0, tvOS 18.0, visionOS 2.0, *)
    func decode(_ type: Int128.Type) throws -> Int128 {
        guard let storage = self.decoder?.storage else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = storage as? (any BinaryInteger) else {
            throw BitDataDecodingError.typeMissmatch
        }
        return Int128(value)
    }
    
    @available(iOS 18.0, watchOS 11.0, macOS 15.0, macCatalyst 18.0, tvOS 18.0, visionOS 2.0, *)
    func decode(_ type: UInt128.Type) throws -> UInt128 {
        guard let storage = self.decoder?.storage else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = storage as? (any BinaryInteger) else {
            throw BitDataDecodingError.typeMissmatch
        }
        return UInt128(value)
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard let storage = self.decoder?.storage else {
            throw BitDataDecodingError.missingDecoder
        }
        
        if let value = storage as? T {
            return value
        }
        
        switch T.self {
        case is Int.Type:
            if let value = storage as? (any BinaryInteger) {
                return Int(value) as! T
            }
        case is Int8.Type:
            if let value = storage as? (any BinaryInteger) {
                return Int8(value) as! T
            }
        case is Int16.Type:
            if let value = storage as? (any BinaryInteger) {
                return Int16(value) as! T
            }
        case is Int32.Type:
            if let value = storage as? (any BinaryInteger) {
                return Int32(value) as! T
            }
        case is Int64.Type:
            if let value = storage as? (any BinaryInteger) {
                return Int64(value) as! T
            }
        case is UInt.Type:
            if let value = storage as? (any BinaryInteger) {
                return UInt(value) as! T
            }
        case is UInt8.Type:
            if let value = storage as? (any BinaryInteger) {
                return UInt8(value) as! T
            }
        case is UInt16.Type:
            if let value = storage as? (any BinaryInteger) {
                return UInt16(value) as! T
            }
        case is UInt32.Type:
            if let value = storage as? (any BinaryInteger) {
                return UInt32(value) as! T
            }
        case is UInt64.Type:
            if let value = storage as? (any BinaryInteger) {
                return UInt64(value) as! T
            }
        case is Float.Type:
            if let value = storage as? Float {
                return value as! T
            }
            else if let value = storage as? Double {
                return Float(value) as! T
            }
        case is Double.Type:
            if let value = storage as? Double {
                return value as! T
            }
        case is CGFloat.Type:
            if let value = storage as? CGFloat {
                return value as! T
            }
            else if let value = storage as? Double {
                return CGFloat(value) as! T
            }
            else if let value = storage as? Float {
                return CGFloat(value) as! T
            }
        default:
            break
        }
        
        if #available(iOS 18.0, watchOS 11.0, macOS 15.0, macCatalyst 18.0, tvOS 18.0, visionOS 2.0, *) {
            if T.self is Int128.Type {
                if let value = storage as? (any BinaryInteger) {
                    return Int128(value) as! T
                }
            }
            else if T.self is UInt128.Type {
                if let value = storage as? (any BinaryInteger) {
                    return UInt128(value) as! T
                }
            }
        }
        
        throw BitDataDecodingError.typeMissmatch
    }
}

