//
//  BDFEncoder.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import Foundation
import SMBitData

public class BDFEncoder {
    public var userInfo: [CodingUserInfoKey : Any] = [:]
    
    public func encode(_ value: any Encodable) throws -> Data {
        let encoder = _BDFEncoder(userInfo: userInfo)
        try value.encode(to: encoder)
        let storage = try encoder.resolveStorage()
        return try BDFSerialization.data(withBDFObject: storage)
    }
}

protocol BDFEncoderContainer {
    func resolveStorage() throws -> Any?
}

class _BDFEncoder: Encoder, BDFEncoderContainer {
    
    var codingPath: [any CodingKey]
    var userInfo: [CodingUserInfoKey : Any]
    
    private var topLevelContainer: BDFEncoderContainer?
    
    init(codingPath: [any CodingKey] = [], userInfo: [CodingUserInfoKey : Any] = [:]) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = BDFKeyedEncodingContainer<Key>(codingPath: self.codingPath)
        self.topLevelContainer = container
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> any UnkeyedEncodingContainer {
        let container = BDFUnkeyedEncodingContainer()
        self.topLevelContainer = container
        return container
    }
    
    func singleValueContainer() -> any SingleValueEncodingContainer {
        let container = BDFSingleValueEncodingContainer()
        self.topLevelContainer = container
        return container
    }
    
    func resolveStorage() throws -> Any? {
        guard let topLevelContainer else {
            return nil
        }
        return try topLevelContainer.resolveStorage()
    }
}
