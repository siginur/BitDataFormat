//
//  BitDataEncodingError.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

/// Errors that can occur while encoding objects to BitDataFormat data.
public enum BitDataEncodingError: Error {
    /// The type of the object is not supported.
    case unsupportedType(Any.Type)
    /// The character is not found in the alphabet.
    case characterNotFoundInAlphabet(Character)
    /// The string cannot be encoded as UTF8.
    case failedToEncodeUTF8String(String)
    /// The string is too long to be encoded.
    case stringIsTooLong(Int)
    /// The collection is too big to be encoded.
    case collectionIsTooBig(Int)
    /// The number is too big to be encoded.
    case numberIsTooBig
}
