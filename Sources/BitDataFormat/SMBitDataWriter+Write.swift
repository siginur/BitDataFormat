//
//  SMBitDataWriter+Write.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import SMBitData

extension SMBitDataWriter {
    func writeTypeSignature(_ type: BitDataType) {
        self.writeBits(type.bits, count: BitDataType.sizeInBits)
    }
    
    func writeTypeSignature(_ type: BitDataSubType) {
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

}
