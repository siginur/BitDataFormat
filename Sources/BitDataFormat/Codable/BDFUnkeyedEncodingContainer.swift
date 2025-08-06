//
//  BDFUnkeyedEncodingContainer.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

import Foundation

class BDFUnkeyedEncodingContainer: UnkeyedEncodingContainer, BDFEncoderContainer {
    var codingPath: [any CodingKey]
    var count: Int { storage.count }
    private var storage: [Any] = []
    
    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }
    
    func encodeNil() throws {
        self.storage.append(NSNull())
    }

    func encode<T>(_ value: T) throws where T : Encodable {
        self.storage.append(value)
    }
    
    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type) -> KeyedEncodingContainer<NestedKey> where NestedKey : CodingKey {
        let nestedContainer = BDFKeyedEncodingContainer<NestedKey>(codingPath: codingPath + [BitDataCodingKey.index(self.count)])
        self.storage.append(nestedContainer)
        return KeyedEncodingContainer(nestedContainer)
    }
    
    func nestedUnkeyedContainer() -> any UnkeyedEncodingContainer {
        let nestedContainer = BDFUnkeyedEncodingContainer(codingPath: codingPath + [BitDataCodingKey.index(self.count)])
        self.storage.append(nestedContainer)
        return nestedContainer
    }
    
    func superEncoder() -> any Encoder {
        let encoder = _BDFEncoder()
        encoder.codingPath.append(BitDataCodingKey.index(self.count))
        self.storage.append(encoder)
        return encoder
    }
    
    func resolveStorage() throws -> Any? {
        try self.storage.map { element in
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
