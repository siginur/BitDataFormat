//
//  BDFEncoderBDFDecoderTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 05/08/2025.
//

import XCTest
import SMBitData
@testable import BitDataFormat

final class BDFEncoderBDFDecoderTests: XCTestCase {
    
    // MARK: - Primitives
    
    func testNilOptional() {
        struct Test: Codable, Equatable { let value: Int? }
        let val: Test = Test(value: nil)
        self.encodeDecode(val)
    }
        
    func testBool() {
        self.encodeDecode(true)
        self.encodeDecode(false)
    }
    
    func testNumbers() {
        self.encodeDecode(0)
        self.encodeDecode(BitDataConstants.Number.digitsMaxValue)
        self.encodeDecode(BitDataConstants.Number.bits16MaxValue)
        self.encodeDecode(BitDataConstants.Number.bits24MaxValue)
        self.encodeDecode(BitDataConstants.Number.bits32MaxValue)
        self.encodeDecode(BitDataConstants.Number.bits64MaxValue)
        self.encodeDecode(-BitDataConstants.Number.digitsMaxValue)
        self.encodeDecode(-Int(BitDataConstants.Number.bits16MaxValue))
        self.encodeDecode(-BitDataConstants.Number.bits24MaxValue)
        self.encodeDecode(-Int(BitDataConstants.Number.bits32MaxValue))
//        if #available(macOS 15.0, *) {
//            self.encodeDecode(-Int128(BitDataConstants.Number.bits64MaxValue))
//        }
    }
    
    func testInts() {
        self.encodeDecode(Int.min + 1)
        self.encodeDecode(Int.max)
        self.encodeDecode(Int8.min)
        self.encodeDecode(Int8.max)
        self.encodeDecode(Int16.min)
        self.encodeDecode(Int16.max)
        self.encodeDecode(Int32.min)
        self.encodeDecode(Int32.max)
        self.encodeDecode(Int64.min + 1)
        self.encodeDecode(Int64.max)
    }
    
    func testDouble() {
        self.encodeDecode(0.0)
        self.encodeDecode(1.234567)
        self.encodeDecode(-1.234567)
//        self.encodeDecode(Double.greatestFiniteMagnitude)
//        self.encodeDecode(Double.infinity)
//        self.encodeDecode(-Double.greatestFiniteMagnitude)
//        self.encodeDecode(-Double.infinity)
//        self.encodeDecode(Float.greatestFiniteMagnitude)
//        self.encodeDecode(Float.infinity)
//        self.encodeDecode(-Float.greatestFiniteMagnitude)
//        self.encodeDecode(-Float.infinity)
//        self.encodeDecode(CGFloat.greatestFiniteMagnitude)
//        self.encodeDecode(CGFloat.infinity)
//        self.encodeDecode(-CGFloat.greatestFiniteMagnitude)
//        self.encodeDecode(-CGFloat.infinity)
    }
    
    func testUints() {
        self.encodeDecode(UInt.min)
        self.encodeDecode(UInt.max)
        self.encodeDecode(UInt8.min)
        self.encodeDecode(UInt8.max)
        self.encodeDecode(UInt16.min)
        self.encodeDecode(UInt16.max)
        self.encodeDecode(UInt32.min)
        self.encodeDecode(UInt32.max)
        self.encodeDecode(UInt64.min)
        self.encodeDecode(UInt64.max)
    }
    
    func testStrings() {
        for string in SampleData.shared.sampleDataStrings {
            self.encodeDecode(string)
        }
    }
    
    func testDates() {
        for date in SampleData.shared.sampleDataDates {
            self.encodeDecode(date)
            self.encodeDecode(date)
        }
    }
    
    func testArray() {
        self.encodeDecode([1, 2, 3] as [Int])
        self.encodeDecode([1, 2, 3] as [Int8])
        self.encodeDecode([1, 2, 3] as [Int16])
        self.encodeDecode([1, 2, 3] as [Int32])
        self.encodeDecode([1, 2, 3] as [Int64])
        self.encodeDecode([1, 2, 3] as [UInt])
        self.encodeDecode([1, 2, 3] as [UInt8])
        self.encodeDecode([1, 2, 3] as [UInt16])
        self.encodeDecode([1, 2, 3] as [UInt32])
        self.encodeDecode([1, 2, 3] as [UInt64])
        self.encodeDecode([[1], [2], [3]])
        self.encodeDecode([["key1": 1], ["key2": 2]])
        self.encodeDecode([true, false])
        self.encodeDecode(["a", "b", "c"])
    }
    
    func testArraysOfDifferentSizes() {
        let sizes = [0, 1, BitDataConstants.Collection.maxSizeForUsingSeparator, 255, 4095, 65535]

        for size in sizes {
            self.encodeDecode(Array(0..<size))
            self.encodeDecode((0..<size).map { "Item \($0)" })
            self.encodeDecode((0..<size).map { $0 % 2 == 0 })
            self.encodeDecode((0..<size).map { Person(name: "Person \($0)") })
            self.encodeDecode((0..<size).map { ["key": "value \($0)"] })
        }
    }
    
    func testDictionary() {
        self.encodeDecode(["bool": true])
        self.encodeDecode(["int": Int(123)])
        self.encodeDecode(["int8": Int8(8)])
        self.encodeDecode(["int16": Int16(16)])
        self.encodeDecode(["int32": Int32(32)])
        self.encodeDecode(["int64": Int64(64)])
        self.encodeDecode(["uInt": UInt(123)])
        self.encodeDecode(["uInt8": UInt8(8)])
        self.encodeDecode(["uInt16": UInt16(16)])
        self.encodeDecode(["uInt32": UInt32(32)])
        self.encodeDecode(["uInt64": UInt64(64)])
        self.encodeDecode(["str": "hello"])
        self.encodeDecode(["nested": ["key": "value"]])
        self.encodeDecode(["array": [1, 2, 3]])
    }
    
    func testDictionariesOfDifferentSizes() {
        let sizes = [0, 1, BitDataConstants.Collection.maxSizeForUsingSeparator, 255, 4095, 65535]

        for size in sizes {
            let intDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", $0) })
            self.encodeDecode(intDict)

            let stringDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", "Value \($0)") })
            self.encodeDecode(stringDict)

            let boolDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", $0 % 2 == 0) })
            self.encodeDecode(boolDict)

            let objectDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", Person(name: "Person \($0)")) })
            self.encodeDecode(objectDict)

            let nestedDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", ["innerKey": "innerValue \($0)"]) })
            self.encodeDecode(nestedDict)
        }
    }
    
    // MARK: - Classes and structs
    
    func testSimpleClass() {
        final class SimpleClass: Codable, Equatable {
            let name: String
            let age: Int
            
            init(name: String, age: Int) {
                self.name = name
                self.age = age
            }
            
            static func == (lhs: SimpleClass, rhs: SimpleClass) -> Bool {
                lhs.name == rhs.name && lhs.age == rhs.age
            }
        }
        
        let obj = SimpleClass(name: "Alice", age: 28)
        encodeDecode(obj)
    }
    
    func testInheritedClass() {
        let dog = Dog(species: "Canine", breed: "Labrador")
        encodeDecode(dog)
    }
    
    func testClassWithOptionalProperties() {
        final class OptionalClass: Codable, Equatable {
            let name: String?
            let count: Int?
            
            init(name: String?, count: Int?) {
                self.name = name
                self.count = count
            }
            
            static func == (lhs: OptionalClass, rhs: OptionalClass) -> Bool {
                lhs.name == rhs.name && lhs.count == rhs.count
            }
        }
        
        encodeDecode(OptionalClass(name: "Optional", count: nil))
        encodeDecode(OptionalClass(name: nil, count: 42))
    }
    
    func testNestedClass() {
        final class OuterClass: Codable, Equatable {
            final class InnerClass: Codable, Equatable {
                let value: String
                
                init(value: String) {
                    self.value = value
                }
                
                static func == (lhs: InnerClass, rhs: InnerClass) -> Bool {
                    lhs.value == rhs.value
                }
            }
            
            let inner: InnerClass
            let count: Int
            
            init(inner: InnerClass, count: Int) {
                self.inner = inner
                self.count = count
            }
            
            static func == (lhs: OuterClass, rhs: OuterClass) -> Bool {
                lhs.count == rhs.count && lhs.inner == rhs.inner
            }
        }
        
        let obj = OuterClass(inner: OuterClass.InnerClass(value: "Nested"), count: 10)
        encodeDecode(obj)
    }
    
    func testCollectionOfClasses() {
        encodeDecode([
            Dog(species: "Canine", breed: "Beagle"),
            Dog(species: "Canine", breed: "Husky"),
        ])
        
        encodeDecode([
            "dog1": Dog(species: "Canine", breed: "Beagle"),
            "dog2": Dog(species: "Canine", breed: "Husky"),
        ])
    }
    
    // MARK: - Help methods
    
    private func encodeDecode<T: Codable & Equatable>(_ value: T, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let encoder = BDFEncoder()
            let data = try encoder.encode(value)
            let decoder = BDFDecoder()
            let decoded = try decoder.decode(T.self, from: data)
//            print("Encoded and decoded value: \(value) \(decoded)")
            XCTAssertEqual(decoded, value)
        } catch {
            XCTFail("Failed to encode/decode \(value): \(error)", file: file, line: line)
        }
    }
    
}
