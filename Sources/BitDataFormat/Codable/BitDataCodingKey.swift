//
//  BitDataCodingKey.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 06/08/2025.
//

enum BitDataCodingKey: CodingKey {
    case index(Int)
    case key(String)
    
    var intValue: Int? {
        if case .index(let index) = self {
            return index
        }
        return nil
    }
    
    var stringValue: String {
        switch self {
        case .index(let int):
            return String(int)
        case .key(let string):
            return string
        }
    }
    
    init(stringValue: String) {
        self = .key(stringValue)
    }
    
    init(intValue: Int) {
        self = .index(intValue)
    }
}

