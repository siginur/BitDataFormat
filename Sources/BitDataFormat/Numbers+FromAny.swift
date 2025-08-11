//
//  Numbers+FromAny.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 11/08/2025.
//

import Foundation

extension Float {
    init?(fromAny any: Any) {
        if let value = any as? Float {
            self = value
            return
        }
        else if let value = any as? Int {
            self = Float(value)
            return
        }
        return nil
    }
}

extension Double {
    init?(fromAny any: Any) {
        if let value = any as? Double {
            self = value
            return
        }
        else if let value = any as? Float {
            self = Double(value)
            return
        }
        else if let value = any as? Int {
            self = Double(value)
            return
        }
        return nil
    }
}

extension CGFloat {
    init?(fromAny any: Any) {
        if let value = any as? CGFloat {
            self = value
            return
        }
        else if let value = any as? Double {
            self = CGFloat(value)
            return
        }
        else if let value = any as? Float {
            self = CGFloat(value)
            return
        }
        else if let value = any as? Int {
            self = CGFloat(value)
            return
        }
        return nil
    }
}
