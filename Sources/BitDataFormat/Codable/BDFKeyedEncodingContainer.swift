//
//  BDFKeyedEncodingContainer.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

class BDFKeyedEncodingContainer<Key: CodingKey>: KeyedEncodingContainerProtocol, BDFEncoderContainer {
    var codingPath: [any CodingKey]
    
    var storage: [String: Any?] = [:]
    
    init(codingPath: [any CodingKey]) {
        self.codingPath = codingPath
    }
    
    func encodeNil(forKey key: Key) throws {
        storage[key.stringValue] = nil
    }
    
    func encode<T>(_ value: T, forKey key: Key) throws where T : Encodable {
        storage[key.stringValue] = value
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: Key) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let nestedContainer = BDFKeyedEncodingContainer<NestedKey>(codingPath: codingPath + [BitDataCodingKey.key(key.stringValue)])
        self.storage[key.stringValue] = nestedContainer
        return KeyedEncodingContainer(nestedContainer)
    }
    
    func nestedUnkeyedContainer(forKey key: Key) -> any UnkeyedEncodingContainer {
        let nestedContainer = BDFUnkeyedEncodingContainer(codingPath: codingPath + [BitDataCodingKey.key(key.stringValue)])
        self.storage[key.stringValue] = nestedContainer
        return nestedContainer
    }
    
    func superEncoder() -> any Encoder {
        let codingKey = BitDataCodingKey.key("super")
        let encoder = _BDFEncoder()
        encoder.codingPath.append(codingKey)
        self.storage[codingKey.stringValue] = encoder
        return encoder
    }
    
    func superEncoder(forKey key: Key) -> any Encoder {
        let encoder = _BDFEncoder()
        encoder.codingPath.append(BitDataCodingKey.key(key.stringValue))
        self.storage[key.stringValue] = encoder
        return encoder
    }
    
    func resolveStorage() throws -> Any? {
        try self.storage.mapValues { element in
            if let element = element as? BDFEncoderContainer {
                return try element.resolveStorage()
            }
            else if let element = element as? Codable {
                let encoder = _BDFEncoder()
                try element.encode(to: encoder)
                return try encoder.resolveStorage()
            }
            return element
        }
    }
    
}
