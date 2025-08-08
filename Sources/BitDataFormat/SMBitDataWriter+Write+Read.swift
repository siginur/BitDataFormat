//
//  SMBitDataWriter+Write.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import SMBitData

extension SMBitDataWriter {
    func writeDataTypeSignature(_ type: BitDataType) {
        self.writeBits(type.bits, count: BitDataType.sizeInBits)
    }
    
    func writeDataSubTypeSignature(_ type: BitDataSubType) {
        self.writeBits(type.bits, count: type.sizeInBits)
    }
    
    func writeUInt12(_ value: UInt16) {
        self.writeBits(UInt8(value >> 8), count: 4)
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeUInt24(_ value: UInt32) {
        self.writeBits(UInt8((value & 0x00FF0000) >> 16), count: 8)
        self.writeBits(UInt8((value & 0x0000FF00) >> 8), count: 8)
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeBytes(_ value: UInt16) {
        self.writeByte(UInt8(value >> 8))
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeBytes(_ value: UInt32) {
        self.writeByte(UInt8(value >> 24))
        self.writeByte(UInt8((value & 0x00FF0000) >> 16))
        self.writeByte(UInt8((value & 0x0000FF00) >> 8))
        self.writeByte(UInt8(value & 0xFF))
    }
    
    func writeBytes(_ value: UInt64) {
        self.writeByte(UInt8(value >> 56))
        self.writeByte(UInt8((value & 0x00FF000000000000) >> 48))
        self.writeByte(UInt8((value & 0x0000FF0000000000) >> 40))
        self.writeByte(UInt8((value & 0x000000FF00000000) >> 32))
        self.writeByte(UInt8((value & 0x00000000FF000000) >> 24))
        self.writeByte(UInt8((value & 0x0000000000FF0000) >> 16))
        self.writeByte(UInt8((value & 0x000000000000FF00) >> 8))
        self.writeByte(UInt8(value & 0xFF))
    }
}

extension SMBitDataReader {
    
    func readDataTypeSignature() throws -> BitDataType? {
        let bits = try self.readBits(BitDataType.sizeInBits)
        return BitDataType(bits: bits)
    }
    
    func readDataSubTypeSignature(for dataType: BitDataType) throws -> BitDataSubType? {
        let bits = try self.readBits(dataType.subTypeSizeInBits)
        return BitDataSubType(type: dataType, bits: bits)
    }
    
    func readUInt16() throws -> UInt16 {
        let highByte = try self.readByte()
        let lowByte = try self.readByte()
        return (UInt16(highByte) << 8) | UInt16(lowByte)
    }
    
    func readUInt24() throws -> UInt32 {
        let bytes = try self.readBytes(3)
        return (UInt32(bytes[0]) << 16) | (UInt32(bytes[1]) << 8) | UInt32(bytes[2])
    }
    
    func readUInt32() throws -> UInt32 {
        let bytes = try self.readBytes(4)
        return (UInt32(bytes[0]) << 24) | (UInt32(bytes[1]) << 16) | (UInt32(bytes[2]) << 8) | UInt32(bytes[3])
    }
    
    func readUInt64() throws -> UInt64 {
        let bytes = try self.readBytes(8)
        return (UInt64(bytes[0]) << 56) | (UInt64(bytes[1]) << 48) |
        (UInt64(bytes[2]) << 40) | (UInt64(bytes[3]) << 32) |
        (UInt64(bytes[4]) << 24) | (UInt64(bytes[5]) << 16) |
        (UInt64(bytes[6]) << 8) | UInt64(bytes[7])
    }
}
