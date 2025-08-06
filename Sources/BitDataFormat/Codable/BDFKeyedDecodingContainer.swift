//
//  BDFKeyedDecodingContainer.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

class BDFKeyedDecodingContainer<Key: CodingKey>: KeyedDecodingContainerProtocol, BDFDecoderContainer {
    var codingPath: [any CodingKey]
    let allKeys: [Key]
    
    let storage: [String: Any]
    weak var decoder: _BDFDecoder?
    
    init(decoder: _BDFDecoder, storage: [String: Any], codingPath: [any CodingKey]) throws {
        self.decoder = decoder
        self.storage = storage
        self.codingPath = codingPath
        self.allKeys = storage.keys.compactMap { BitDataCodingKey.key($0) as? Key }
    }
    
    func contains(_ key: Key) -> Bool {
        self.allKeys.contains(where: { $0.stringValue == key.stringValue && $0.intValue == key.intValue })
    }
    
    func decodeNil(forKey key: Key) throws -> Bool {
        return storage[key.stringValue] == nil
    }
    
    func decode<T>(_ type: T.Type, forKey key: Key) throws -> T where T : Decodable {
        guard let rawValue = storage[key.stringValue] else {
            throw BitDataDecodingError.keyNotFound
        }
        if let value = rawValue as? T {
            return value
        }
        return try T(from: _BDFDecoder(storage: rawValue, codingPath: codingPath + [BitDataCodingKey.key(key.stringValue)], userInfo: self.decoder?.userInfo ?? [:]))
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: Key) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        guard let decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = self.storage[key.stringValue] as? [String: Any] else {
            throw BitDataDecodingError.typeMissmatch
        }
        let container = try BDFKeyedDecodingContainer<NestedKey>(decoder: decoder, storage: value, codingPath: codingPath +  [BitDataCodingKey.key(key.stringValue)])
        return KeyedDecodingContainer(container)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) throws -> any UnkeyedDecodingContainer {
        guard let decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = self.storage[key.stringValue] as? [Any] else {
            throw BitDataDecodingError.typeMissmatch
        }
        let container = try BDFUnkeyedDecodingContainer(decoder: decoder, storage: value, codingPath: codingPath + [BitDataCodingKey.key(key.stringValue)])
        return container
    }
    
    func superDecoder() throws -> any Decoder {
        guard let value = self.storage["super"] else {
            throw BitDataDecodingError.keyNotFound
        }
        let superDecoder = _BDFDecoder(storage: value, codingPath: self.codingPath + [BitDataCodingKey.key("super")], userInfo: decoder?.userInfo ?? [:])
        return superDecoder
    }
    
    func superDecoder(forKey key: Key) throws -> any Decoder {
        guard let value = self.storage[key.stringValue] else {
            throw BitDataDecodingError.keyNotFound
        }
        let superDecoder = _BDFDecoder(storage: value, codingPath: self.codingPath + [BitDataCodingKey.key(key.stringValue)], userInfo: decoder?.userInfo ?? [:])
        return superDecoder
    }
}

