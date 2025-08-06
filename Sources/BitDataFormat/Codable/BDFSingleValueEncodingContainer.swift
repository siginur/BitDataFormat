//
//  BDFSingleValueEncodingContainer.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

import Foundation

class BDFSingleValueEncodingContainer: SingleValueEncodingContainer, BDFEncoderContainer {
    var codingPath: [CodingKey] = []
    private var storage: Any?

    init(codingPath: [CodingKey] = []) {
        self.codingPath = codingPath
    }

    func encodeNil() throws {
        self.storage = NSNull()
    }
    
    func encode<T>(_ value: T) throws where T : Encodable {
        self.storage = value
    }
    
    func resolveStorage() throws -> Any? {
        return self.storage
    }
}
