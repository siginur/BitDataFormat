//
//  BitDataDecodingError.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

/// Errors that can occur while decoding BitDataFormat data.
public enum BitDataDecodingError: Error {
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
    /// Expected and actual types do not match.
    case typeMissmatch
    /// The decoder is missing.
    case missingDecoder
    /// The key is not found in the encoded data.
    case keyNotFound
}
