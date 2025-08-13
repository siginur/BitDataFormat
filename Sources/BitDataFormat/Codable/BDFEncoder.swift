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
    
    public init() {}
    
    public func encode(_ value: any Encodable) throws -> Data {
        let encoder = _BDFEncoder(codingPath: [], userInfo: userInfo)
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
    
    private var containers: [BDFEncoderContainer] = []
    
    init(codingPath: [any CodingKey], userInfo: [CodingUserInfoKey : Any] = [:]) {
        self.codingPath = codingPath
        self.userInfo = userInfo
    }
    
    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key : CodingKey {
        let container = BDFKeyedEncodingContainer<Key>(codingPath: self.codingPath)
        self.containers.append(container)
        return KeyedEncodingContainer(container)
    }

    func unkeyedContainer() -> any UnkeyedEncodingContainer {
        let container = BDFUnkeyedEncodingContainer(codingPath: self.codingPath)
        self.containers.append(container)
        return container
    }
    
    func singleValueContainer() -> any SingleValueEncodingContainer {
        let container = BDFSingleValueEncodingContainer(codingPath: self.codingPath)
        self.containers.append(container)
        return container
    }
    
    func resolveStorage() throws -> Any? {
        guard self.containers.isEmpty == false else {
            return nil
        }
        var result = [Any]()
        for container in self.containers {
            if let storage = try container.resolveStorage() {
                result.append(storage)
            }
        }
        if let arrays = result as? [[Any]] {
            return (arrays.flatMap { $0 })
        }
        else if let dictionaries = result as? [[String: Any?]] {
            return dictionaries.reduce(into: [String: Any?]()) { $0.merge($1) { (_, new) in new } }
        }
        else if result.count == 1 {
            return result.first
        }
        return result
    }
}
