//
//  BDFUnkeyedDecodingContainer.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

import Foundation

class BDFUnkeyedDecodingContainer: UnkeyedDecodingContainer, BDFDecoderContainer {
    var codingPath: [any CodingKey]
    let count: Int?
    var isAtEnd: Bool
    var currentIndex: Int
    
    let storage: [Any]
    weak var decoder: _BDFDecoder?
    
    init(decoder: _BDFDecoder, storage: [Any], codingPath: [any CodingKey]) throws {
        self.decoder = decoder
        self.storage = storage
        self.codingPath = codingPath
        self.count = storage.count
        self.currentIndex = 0
        self.isAtEnd = storage.isEmpty
    }
    
    func decodeNil() throws -> Bool {
        let value = self.storage[self.currentIndex]
        self.nextIndex()
        return value is NSNull
    }
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        let rawValue = self.storage[self.currentIndex]
        if let value = rawValue as? T {
            self.nextIndex()
            return value
        }
        let value = try T(from: _BDFDecoder(storage: rawValue, codingPath: codingPath + [BitDataCodingKey.index(self.currentIndex)], userInfo: self.decoder?.userInfo ?? [:]))
        self.nextIndex()
        return value
    }
    
    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey> where NestedKey : CodingKey {
        guard let decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = self.storage[self.currentIndex] as? [String: Any] else {
            throw BitDataDecodingError.typeMissmatch
        }
        let container = try BDFKeyedDecodingContainer<NestedKey>(decoder: decoder, storage: value, codingPath: codingPath + [BitDataCodingKey.index(self.currentIndex)])
        self.nextIndex()
        return KeyedDecodingContainer(container)
    }
    
    func nestedUnkeyedContainer() throws -> any UnkeyedDecodingContainer {
        guard let decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = self.storage[self.currentIndex] as? [Any] else {
            throw BitDataDecodingError.typeMissmatch
        }
        let container = try BDFUnkeyedDecodingContainer(decoder: decoder, storage: value, codingPath: codingPath + [BitDataCodingKey(intValue: self.currentIndex)])
        self.nextIndex()
        return container
    }
    
    func superDecoder() throws -> any Decoder {
        let superDecoder = _BDFDecoder(storage: self.storage[self.currentIndex], codingPath: self.codingPath + [BitDataCodingKey.index(self.currentIndex)], userInfo: decoder?.userInfo ?? [:])
        self.nextIndex()
        return superDecoder
    }
    
    private func nextIndex() {
        self.currentIndex += 1
        self.isAtEnd = self.currentIndex >= (self.count ?? 0)
    }
    
}
