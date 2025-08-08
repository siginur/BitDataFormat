//
//  BDFCodableContainerCoverageTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 07/08/2025.
//

import XCTest
@testable import BitDataFormat

final class BDFCodableContainerCoverageTests: XCTestCase {

    // MARK: - Models
    
    struct SingleValueModel: Codable, Equatable {
        let number: Int
    }
    
    struct NilValueModel: Codable, Equatable {
        let optionalString: String?
    }
    
    struct NestedKeyedContainerModel: Codable, Equatable {
        struct Inner: Codable, Equatable {
            let value: String
        }
        let inner: Inner
    }
    
    struct NestedUnkeyedContainerModel: Codable, Equatable {
        let items: [String]
    }
    
    class Superclass: Codable, Equatable {
        var id: String = "super"
        
        required init() {}
        static func == (lhs: Superclass, rhs: Superclass) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    class Subclass: Superclass {
        var name: String = ""
        
        private enum CodingKeys: String, CodingKey {
            case name
            case superpuper
        }
        
        required init() {
            self.name = "sub"
            super.init()
        }
        
        init(name: String) {
            self.name = name
            super.init()
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            name = try container.decode(String.self, forKey: .name)
            try super.init(from: decoder)
        }
        
        override func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(name, forKey: .name)
            try super.encode(to: encoder)
        }
        
        static func == (lhs: Subclass, rhs: Subclass) -> Bool {
            lhs.id == rhs.id && lhs.name == rhs.name
        }
    }
    
    struct SuperKeyedModel: Codable, Equatable {
        let subclass: Subclass
    }
    
    struct SuperUnkeyedModel: Codable, Equatable {
        let list: [Subclass]
    }
    
    // MARK: - Container Tests
    
    func testSingleValueEncoding() {
        encodeDecode(SingleValueModel(number: 123))
    }
    
    func testEncodeDecodeNil() {
        encodeDecode(NilValueModel(optionalString: nil))
    }
    
    func testKeyedEncodingContainer() {
        struct Model: Codable, Equatable {
            let a: String
            let b: Int
        }
        encodeDecode(Model(a: "abc", b: 321))
    }
    
    func testUnkeyedEncodingContainer() {
        encodeDecode([1, 2, 3, 4])
    }
    
    func testNestedKeyedContainer() {
        encodeDecode(NestedKeyedContainerModel(inner: .init(value: "deep")))
    }
    
    func testNestedUnkeyedContainer() {
        encodeDecode(NestedUnkeyedContainerModel(items: ["a", "b", "c"]))
    }
    
    func testSubclass() {
        let subclass = Subclass()
        subclass.id = "id-value"
        subclass.name = "name-value"
        encodeDecode(subclass)
    }
    
    func testSuperEncoderForKey() {
        let subclass = Subclass()
        subclass.id = "base"
        subclass.name = "subclass"
        encodeDecode(SuperKeyedModel(subclass: subclass))
    }
    
    func testSuperEncoderFromUnkeyed() {
        encodeDecode(SuperUnkeyedModel(list: {
            let a = Subclass(); a.id = "one"; a.name = "alpha"
            let b = Subclass(); b.id = "two"; b.name = "beta"
            return [a, b]
        }()))
    }
    
    func testSuperDecoderWorksWithUnkeyedList() {
        encodeDecode(SuperUnkeyedModel(list: [Subclass()]))
    }
    
    func testSuperDecoderFromKeyedStructure() {
        encodeDecode(SuperKeyedModel(subclass: Subclass()))
    }
    
    // MARK: - Help methods
    
    private func encodeDecode<T: Codable & Equatable>(_ value: T, file: StaticString = #filePath, line: UInt = #line) {
        do {
            let encoder = BDFEncoder()
            let data = try encoder.encode(value)
            let decoder = BDFDecoder()
            let decoded = try decoder.decode(T.self, from: data)
            XCTAssertEqual(decoded, value)
        } catch {
            XCTFail("Failed to encode/decode \(value): \(error)", file: file, line: line)
        }
    }

}
