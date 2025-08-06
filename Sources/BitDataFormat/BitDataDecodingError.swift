//
//  BitDataDecodingError.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

/// Errors that can occur while decoding BitDataFormat data.
public enum BitDataDecodingError: Error {
    /// The version of the encoded format is not supported.
    case unsupportedVersion
    /// Unknown encoded data type.
    case unknownBitDataType
    /// Unknown encoded data sub-type.
    case unknownBitDataSubType
    /// The character is not found in the alphabet.
    case characterNotFoundInAlphabet(UInt8)
    /// The encoded data is not a valid UTF8 string.
    case failedToDecodeUTF8String
    /// The encoded number is too big to be decoded.
    case numberIsTooBig
    /// The encoded data is not a valid number.
    case failedToDecodeNumber(String)
    
    case typeMissmatch
    case missingDecoder
    case keyNotFound
}
