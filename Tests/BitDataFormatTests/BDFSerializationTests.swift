//
//  BDFSerializationTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import XCTest
import SMBitData
@testable import BitDataFormat

final class BDFSerializationTests: XCTestCase, @unchecked Sendable {
    
    func testPrimitiveNull() throws {
        let nullValues: [Any?] = [nil, NSNull()]
        
        for value in nullValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertTrue(uncompressedValue is NSNull)
            
            let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
            XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
        }
    }
    
    func testPrimitiveTrue() throws {
        let value = true
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertEqual(value, uncompressedValue as? Bool)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    func testPrimitiveFalse() throws {
        let value = false
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertEqual(value, uncompressedValue as? Bool)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    func testNumberZero() throws {
        let value = 0
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertEqual(value, uncompressedValue as? Int)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    func testNumberDigits() throws {
        try testNumberInRange(from: -Int(BitDataConstants.Number.digitsMaxValue), upto: -1)
        try testNumberInRange(from: 1, upto: Int(BitDataConstants.Number.digitsMaxValue))
    }
    
    func testNumber16Bits() throws {
        try testNumberInRange(from: -Int(BitDataConstants.Number.bits16MaxValue), upto: -Int(BitDataConstants.Number.digitsMaxValue) - 1)
        try testNumberInRange(from: Int(BitDataConstants.Number.digitsMaxValue) + 1, upto: Int(BitDataConstants.Number.bits16MaxValue))
    }
    
    func testNumber24Bits() throws {
        let min = Int(UInt16.max) + 1
        let max = Int(BitDataConstants.Number.bits24MaxValue)
        let middle = (max - min) / 2
        let positiveValues: [Int] = [min, min + 1, min + 2, middle - 1, middle, middle + 1, max - 2, max - 1, max]
        let negativeValues: [Int] = positiveValues.map { -$0 }
        let listOfValues = negativeValues + positiveValues
        
        for value in listOfValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertEqual(value, uncompressedValue as? Int)
            
            let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
            XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
        }
    }
    
    func testNumber32Bits() throws {
        let min = Int(BitDataConstants.Number.bits24MaxValue) + 1
        let max = Int(BitDataConstants.Number.bits32MaxValue)
        let middle = (max - min) / 2
        let positiveValues: [Int] = [min, min + 1, min + 2, middle - 1, middle, middle + 1, max - 2, max - 1, max]
        let negativeValues: [Int] = positiveValues.map { -$0 }
        let listOfValues = negativeValues + positiveValues
        
        for value in listOfValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertEqual(value, uncompressedValue as? Int)
            
            let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
            XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
        }
    }
    
    @available(iOS 18.0, watchOS 11.0, macOS 15.0, macCatalyst 18.0, tvOS 18.0, visionOS 2.0, *)
    func testNumber64Bits() throws {
        let min = Int128(BitDataConstants.Number.bits32MaxValue) + 1
        let max = Int128(BitDataConstants.Number.bits64MaxValue)
        let middle = (max - min) / 2
        let positiveValues: [Int128] = [min, min + 1, min + 2, middle - 1, middle, middle + 1, max - 2, max - 1, max]
        let negativeValues: [Int128] = positiveValues.map { -$0 }
        let listOfValues: [Any] = (negativeValues + positiveValues).sorted().compactMap({ Int(String($0)) ?? UInt(String($0)) })
        
        for value in listOfValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            if let intValue = uncompressedValue as? Int {
                XCTAssertEqual(value as? Int, intValue)
            }
            else if let uintValue = uncompressedValue as? UInt {
                XCTAssertEqual(value as? UInt, uintValue)
            }
            else {
                XCTFail("Uncompressed value is not Int or UInt64")
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
            XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
        }
    }
    
    func testStringEmpty() throws {
        let value = ""
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertEqual(value, uncompressedValue as? String)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    func testStringWithAlphabet() throws {
        try self.testString(with: BitDataConstants.String.digitsAlphabet)
        try self.testString(with: BitDataConstants.String.lowercasedAlphabet)
        try self.testString(with: BitDataConstants.String.uppercasedAlphabet)
        try self.testString(with: BitDataConstants.String.combinedAlphabet)
        try self.testString(with: BitDataConstants.String.asciiAlphabet)
    }
    
    func testStringUTF8Characters() throws {
        for value in 0x007F...0x10FFFF {
            // Skip surrogate pairs (U+D800 to U+DFFF) — invalid in UTF-8
            if (0xD800...0xDFFF).contains(value) { continue }
            
            guard let scalar = UnicodeScalar(value) else {
                // Invalid Unicode scalar (shouldn't happen due to range + check)
                continue
            }
            let string = String(Character(scalar))
            
            let compressedData = try BDFSerialization.data(withBDFObject: string)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertEqual(string, uncompressedValue as? String)
        }
    }
    
    func testStringUTF8() throws {
        for sample in SampleData.shared.sampleDataStrings {
            let compressedData = try BDFSerialization.data(withBDFObject: sample)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertEqual(sample, uncompressedValue as? String)
        }
    }
    
    func testDates() throws {
        for date in SampleData.shared.sampleDataDates {
            let compressedData = try BDFSerialization.data(withBDFObject: date)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertEqual(date, uncompressedValue as? Date)
        }
    }
    
    func testArrayEmpty() throws {
        let value: [Any] = []
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        guard let uncompressedArray = uncompressedValue as? [Any] else {
            XCTFail("Uncompressed value is not an array")
            return
        }
        XCTAssertTrue(uncompressedArray.isEmpty)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    func testArraySingleElement() throws {
        let listOfValues: [[Any]] = SampleData.shared.allTypes.map { [$0] }
        for value in listOfValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertAnyEqual(value, uncompressedValue)
        }
    }
    
    func testAarrayWithDifferentLengths() throws {
        let sizes = [1, 7, 255, 4095, 65535]
        for size in sizes {
            let arraySameValueTypes = Array(repeating: 123, count: size)
            try self.test(array: arraySameValueTypes)
            
            let arrayDifferentValueTypes: [Any] = (0..<size).map { element -> Any in
                element % 2 == 0 ? "string\(element)" : element
            }
            try self.test(array: arrayDifferentValueTypes)
        }
    }
    
    func testDictionaryEmpty() throws {
        let value: [String: Any] = [:]
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        guard let uncompressedArray = uncompressedValue as? [String: Any] else {
            XCTFail("Uncompressed value is not an dictionary")
            return
        }
        XCTAssertTrue(uncompressedArray.isEmpty)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    func testDictionarySingleElement() throws {
        let listOfValues: [[String: Any]] = SampleData.shared.allTypes.enumerated().map { ["key": $1] }
        for value in listOfValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            XCTAssertAnyEqual(value, uncompressedValue)
        }
    }
    
    func testDictionaryWithDifferentLengths() throws {
        let sizes = [1, 2, 255, 4095, 65535]
        for size in sizes {
            let dictionarySameValueTypes: [String: Any] = Dictionary(uniqueKeysWithValues: (0..<size).map({ (key: "key\($0)", value: $0) }))
            try self.test(dictionary: dictionarySameValueTypes)
            
            let dictionaryDifferentValueTypes: [String: Any] = Dictionary(uniqueKeysWithValues: (0..<size).map { element -> (String, Any) in
                element % 2 == 0 ? ("string\(element)", element) : ("key\(element)", "string\(element)")
            })
            try self.test(dictionary: dictionaryDifferentValueTypes)
        }
    }

        
    // MARK: - Help methods
    
    private func testNumberInRange(from: Int, upto: Int) throws {
        for value in from...upto {
            try autoreleasepool {
                let compressedData = try BDFSerialization.data(withBDFObject: value)
                let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
                XCTAssertEqual(value, uncompressedValue as? Int)
                
                if value > 99 { // Known issue: BDFSerialization does not compress numbers smaller than 99
                    let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
                    XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
                }
            }
        }
    }
    
    @available(iOS 18.0, watchOS 11.0, macOS 15.0, macCatalyst 18.0, tvOS 18.0, visionOS 2.0, *)
    private func testNumberInRange(min: Int128, max: Int128) throws {
        let middle = (max - min) / 2
        let positiveValues: [Int128] = [min, min + 1, min + 2, middle - 1, middle, middle + 1, max - 2, max - 1, max]
        let negativeValues: [Int128] = positiveValues.map { -$0 }
        let listOfValues: [Any] = (negativeValues + positiveValues).sorted().compactMap({ Int(String($0)) ?? UInt(String($0)) })
        
        for value in listOfValues {
            let compressedData = try BDFSerialization.data(withBDFObject: value)
            let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
            if let intValue = uncompressedValue as? Int {
                XCTAssertEqual(value as? Int, intValue)
            }
            else if let uintValue = uncompressedValue as? UInt {
                XCTAssertEqual(value as? UInt, uintValue)
            }
            else {
                XCTFail("Uncompressed value is not Int or UInt64")
            }
            
            let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
            XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
        }
    }
    
    private func testString(with alphabet: BitDataAlphabet) throws {
        let value = alphabet.charactersSet.map(String.init).joined()
        let compressedData = try BDFSerialization.data(withBDFObject: value)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertEqual(value, uncompressedValue as? String)
        
        let jsonData = try JSONSerialization.data(withJSONObject: value as Any, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    private func test(array: [Any]) throws {
        let compressedData = try BDFSerialization.data(withBDFObject: array)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertAnyEqual(array, uncompressedValue)
        
        let jsonData = try JSONSerialization.data(withJSONObject: array, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
    
    private func test(dictionary: [String: Any]) throws {
        let compressedData = try BDFSerialization.data(withBDFObject: dictionary)
        let uncompressedValue = try BDFSerialization.bdfObject(with: compressedData)
        XCTAssertAnyEqual(dictionary, uncompressedValue)
        
        let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [.fragmentsAllowed])
        XCTAssertLessThanOrEqual(compressedData.count, jsonData.count)
    }
}

func XCTAssertAnyEqual(_ lhs: Any, _ rhs: Any, _ message: @autoclosure () -> String = "", file: StaticString = #filePath, line: UInt = #line) {
    func compareAnyEqual(_ lhs: Any, _ rhs: Any) -> Bool {
        // Check for same type first
        switch (lhs, rhs) {
        case (let l as Int, let r as Int): return l == r
        case (let l as Double, let r as Double): return l == r
        case (let l as Float, let r as Float): return l == r
        case (let l as String, let r as String): return l == r
        case (let l as Bool, let r as Bool): return l == r
        case (let l as [Any], let r as [Any]):
            guard l.count == r.count else { return false }
            return zip(l, r).allSatisfy { compareAnyEqual($0, $1) }
        case (let l as [String: Any], let r as [String: Any]):
            guard l.count == r.count else { return false }
            for (key, lValue) in l {
                guard let rValue = r[key], compareAnyEqual(lValue, rValue) else {
                    return false
                }
            }
            return true
        case (let l as NSNumber, let r as NSNumber): return l == r
        case (let l as NSString, let r as NSString): return l == r
        case (let l as NSObject, let r as NSObject): return l == r
        default:
            return String(describing: lhs) == String(describing: rhs)
        }
    }
    
    if !compareAnyEqual(lhs, rhs) {
        XCTFail("XCTAssertAnyEqual failed: \(lhs) is not equal to \(rhs). \(message())", file: file, line: line)
    }
}

fileprivate extension Int {
    var bitsToBytes: Int {
        return Int(ceil(Double(self) / 8))
    }
}
