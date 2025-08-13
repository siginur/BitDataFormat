//
//  BDFArchiveReader.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 11/08/2025.
//

import Foundation
import SMBitData

public class BDFUnarchiver {
    public init() { }
    
    public func unpack<T: BDFArchiveReadable>(_ type: T.Type, from data: Data) throws -> T {
        let archive = _BDFArchiveReader(data: data)
        return try T.init(from: archive)
    }
}

public protocol BDFArchiveReader {
    var bitDataReader: SMBitDataReader { get }
    func read<T: BDFArchiveReadable>() throws -> T
    func readIfPresent<T: BDFArchiveReadable>() throws -> T?
}

class _BDFArchiveReader: BDFArchiveReader {
    
    let bitDataReader: SMBitDataReader
    
    init(data: Data) {
        self.bitDataReader = SMBitDataReader(data: data)
    }
    
    func read<T: BDFArchiveReadable>() throws -> T {
        return try T(from: self)
    }
    
    func readIfPresent<T: BDFArchiveReadable>() throws -> T? {
        guard try self.bitDataReader.readBit() == BitDataConstants.Boolean.true else {
            return nil
        }
        return try T(from: self)
    }
    
}
