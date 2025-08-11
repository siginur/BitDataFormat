//
//  BDFSchemaEncoderBDFSchemaDecoderTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 08/08/2025.
//

import XCTest
@testable import BitDataFormat

final class BDFSchemaEncoderBDFSchemaDecoderTests: XCTestCase {
    
    func testSchemaClass() throws {
        let value = AllSchemaItemTypes(
            bool: true,
            int: 1,
            int8: 2,
            int16: 3,
            int32: 4,
            int64: 5,
            uint: 6,
            uint8: 7,
            uint16: 8,
            uint32: 9,
            uint64: 10,
            float: 11.12,
            double: 13.14,
            string: "string",
            date: .init(timeIntervalSince1970: 1_000_000),
            enum: .value1,
            child: .init(id: 2, name: "name"),
            parent: .init(id: 1),
            arraysClass: .init(
                bool: [true, false],
                int: [1, 2, 3],
                int8: [4],
                int16: [5, 6, 7, 8],
                int32: [9, 10, 11, 12, 13, 14],
                int64: [15, 16, 17, 18, 19, 20, 21],
                uint: [22, 23, 24],
                uint8: [25, 26, 27, 28],
                uint16: [29, 30, 31, 32],
                uint32: [33, 34, 35, 36, 37, 38],
                uint64: [39, 40, 41, 42, 43, 44, 45],
                float: [46.47, 48.49],
                double: [50.51, 52.53, 54.55],
                string: ["string1", "string2", "string3"],
                date: [.init(timeIntervalSince1970: 1_000_000.123), .init(timeIntervalSince1970: 2_000_000)],
                enum: [.value1, .value2]
            ),
            dictionaries: .init(
                bool: ["key1": true, "key2": false],
                int: ["key3": 1, "key4": 2, "key5": 3],
                int8: ["key6": 4],
                int16: ["key7": 5, "key8": 6, "key9": 7, "key10": 8],
                int32: ["key11": 9, "key12": 10, "key13": 11, "key14": 12, "key15": 13, "key16": 14],
                int64: ["key17": 15, "key18": 16, "key19": 17, "key20": 18, "key21": 19, "key22": 20, "key23": 21],
                uint: ["key24": 22, "key25": 23, "key26": 24],
                uint8: ["key27": 25, "key28": 26, "key29": 27, "key30": 28],
                uint16: ["key31": 29, "key32": 30, "key33": 31, "key34": 32],
                uint32: ["key35": 33, "key36": 34, "key37": 35, "key38": 36, "key39": 37, "key40": 38],
                uint64: ["key41": 39, "key42": 40, "key43": 41, "key44": 42, "key45": 41, "key46": 42, "key47": 43, "key48": 44, "key49": 45],
                float: ["key50": 46.47, "key51": 48.49],
                double: ["key52": 50.51, "key53": 52.53, "key54": 54.55],
                string: ["key55": "string1", "key56": "string2", "key57": "string3"],
                date: ["key58": .init(timeIntervalSince1970: 1_000_000), "key59": .init(timeIntervalSince1970: 2_000_000.5)],
                enum: ["key60": .value1, "key61": .value2]
            ),
        )
        try encodeDecode(value)
    }
    
    func testSchemaClassWithNils() throws {
        let listOfValues = [
            SchemaWithNilsClass(
                id: 195,
                name: "some name",
                score: nil
            ),
            SchemaWithNilsClass(
                id: 842,
                name: "some other name",
                score: 65.23
            )
        ]
        
        for value in listOfValues {
            try encodeDecode(value)
        }
    }
    
    // MARK: - Models
    
    enum SchemaEnum: Int, BDFSchemaCodable {
        case value1
        case value2
        
        init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
            let rawValue = try decoder.decode() as Int
            guard let value = SchemaEnum(rawValue: rawValue) else {
                throw BitDataDecodingError.typeMissmatch
            }
            self = value
        }
        
        func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
            try encoder.encode(self.rawValue)
        }
    }
    
    class ArraysSchemaClass: BDFSchemaCodable, Equatable {
        let bool: [Bool]
        let int: [Int]
        let int8: [Int8]
        let int16: [Int16]
        let int32: [Int32]
        let int64: [Int64]
        let uint: [UInt]
        let uint8: [UInt8]
        let uint16: [UInt16]
        let uint32: [UInt32]
        let uint64: [UInt64]
        let float: [Float]
        let double: [Double]
        let string: [String]
        let date: [Date]
        let `enum`: [SchemaEnum]
        
        init(bool: [Bool], int: [Int], int8: [Int8], int16: [Int16], int32: [Int32], int64: [Int64], uint: [UInt], uint8: [UInt8], uint16: [UInt16], uint32: [UInt32], uint64: [UInt64], float: [Float], double: [Double], string: [String], date: [Date], enum: [SchemaEnum]) {
            self.bool = bool
            self.int = int
            self.int8 = int8
            self.int16 = int16
            self.int32 = int32
            self.int64 = int64
            self.uint = uint
            self.uint8 = uint8
            self.uint16 = uint16
            self.uint32 = uint32
            self.uint64 = uint64
            self.float = float
            self.double = double
            self.string = string
            self.date = date
            self.enum = `enum`
        }
        
        required init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
            self.bool = try decoder.decode()
            self.int = try decoder.decode()
            self.int8 = try decoder.decode()
            self.int16 = try decoder.decode()
            self.int32 = try decoder.decode()
            self.int64 = try decoder.decode()
            self.uint = try decoder.decode()
            self.uint8 = try decoder.decode()
            self.uint16 = try decoder.decode()
            self.uint32 = try decoder.decode()
            self.uint64 = try decoder.decode()
            self.float = try decoder.decode()
            self.double = try decoder.decode()
            self.string = try decoder.decode()
            self.date = try decoder.decode()
            self.enum = try decoder.decode(SchemaEnum.self)
        }
        
        func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
            try encoder.encode(self.bool)
            try encoder.encode(self.int)
            try encoder.encode(self.int8)
            try encoder.encode(self.int16)
            try encoder.encode(self.int32)
            try encoder.encode(self.int64)
            try encoder.encode(self.uint)
            try encoder.encode(self.uint8)
            try encoder.encode(self.uint16)
            try encoder.encode(self.uint32)
            try encoder.encode(self.uint64)
            try encoder.encode(self.float)
            try encoder.encode(self.double)
            try encoder.encode(self.string)
            try encoder.encode(self.date)
            try encoder.encode(self.enum)
        }
        
        static func == (lhs: ArraysSchemaClass, rhs: ArraysSchemaClass) -> Bool {
            lhs.bool == rhs.bool &&
            lhs.int == rhs.int &&
            lhs.int8 == rhs.int8 &&
            lhs.int16 == rhs.int16 &&
            lhs.int32 == rhs.int32 &&
            lhs.int64 == rhs.int64 &&
            lhs.uint == rhs.uint &&
            lhs.uint8 == rhs.uint8 &&
            lhs.uint16 == rhs.uint16 &&
            lhs.uint32 == rhs.uint32 &&
            lhs.uint64 == rhs.uint64 &&
            lhs.float == rhs.float &&
            lhs.double == rhs.double &&
            lhs.string == rhs.string &&
            lhs.date == rhs.date &&
            lhs.enum == rhs.enum
        }
    }

    class DictionariesSchemaClass: BDFSchemaCodable, Equatable {
        let bool: [String: Bool]
        let int: [String: Int]
        let int8: [String: Int8]
        let int16: [String: Int16]
        let int32: [String: Int32]
        let int64: [String: Int64]
        let uint: [String: UInt]
        let uint8: [String: UInt8]
        let uint16: [String: UInt16]
        let uint32: [String: UInt32]
        let uint64: [String: UInt64]
        let float: [String: Float]
        let double: [String: Double]
        let string: [String: String]
        let date: [String: Date]
        let `enum`: [String: SchemaEnum]
        
        init(bool: [String: Bool], int: [String: Int], int8: [String: Int8], int16: [String: Int16], int32: [String: Int32], int64: [String: Int64], uint: [String: UInt], uint8: [String: UInt8], uint16: [String: UInt16], uint32: [String: UInt32], uint64: [String: UInt64], float: [String: Float], double: [String: Double], string: [String: String], date: [String: Date], enum: [String: SchemaEnum]) {
            self.bool = bool
            self.int = int
            self.int8 = int8
            self.int16 = int16
            self.int32 = int32
            self.int64 = int64
            self.uint = uint
            self.uint8 = uint8
            self.uint16 = uint16
            self.uint32 = uint32
            self.uint64 = uint64
            self.float = float
            self.double = double
            self.string = string
            self.date = date
            self.enum = `enum`
        }
        
        required init(from decoder: any BDFSchemaDecoder) throws {
            self.bool = try decoder.decode()
            self.int = try decoder.decode()
            self.int8 = try decoder.decode()
            self.int16 = try decoder.decode()
            self.int32 = try decoder.decode()
            self.int64 = try decoder.decode()
            self.uint = try decoder.decode()
            self.uint8 = try decoder.decode()
            self.uint16 = try decoder.decode()
            self.uint32 = try decoder.decode()
            self.uint64 = try decoder.decode()
            self.float = try decoder.decode()
            self.double = try decoder.decode()
            self.string = try decoder.decode()
            self.date = try decoder.decode()
            self.enum = try decoder.decode(SchemaEnum.self)
        }
        
        func encode(to encoder: any BDFSchemaEncoder) throws {
            try encoder.encode(self.bool)
            try encoder.encode(self.int)
            try encoder.encode(self.int8)
            try encoder.encode(self.int16)
            try encoder.encode(self.int32)
            try encoder.encode(self.int64)
            try encoder.encode(self.uint)
            try encoder.encode(self.uint8)
            try encoder.encode(self.uint16)
            try encoder.encode(self.uint32)
            try encoder.encode(self.uint64)
            try encoder.encode(self.float)
            try encoder.encode(self.double)
            try encoder.encode(self.string)
            try encoder.encode(self.date)
            try encoder.encode(self.enum)
        }
        
        static func == (lhs: DictionariesSchemaClass, rhs: DictionariesSchemaClass) -> Bool {
            lhs.bool == rhs.bool &&
            lhs.int == rhs.int &&
            lhs.int8 == rhs.int8 &&
            lhs.int16 == rhs.int16 &&
            lhs.int32 == rhs.int32 &&
            lhs.int64 == rhs.int64 &&
            lhs.uint == rhs.uint &&
            lhs.uint8 == rhs.uint8 &&
            lhs.uint16 == rhs.uint16 &&
            lhs.uint32 == rhs.uint32 &&
            lhs.uint64 == rhs.uint64 &&
            lhs.float == rhs.float &&
            lhs.double == rhs.double &&
            lhs.string == rhs.string &&
            lhs.date == rhs.date &&
            lhs.enum == rhs.enum
        }
    }

    class ParentClass: BDFSchemaCodable, Equatable {
        let id: Int
        
        init(id: Int) {
            self.id = id
        }
        
        required init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
            self.id = try decoder.decode()
        }
        
        func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
            try encoder.encode(self.id)
        }
        
        static func == (lhs: ParentClass, rhs: ParentClass) -> Bool {
            lhs.id == rhs.id
        }
    }

    class ChildClass: ParentClass {
        let name: String
        
        init(id: Int, name: String) {
            self.name = name
            super.init(id: id)
        }
        
        required init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
            self.name = try decoder.decode()
            try super.init(from: decoder)
        }
        
        override func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
            try encoder.encode(self.name)
            try super.encode(to: encoder)
        }
        
        static func == (lhs: ChildClass, rhs: ChildClass) -> Bool {
            lhs.id == rhs.id && lhs.name == rhs.name
        }
    }
    
    class SchemaWithNilsClass: ParentClass {
        let name: String
        let score: CGFloat?

        init(id: Int, name: String, score: CGFloat?) {
            self.name = name
            self.score = score
            super.init(id: id)
        }
        
        required init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
            self.name = try decoder.decode()
            self.score = try decoder.decodeIfPresent()
            try super.init(from: decoder)
        }
        
        override func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
            try encoder.encode(self.name)
            try encoder.encodeIfPresent(self.score)
            try super.encode(to: encoder)
        }
        
        static func == (lhs: SchemaWithNilsClass, rhs: SchemaWithNilsClass) -> Bool {
            lhs.id == rhs.id && lhs.name == rhs.name && lhs.score == rhs.score
        }
    }

    struct AllSchemaItemTypes: BDFSchemaCodable, Equatable {
        let bool: Bool
        let int: Int
        let int8: Int8
        let int16: Int16
        let int32: Int32
        let int64: Int64
        let uint: UInt
        let uint8: UInt8
        let uint16: UInt16
        let uint32: UInt32
        let uint64: UInt64
        let float: Float
        let double: Double
        let string: String
        let date: Date
        let `enum`: SchemaEnum
        let child: ChildClass
        let parent: ParentClass
        let arraysClass: ArraysSchemaClass
        let dictionariesClass: DictionariesSchemaClass
    //    let array: [any BDFSchemaCodable & Hashable]
    //    let dictionary: [String: any BDFSchemaCodable & Hashable]
        
        init(bool: Bool, int: Int, int8: Int8, int16: Int16, int32: Int32, int64: Int64, uint: UInt, uint8: UInt8, uint16: UInt16, uint32: UInt32, uint64: UInt64, float: Float, double: Double, string: String, date: Date, enum: SchemaEnum, child: ChildClass, parent: ParentClass, arraysClass: ArraysSchemaClass, dictionaries: DictionariesSchemaClass/*, array: [any BDFSchemaCodable & Hashable], dictionary: [String: any BDFSchemaCodable & Hashable]*/) {
            self.bool = bool
            self.int = int
            self.int8 = int8
            self.int16 = int16
            self.int32 = int32
            self.int64 = int64
            self.uint = uint
            self.uint8 = uint8
            self.uint16 = uint16
            self.uint32 = uint32
            self.uint64 = uint64
            self.float = float
            self.double = double
            self.string = string
            self.date = date
            self.enum = `enum`
            self.child = child
            self.parent = parent
            self.arraysClass = arraysClass
            self.dictionariesClass = dictionaries
    //        self.array = array
    //        self.dictionary = dictionary
        }
        
        init(from decoder: BDFSchemaDecoder) throws {
            self.bool = try decoder.decode()
            self.int = try decoder.decode()
            self.int8 = try decoder.decode()
            self.int16 = try decoder.decode()
            self.int32 = try decoder.decode()
            self.int64 = try decoder.decode()
            self.uint = try decoder.decode()
            self.uint8 = try decoder.decode()
            self.uint16 = try decoder.decode()
            self.uint32 = try decoder.decode()
            self.uint64 = try decoder.decode()
            self.float = try decoder.decode()
            self.double = try decoder.decode()
            self.string = try decoder.decode()
            self.date = try decoder.decode()
            self.enum = try decoder.decode(SchemaEnum.self)
            self.child = try decoder.decode(ChildClass.self)
            self.parent = try decoder.decode(ParentClass.self)
            self.arraysClass = try decoder.decode(ArraysSchemaClass.self)
            self.dictionariesClass = try decoder.decode(DictionariesSchemaClass.self)
    //        self.array = try decoder.decodeArray(of: any BDFSchemaCodable.self)
    //        self.dictionary = try decoder.decodeDictionary(of: String.self, valueType: any BDFSchemaCodable.self)
        }
        
        func encode(to encoder: any BDFSchemaEncoder) throws {
            try encoder.encode(self.bool)
            try encoder.encode(self.int)
            try encoder.encode(self.int8)
            try encoder.encode(self.int16)
            try encoder.encode(self.int32)
            try encoder.encode(self.int64)
            try encoder.encode(self.uint)
            try encoder.encode(self.uint8)
            try encoder.encode(self.uint16)
            try encoder.encode(self.uint32)
            try encoder.encode(self.uint64)
            try encoder.encode(self.float)
            try encoder.encode(self.double)
            try encoder.encode(self.string)
            try encoder.encode(self.date)
            try encoder.encode(self.enum)
            try encoder.encode(self.child)
            try encoder.encode(self.parent)
            try encoder.encode(self.arraysClass)
            try encoder.encode(self.dictionariesClass)
        }
        
        static func ==(lhs: AllSchemaItemTypes, rhs: AllSchemaItemTypes) -> Bool {
            guard lhs.bool == rhs.bool &&
                    lhs.int == rhs.int &&
                    lhs.int8 == rhs.int8 &&
                    lhs.int16 == rhs.int16 &&
                    lhs.int32 == rhs.int32 &&
                    lhs.int64 == rhs.int64 &&
                    lhs.uint == rhs.uint &&
                    lhs.uint8 == rhs.uint8 &&
                    lhs.uint16 == rhs.uint16 &&
                    lhs.uint32 == rhs.uint32 &&
                    lhs.uint64 == rhs.uint64 &&
                    lhs.float == rhs.float &&
                    lhs.double == rhs.double &&
                    lhs.string == rhs.string &&
                    lhs.date == rhs.date &&
                    lhs.enum == rhs.enum &&
                    lhs.child == rhs.child &&
                    lhs.parent == rhs.parent &&
                    lhs.arraysClass == rhs.arraysClass &&
                    lhs.dictionariesClass == rhs.dictionariesClass
            else {
                return false
            }
            return true
        }
    }
    
    // MARK: - Help methods
    
    private func encodeDecode<T: BDFSchemaCodable & Equatable>(_ value: T) throws {
        let encoder = BDFArchiver()
        let data = try encoder.encode(value)
        let decoder = BDFUnarchiver()
        let decoded = try decoder.decode(T.self, from: data)
//            print("Encoded and decoded value: \(value) \(decoded)")
        XCTAssertEqual(decoded, value)
    }

}
