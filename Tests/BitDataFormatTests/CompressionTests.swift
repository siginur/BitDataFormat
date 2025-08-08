//
//  CompressionTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import XCTest
@testable import BitDataFormat

final class CompressionTests: XCTestCase {

    func testExample() throws {
        // Primitives
        printStats(for: NSNull(), message: "null")
        printStats(for: true, message: "Boolean true")
        printStats(for: false, message: "Boolean false")
        prinStatsSeparator()
        
        // Numbers
        let numbers = [1, 2, 9, 10, 15, 16, 99, 100, 127, 128, 255, 256, 511, 512, 999, 1000, 1023, 1024] + SampleData.shared.sampleDataNumbers
        printStats(for: 0, message: "Zero")
        for number in numbers {
            printStats(for: number, message: "Number \(number)")
        }
        prinStatsSeparator()
        
        // Strings
        let strings: [(message: String, value: String)] = [
            ("empty", ""),
            ("digital", BitDataConstants.String.digitsAlphabet.charactersSet.map(String.init).joined()),
            ("lowercased", BitDataConstants.String.lowercasedAlphabet.charactersSet.map(String.init).joined()),
            ("uppercased", BitDataConstants.String.uppercasedAlphabet.charactersSet.map(String.init).joined()),
            ("combined", BitDataConstants.String.combinedAlphabet.charactersSet.map(String.init).joined()),
            ("ascii", BitDataConstants.String.asciiAlphabet.charactersSet.map(String.init).joined()),
            ("utf8 15 bytes", SampleData.generateString(maxByteSize: 15, characters: SampleData.shared.emojiAndSymbols)),
            ("utf8 255 bytes", SampleData.generateString(maxByteSize: 255, characters: SampleData.shared.chineseCharacters)),
            ("utf8 4095 bytes", SampleData.generateString(maxByteSize: 4095, characters: SampleData.shared.greekCharacters)),
            ("utf8 65535 bytes", SampleData.generateString(maxByteSize: 65535, characters: SampleData.shared.hebrewCharacters))
        ]
        for string in strings {
            printStats(for: string.value, message: "String " + string.message)
        }
        prinStatsSeparator()
        
        // Arrays
        printStats(for: [], message: "Array empty")
        printStats(for: [NSNull()], message: "Array of single null")
        printStats(for: [true], message: "Array of single boolean")
        for number in numbers {
            printStats(for: [number], message: "Array of single number \(number)")
        }
        for string in strings {
            printStats(for: [string.value], message: "Array of single string \(string.message)")
        }
        printStats(for: numbers, message: "Array of numbers")
        printStats(for: strings.map({ $0.value }), message: "Array of strings")
        prinStatsSeparator()
        
        // Dictionaries
        printStats(for: [:], message: "Dictionary empty")
        printStats(for: ["key": "value"], message: "Dictionary with single pair")
        printStats(for: ["key": true], message: "Dictionary with boolean value")
        printStats(for: ["key": 123], message: "Dictionary with number value")
        printStats(for: ["key": "string"], message: "Dictionary with string value")
        prinStatsSeparator()
    }
    
    
    func printStats(for value: Any, message: String) {
        let (sizeInBits, encodedData) = try! BDFSerialization.dataWithStats(withBDFObject: value)
        let decodedValue = try! BDFSerialization.bdfObject(with: encodedData)
        XCTAssertAnyEqual(value, decodedValue, "Decoded value does not match original for \(message)")
        let json = try! JSONSerialization.data(withJSONObject: value, options: .fragmentsAllowed)
        
        let extraBits = -Int(UInt64(encodedData.count) * 8 - sizeInBits) + 8
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        let comporession = -(1 - Double(encodedData.count) / Double(json.count)) * 100
        let compressionString = (comporession <= 0 ? "" : "+") + (comporession != 0 ? formatter.string(for: comporession)! + "%" : "")
        
        if isCSV {
            print("\(message), \(sizeInBits), \(encodedData.count), \(extraBits), \(json.count), \(compressionString)")
        }
        else {
            print("[Stats] \(message), bits: \(sizeInBits), bytes: \(encodedData.count), extra: \(extraBits), json: \(json.count), compression: \(compressionString)")
        }
    }
    
    func prinStatsSeparator() {
        if isCSV {
            print("")
        }
        else {
            print("[Stats]", String(repeating: "=", count: 30))
        }
    }

}

fileprivate let isCSV = true
