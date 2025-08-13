//
//  BDFArchiveTests.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 08/08/2025.
//

import XCTest
@testable import BitDataFormat

final class BDFArchiveTests: XCTestCase {
    
    func testNonClass() throws {
        // Bool
        try encodeDecode(true)
        try encodeDecode(false)
        
        // Int
        try encodeDecode(0)
        try encodeDecode(Int.min + 1)
        try encodeDecode(Int.max)
        try encodeDecode(Int8.min)
        try encodeDecode(Int8.max)
        try encodeDecode(Int16.min)
        try encodeDecode(Int16.max)
        try encodeDecode(Int32.min)
        try encodeDecode(Int32.max)
        try encodeDecode(Int64.min + 1)
        try encodeDecode(Int64.max)
        
        // UInt
        try encodeDecode(0 as UInt)
        try encodeDecode(UInt.min)
        try encodeDecode(UInt.max)
        try encodeDecode(UInt8.min)
        try encodeDecode(UInt8.max)
        try encodeDecode(UInt16.min)
        try encodeDecode(UInt16.max)
        try encodeDecode(UInt32.min)
        try encodeDecode(UInt32.max)
        try encodeDecode(UInt64.min)
        try encodeDecode(UInt64.max)
        
        // Float
        try encodeDecode(0.0 as Float)
        try encodeDecode(1.234567 as Float)
        try encodeDecode(-1.234567 as Float)
        try encodeDecode(Float.greatestFiniteMagnitude)
        try encodeDecode(Float.infinity)
        try encodeDecode(-Float.greatestFiniteMagnitude)
        try encodeDecode(-Float.infinity)
        
        // Double
        try encodeDecode(0.0 as Double)
        try encodeDecode(1.234567 as Double)
        try encodeDecode(-1.234567 as Double)
        try encodeDecode(Double.greatestFiniteMagnitude)
        try encodeDecode(Double.infinity)
        try encodeDecode(-Double.greatestFiniteMagnitude)
        try encodeDecode(-Double.infinity)
        
        // CGFloat
        try encodeDecode(0.0 as CGFloat)
        try encodeDecode(1.234567 as CGFloat)
        try encodeDecode(-1.234567 as CGFloat)
        try encodeDecode(CGFloat.greatestFiniteMagnitude)
        try encodeDecode(CGFloat.infinity)
        try encodeDecode(-CGFloat.greatestFiniteMagnitude)
        try encodeDecode(-CGFloat.infinity)
        
        // String
        for string in SampleData.shared.sampleDataStrings {
            try encodeDecode(string)
        }
        
        // Date
        for date in SampleData.shared.sampleDataDates {
            try encodeDecode(date)
        }
        
        // Array
        try encodeDecode([true, false])
        try encodeDecode([1, 2, 3] as [Int])
        try encodeDecode([1, 2, 3] as [Int8])
        try encodeDecode([1, 2, 3] as [Int16])
        try encodeDecode([1, 2, 3] as [Int32])
        try encodeDecode([1, 2, 3] as [Int64])
        try encodeDecode([1, 2, 3] as [UInt])
        try encodeDecode([1, 2, 3] as [UInt8])
        try encodeDecode([1, 2, 3] as [UInt16])
        try encodeDecode([1, 2, 3] as [UInt32])
        try encodeDecode([1, 2, 3] as [UInt64])
        try encodeDecode(SampleData.shared.sampleDataStrings)
        try encodeDecode(SampleData.shared.sampleDataDates)
        try encodeDecode([[1], [2], [3]])
        try encodeDecode([["key1": 1], ["key2": 2]])
        let arraySizes = [0, 1, BitDataConstants.Collection.maxSizeForUsingSeparator, 255, 4095, 65535]
        for size in arraySizes {
            try encodeDecode(Array(0..<size))
            try encodeDecode((0..<size).map { "Item \($0)" })
            try encodeDecode((0..<size).map { $0 % 2 == 0 })
            try encodeDecode((0..<size).map { ["key": "value \($0)"] })
        }
        
        // Dictionary
        try encodeDecode(["bool": true])
        try encodeDecode(["int": Int(123)])
        try encodeDecode(["int8": Int8(8)])
        try encodeDecode(["int16": Int16(16)])
        try encodeDecode(["int32": Int32(32)])
        try encodeDecode(["int64": Int64(64)])
        try encodeDecode(["uInt": UInt(123)])
        try encodeDecode(["uInt8": UInt8(8)])
        try encodeDecode(["uInt16": UInt16(16)])
        try encodeDecode(["uInt32": UInt32(32)])
        try encodeDecode(["uInt64": UInt64(64)])
        try encodeDecode(["str": "hello"])
        try encodeDecode(["date": Date(timeIntervalSince1970: 0)])
        try encodeDecode(["nested": ["key": "value"]])
        try encodeDecode(["array": [1, 2, 3]])
        let dictionarySizes = [0, 1, BitDataConstants.Collection.maxSizeForUsingSeparator, 255, 4095, 65535]
        for size in dictionarySizes {
            let intDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", $0) })
            try encodeDecode(intDict)

            let stringDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", "Value \($0)") })
            try encodeDecode(stringDict)

            let boolDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", $0 % 2 == 0) })
            try encodeDecode(boolDict)

            let nestedDict = Dictionary(uniqueKeysWithValues: (0..<size).map { ("key\($0)", ["innerKey": "innerValue \($0)"]) })
            try encodeDecode(nestedDict)
        }
    }
    
    func testArchiveClass() throws {
        let value = AllArchiveItemTypes(
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
            double: 13.1446534564,
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
                double: [50.553451, 52.534534635, 54.5123125],
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
                double: ["key52": 50.5453451, "key53": 52.51231233, "key54": 54.555435],
                string: ["key55": "string1", "key56": "string2", "key57": "string3"],
                date: ["key58": .init(timeIntervalSince1970: 1_000_000), "key59": .init(timeIntervalSince1970: 2_000_000.5)],
                enum: ["key60": .value1, "key61": .value2]
            ),
        )
        try encodeDecode(value)
    }
    
    func testArchiveClassWithNils() throws {
        let listOfValues = [
            ArchiveWithNilsClass(
                id: 195,
                name: "some name",
                score: nil
            ),
            ArchiveWithNilsClass(
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
    
    enum ArchiveEnum: Int, BDFArchiveReadWritable {
        case value1
        case value2
        
        init(from archive: any BDFArchiveReader) throws {
            let rawValue = try archive.read() as Int
            guard let value = ArchiveEnum(rawValue: rawValue) else {
                throw BitDataDecodingError.typeMissmatch
            }
            self = value
        }
        
        func write(to encoder: any BDFArchiveWriter) throws {
            try encoder.write(self.rawValue)
        }
    }
    
    class ArraysArchiveClass: BDFArchiveReadWritable, Equatable {
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
        let `enum`: [ArchiveEnum]
        
        init(bool: [Bool], int: [Int], int8: [Int8], int16: [Int16], int32: [Int32], int64: [Int64], uint: [UInt], uint8: [UInt8], uint16: [UInt16], uint32: [UInt32], uint64: [UInt64], float: [Float], double: [Double], string: [String], date: [Date], enum: [ArchiveEnum]) {
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
        
        required init(from archive: any BitDataFormat.BDFArchiveReader) throws {
            self.bool = try archive.read()
            self.int = try archive.read()
            self.int8 = try archive.read()
            self.int16 = try archive.read()
            self.int32 = try archive.read()
            self.int64 = try archive.read()
            self.uint = try archive.read()
            self.uint8 = try archive.read()
            self.uint16 = try archive.read()
            self.uint32 = try archive.read()
            self.uint64 = try archive.read()
            self.float = try archive.read()
            self.double = try archive.read()
            self.string = try archive.read()
            self.date = try archive.read()
            self.enum = try archive.read()
        }
        
        func write(to encoder: any BitDataFormat.BDFArchiveWriter) throws {
            try encoder.write(self.bool)
            try encoder.write(self.int)
            try encoder.write(self.int8)
            try encoder.write(self.int16)
            try encoder.write(self.int32)
            try encoder.write(self.int64)
            try encoder.write(self.uint)
            try encoder.write(self.uint8)
            try encoder.write(self.uint16)
            try encoder.write(self.uint32)
            try encoder.write(self.uint64)
            try encoder.write(self.float)
            try encoder.write(self.double)
            try encoder.write(self.string)
            try encoder.write(self.date)
            try encoder.write(self.enum)
        }
        
        static func == (lhs: ArraysArchiveClass, rhs: ArraysArchiveClass) -> Bool {
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

    class DictionariesArchiveClass: BDFArchiveReadWritable, Equatable {
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
        let `enum`: [String: ArchiveEnum]
        
        init(bool: [String: Bool], int: [String: Int], int8: [String: Int8], int16: [String: Int16], int32: [String: Int32], int64: [String: Int64], uint: [String: UInt], uint8: [String: UInt8], uint16: [String: UInt16], uint32: [String: UInt32], uint64: [String: UInt64], float: [String: Float], double: [String: Double], string: [String: String], date: [String: Date], enum: [String: ArchiveEnum]) {
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
        
        required init(from archive: any BDFArchiveReader) throws {
            self.bool = try archive.read()
            self.int = try archive.read()
            self.int8 = try archive.read()
            self.int16 = try archive.read()
            self.int32 = try archive.read()
            self.int64 = try archive.read()
            self.uint = try archive.read()
            self.uint8 = try archive.read()
            self.uint16 = try archive.read()
            self.uint32 = try archive.read()
            self.uint64 = try archive.read()
            self.float = try archive.read()
            self.double = try archive.read()
            self.string = try archive.read()
            self.date = try archive.read()
            self.enum = try archive.read()
        }
        
        func write(to archive: any BDFArchiveWriter) throws {
            try archive.write(self.bool)
            try archive.write(self.int)
            try archive.write(self.int8)
            try archive.write(self.int16)
            try archive.write(self.int32)
            try archive.write(self.int64)
            try archive.write(self.uint)
            try archive.write(self.uint8)
            try archive.write(self.uint16)
            try archive.write(self.uint32)
            try archive.write(self.uint64)
            try archive.write(self.float)
            try archive.write(self.double)
            try archive.write(self.string)
            try archive.write(self.date)
            try archive.write(self.enum)
        }
        
        static func == (lhs: DictionariesArchiveClass, rhs: DictionariesArchiveClass) -> Bool {
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

    class ParentClass: BDFArchiveReadWritable, Equatable {
        let id: Int
        
        init(id: Int) {
            self.id = id
        }
        
        required init(from archive: any BitDataFormat.BDFArchiveReader) throws {
            self.id = try archive.read()
        }
        
        func write(to archive: any BDFArchiveWriter) throws {
            try archive.write(self.id)
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
        
        required init(from archive: any BitDataFormat.BDFArchiveReader) throws {
            self.name = try archive.read()
            try super.init(from: archive)
        }
        
        override func write(to archive: any BDFArchiveWriter) throws {
            try archive.write(self.name)
            try super.write(to: archive)
        }
        
        static func == (lhs: ChildClass, rhs: ChildClass) -> Bool {
            lhs.id == rhs.id && lhs.name == rhs.name
        }
    }
    
    class ArchiveWithNilsClass: ParentClass {
        let name: String
        let score: CGFloat?

        init(id: Int, name: String, score: CGFloat?) {
            self.name = name
            self.score = score
            super.init(id: id)
        }
        
        required init(from archive: any BitDataFormat.BDFArchiveReader) throws {
            self.name = try archive.read()
            self.score = try archive.readIfPresent()
            try super.init(from: archive)
        }
        
        override func write(to archive: any BDFArchiveWriter) throws {
            try archive.write(self.name)
            try archive.writeIfPresent(self.score)
            try super.write(to: archive)
        }
        
        static func == (lhs: ArchiveWithNilsClass, rhs: ArchiveWithNilsClass) -> Bool {
            lhs.id == rhs.id && lhs.name == rhs.name && lhs.score == rhs.score
        }
    }

    struct AllArchiveItemTypes: BDFArchiveReadWritable, Equatable {
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
        let `enum`: ArchiveEnum
        let child: ChildClass
        let parent: ParentClass
        let arraysClass: ArraysArchiveClass
        let dictionariesClass: DictionariesArchiveClass
        
        init(bool: Bool, int: Int, int8: Int8, int16: Int16, int32: Int32, int64: Int64, uint: UInt, uint8: UInt8, uint16: UInt16, uint32: UInt32, uint64: UInt64, float: Float, double: Double, string: String, date: Date, enum: ArchiveEnum, child: ChildClass, parent: ParentClass, arraysClass: ArraysArchiveClass, dictionaries: DictionariesArchiveClass) {
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
        
        init(from archive: BDFArchiveReader) throws {
            self.bool = try archive.read()
            self.int = try archive.read()
            self.int8 = try archive.read()
            self.int16 = try archive.read()
            self.int32 = try archive.read()
            self.int64 = try archive.read()
            self.uint = try archive.read()
            self.uint8 = try archive.read()
            self.uint16 = try archive.read()
            self.uint32 = try archive.read()
            self.uint64 = try archive.read()
            self.float = try archive.read()
            self.double = try archive.read()
            self.string = try archive.read()
            self.date = try archive.read()
            self.enum = try archive.read()
            self.child = try archive.read()
            self.parent = try archive.read()
            self.arraysClass = try archive.read()
            self.dictionariesClass = try archive.read()
        }
        
        func write(to archive: any BDFArchiveWriter) throws {
            try archive.write(self.bool)
            try archive.write(self.int)
            try archive.write(self.int8)
            try archive.write(self.int16)
            try archive.write(self.int32)
            try archive.write(self.int64)
            try archive.write(self.uint)
            try archive.write(self.uint8)
            try archive.write(self.uint16)
            try archive.write(self.uint32)
            try archive.write(self.uint64)
            try archive.write(self.float)
            try archive.write(self.double)
            try archive.write(self.string)
            try archive.write(self.date)
            try archive.write(self.enum)
            try archive.write(self.child)
            try archive.write(self.parent)
            try archive.write(self.arraysClass)
            try archive.write(self.dictionariesClass)
        }
        
        static func ==(lhs: AllArchiveItemTypes, rhs: AllArchiveItemTypes) -> Bool {
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
    
    private func encodeDecode<T: BDFArchiveReadWritable & Equatable>(_ value: T) throws {
        let encoder = BDFArchiver()
        let data = try encoder.pack(value)
        let decoder = BDFUnarchiver()
        let decoded = try decoder.unpack(T.self, from: data)
//            print("Encoded and decoded value: \(value) \(decoded)")
        XCTAssertEqual(decoded, value)
    }

}
