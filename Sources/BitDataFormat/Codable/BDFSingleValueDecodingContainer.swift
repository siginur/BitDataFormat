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
    
    func decode<T>(_ type: T.Type) throws -> T where T : Decodable {
        guard let decoder = self.decoder else {
            throw BitDataDecodingError.missingDecoder
        }
        guard let value = decoder.storage as? T else {
            throw BitDataDecodingError.typeMissmatch
        }
        return value
    }
}

