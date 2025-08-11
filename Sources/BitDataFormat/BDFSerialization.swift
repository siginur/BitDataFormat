//
//  BDFSerialization.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import Foundation
import SMBitData

public class BDFSerialization {
    /// Returns BDF encoded data from a Foundation object.
    public static func data(withBDFObject object: Any?) throws -> Data {
        return try self.dataWithStats(withBDFObject: object).data
    }
    
    /// Returns a Foundation object from given BDF encoded data.
    public static func bdfObject(with data: Data) throws -> Any {
        let data = SMBitDataReader(data: data)
        return try self.decode(from: data, as: nil)
    }
    
    /// Returns a JSON string representation of the BDF encoded data.
    public static func json(with data: Data, options: JSONSerialization.WritingOptions = []) throws -> String? {
        let object = try self.bdfObject(with: data)
        let jsonData = try JSONSerialization.data(withJSONObject: object, options: options)
        return String(data: jsonData, encoding: .utf8)
    }
}

extension BDFSerialization {
    static func dataWithStats(withBDFObject object: Any?) throws -> (bits: UInt64, data: Data) {
        let data = SMBitDataWriter()
        try self.encode(object: object, includeType: true, to: data) // Content
        return (data.sizeInBits, data.data)
    }
}
