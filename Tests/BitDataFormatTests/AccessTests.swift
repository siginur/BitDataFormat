//
//  AccessTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 13/08/2025.
//

import XCTest
import BitDataFormat

// This test only validates that all required methods
// are marked as `public` or `open` and could be accessed
// from outside the module.

final class AccessTests: XCTestCase {

    func testSerialization() {
        _ = try? BDFSerialization.bdfObject(with: Data())
        _ = try? BDFSerialization.data(withBDFObject: true)
        _ = try? BDFSerialization.json(with: Data(), options: .fragmentsAllowed)
    }
    
    func testCodable() {
        let encoder = BDFEncoder()
        _ = try? encoder.encode(true)
        let decoder = BDFDecoder()
        _ = try? decoder.decode(Bool.self, from: Data())
    }
    
    func testArchiveEncoder() {
        let archive = BDFArchiver()
        _ = try? archive.pack(true)
        _ = try? archive.pack(Int.zero)
        _ = try? archive.pack(Int8.zero)
        _ = try? archive.pack(Int16.zero)
        _ = try? archive.pack(Int32.zero)
        _ = try? archive.pack(Int64.zero)
        _ = try? archive.pack(UInt.zero)
        _ = try? archive.pack(UInt8.zero)
        _ = try? archive.pack(UInt16.zero)
        _ = try? archive.pack(UInt32.zero)
        _ = try? archive.pack(UInt64.zero)
        _ = try? archive.pack(Float.zero)
        _ = try? archive.pack(Double.zero)
        _ = try? archive.pack(CGFloat.zero)
        _ = try? archive.pack("")
        _ = try? archive.pack(Date())
        _ = try? archive.pack([true])
        _ = try? archive.pack([Int.zero])
        _ = try? archive.pack([Int8.zero])
        _ = try? archive.pack([Int16.zero])
        _ = try? archive.pack([Int32.zero])
        _ = try? archive.pack([Int64.zero])
        _ = try? archive.pack([UInt.zero])
        _ = try? archive.pack([UInt8.zero])
        _ = try? archive.pack([UInt16.zero])
        _ = try? archive.pack([UInt32.zero])
        _ = try? archive.pack([UInt64.zero])
        _ = try? archive.pack([Float.zero])
        _ = try? archive.pack([Double.zero])
        _ = try? archive.pack([CGFloat.zero])
        _ = try? archive.pack([""])
        _ = try? archive.pack([Date()])
        _ = try? archive.pack(["key": true])
        _ = try? archive.pack(["key": Int.zero])
        _ = try? archive.pack(["key": Int8.zero])
        _ = try? archive.pack(["key": Int16.zero])
        _ = try? archive.pack(["key": Int32.zero])
        _ = try? archive.pack(["key": Int64.zero])
        _ = try? archive.pack(["key": UInt.zero])
        _ = try? archive.pack(["key": UInt8.zero])
        _ = try? archive.pack(["key": UInt16.zero])
        _ = try? archive.pack(["key": UInt32.zero])
        _ = try? archive.pack(["key": UInt64.zero])
        _ = try? archive.pack(["key": Float.zero])
        _ = try? archive.pack(["key": Double.zero])
        _ = try? archive.pack(["key": CGFloat.zero])
        _ = try? archive.pack(["key": "value"])
        _ = try? archive.pack(["key": Date()])
    }
    
    func testArchiveDecoder() {
        let unarchiver = BDFUnarchiver()
        _ = try? unarchiver.unpack(Bool.self, from: Data())
        _ = try? unarchiver.unpack(Int.self, from: Data())
        _ = try? unarchiver.unpack(Int8.self, from: Data())
        _ = try? unarchiver.unpack(Int16.self, from: Data())
        _ = try? unarchiver.unpack(Int32.self, from: Data())
        _ = try? unarchiver.unpack(Int64.self, from: Data())
        _ = try? unarchiver.unpack(UInt.self, from: Data())
        _ = try? unarchiver.unpack(UInt8.self, from: Data())
        _ = try? unarchiver.unpack(UInt16.self, from: Data())
        _ = try? unarchiver.unpack(UInt32.self, from: Data())
        _ = try? unarchiver.unpack(UInt64.self, from: Data())
        _ = try? unarchiver.unpack(Float.self, from: Data())
        _ = try? unarchiver.unpack(Double.self, from: Data())
        _ = try? unarchiver.unpack(CGFloat.self, from: Data())
        _ = try? unarchiver.unpack(String.self, from: Data())
        _ = try? unarchiver.unpack(Date.self, from: Data())
        _ = try? unarchiver.unpack([Bool].self, from: Data())
        _ = try? unarchiver.unpack([Int].self, from: Data())
        _ = try? unarchiver.unpack([Int8].self, from: Data())
        _ = try? unarchiver.unpack([Int16].self, from: Data())
        _ = try? unarchiver.unpack([Int32].self, from: Data())
        _ = try? unarchiver.unpack([Int64].self, from: Data())
        _ = try? unarchiver.unpack([UInt].self, from: Data())
        _ = try? unarchiver.unpack([UInt8].self, from: Data())
        _ = try? unarchiver.unpack([UInt16].self, from: Data())
        _ = try? unarchiver.unpack([UInt32].self, from: Data())
        _ = try? unarchiver.unpack([UInt64].self, from: Data())
        _ = try? unarchiver.unpack([Float].self, from: Data())
        _ = try? unarchiver.unpack([Double].self, from: Data())
        _ = try? unarchiver.unpack([CGFloat].self, from: Data())
        _ = try? unarchiver.unpack([String].self, from: Data())
        _ = try? unarchiver.unpack([Date].self, from: Data())
        _ = try? unarchiver.unpack([String: Bool].self, from: Data())
        _ = try? unarchiver.unpack([String: Int].self, from: Data())
        _ = try? unarchiver.unpack([String: Int8].self, from: Data())
        _ = try? unarchiver.unpack([String: Int16].self, from: Data())
        _ = try? unarchiver.unpack([String: Int32].self, from: Data())
        _ = try? unarchiver.unpack([String: Int64].self, from: Data())
        _ = try? unarchiver.unpack([String: UInt].self, from: Data())
        _ = try? unarchiver.unpack([String: UInt8].self, from: Data())
        _ = try? unarchiver.unpack([String: UInt16].self, from: Data())
        _ = try? unarchiver.unpack([String: UInt32].self, from: Data())
        _ = try? unarchiver.unpack([String: UInt64].self, from: Data())
        _ = try? unarchiver.unpack([String: Float].self, from: Data())
        _ = try? unarchiver.unpack([String: Double].self, from: Data())
        _ = try? unarchiver.unpack([String: CGFloat].self, from: Data())
        _ = try? unarchiver.unpack([String: String].self, from: Data())
        _ = try? unarchiver.unpack([String: Date].self, from: Data())
    }

}


