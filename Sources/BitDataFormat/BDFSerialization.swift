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
        let dataVersion = try data.readBits(BitDataConstants.currentVresionSizeInBits) // Version
        guard dataVersion <= BitDataConstants.currentVresion else {
            throw BitDataDecodingError.unsupportedVersion
        }
        return try self.decode(from: data, as: nil)
    }
}

extension BDFSerialization {
    static func dataWithStats(withBDFObject object: Any?) throws -> (bits: UInt64, data: Data) {
        let data = SMBitDataWriter()
        data.writeBits(BitDataConstants.currentVresion, count: BitDataConstants.currentVresionSizeInBits) // Version
        try self.encode(object: object, includeType: true, to: data) // Content
        return (data.sizeInBits, data.data)
    }
    
    static func dataType(of object: Any?) -> BitDataType? {
        return switch object {
            // Primitive
        case _ as Bool, _ as NSNull, nil: .primitive
            // Number
        case _ as Int, _ as Int8, _ as Int16, _ as Int32, _ as Int64, _ as UInt, _ as UInt8, _ as UInt16, _ as UInt32, _ as UInt64, _ as Float, _ as Double, _ as CGFloat: .number
            // String
        case _ as String, _ as NSString: .string
            // Array
        case _ as [Any], _ as NSArray: .array
            // Object
        case _ as [String: Any]: .dictionary
            // Unsupported
        default:
            nil
        }
    }
}
