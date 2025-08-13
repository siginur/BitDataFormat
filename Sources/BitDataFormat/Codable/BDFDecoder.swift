//
//  BDFDecoder.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

import Foundation
import SMBitData

public class BDFDecoder {
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    
    public init() {}
    
    public func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        let storage = try BDFSerialization.bdfObject(with: data)
        let decoder = _BDFDecoder(storage: storage, codingPath: [], userInfo: userInfo)
        return try type.init(from: decoder)
    }
}

protocol BDFDecoderContainer {
    var decoder: _BDFDecoder? { get set }
}

class _BDFDecoder: Decoder {
    
    var codingPath: [any CodingKey]
    var userInfo: [CodingUserInfoKey : Any]
    
    let storage: Any
    
    init(storage: Any, codingPath: [any CodingKey], userInfo: [CodingUserInfoKey : Any]) {
        self.storage = storage
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        guard let value = self.storage as? [String: Any] else {
            throw BitDataDecodingError.typeMissmatch
        }
        let container = try BDFKeyedDecodingContainer<Key>(decoder: self, storage: value, codingPath: codingPath)
        return KeyedDecodingContainer(container)
    }
    
    func unkeyedContainer() throws -> any UnkeyedDecodingContainer {
        guard let value = self.storage as? [Any] else {
            throw BitDataDecodingError.typeMissmatch
        }
        let container = try BDFUnkeyedDecodingContainer(decoder: self, storage: value, codingPath: codingPath)
        return container
    }
    
    func singleValueContainer() throws -> any SingleValueDecodingContainer {
        let container = BDFSingleValueDecodingContainer(decoder: self, codingPath: codingPath)
        return container
    }
    
}
