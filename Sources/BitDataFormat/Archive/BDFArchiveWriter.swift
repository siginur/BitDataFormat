//
//  BDFArchiveWriter.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 08/08/2025.
//

import Foundation
import SMBitData

public class BDFArchiver {
    public init() { }
    
    public func pack(_ value: any BDFArchiveWritable) throws -> Data {
        let archive = _BDFArchiveWriter()
        try value.write(to: archive)
        return archive.bitDataWriter.data
    }
}

public protocol BDFArchiveWriter {
    var bitDataWriter: SMBitDataWriter { get }
    func write(_ value: any BDFArchiveWritable) throws
    func writeIfPresent(_ value: (any BDFArchiveWritable)?) throws
}

class _BDFArchiveWriter: BDFArchiveWriter {
    let bitDataWriter: SMBitDataWriter
    
    init() {
        self.bitDataWriter = SMBitDataWriter()
    }
    
    func write(_ value: any BDFArchiveWritable) throws {
        try value.write(to: self)
    }
    
    func writeIfPresent(_ value: (any BDFArchiveWritable)?) throws {
        guard let value else {
            self.bitDataWriter.writeBit(BitDataConstants.Boolean.false)
            return
        }
        self.bitDataWriter.writeBit(BitDataConstants.Boolean.true)
        try self.write(value)
    }

}
