//
//  Place_V2.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 12/08/2025.
//

import BitDataFormat

struct PlacesV2_Places: Codable, BDFArchiveReadWritable {
    
    var places: [PlacesV2_Place] = []
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFArchiveReader) throws {
        self.places = try decoder.read()
    }
    
    func write(to encoder: any BitDataFormat.BDFArchiveWriter) throws {
        try encoder.write(self.places)
    }
    
    static func ==(lhs: PlacesV2_Places, rhs: PlacesV2_Places) -> Bool {
        if lhs.places != rhs.places {return false}
        return true
    }
}

struct PlacesV2_Place: Codable, BDFArchiveReadWritable, Equatable {
    
    var id: String = String()
    var name: String = String()
    var latitude: Float = 0
    var longitude: Float = 0
    var radius: Int32 = 0
    var geohash: String = String()
    var type: String = String()
    var brandID: String = String()
    var brandName: String = String()
    var _polygon: PlacesV2_Polygon? = nil

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case radius
        case geohash
        case type
        case brandID = "brand_id"
        case brandName = "brand_name"
        case _polygon
    }
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFArchiveReader) throws {
        self.id = try decoder.read()
        self.name = try decoder.readIfPresent() ?? ""
        self.latitude = try decoder.read()
        self.longitude = try decoder.read()
        self.radius = try decoder.readIfPresent() ?? 0
        self.geohash = try decoder.read()
        self.type = try decoder.readIfPresent() ?? ""
        self.brandID = try decoder.readIfPresent() ?? ""
        self.brandName = try decoder.readIfPresent() ?? ""
        self._polygon = try decoder.readIfPresent()
    }
    
    func write(to encoder: any BitDataFormat.BDFArchiveWriter) throws {
        try encoder.write(self.id)
        self.name.isEmpty ? try encoder.writeIfPresent(nil as String?) : try encoder.write(self.name)
        try encoder.write(self.latitude)
        try encoder.write(self.longitude)
        self.radius == 0 ? try encoder.writeIfPresent(nil as Int32?) : try encoder.write(self.radius)
        try encoder.write(self.geohash)
        self.type.isEmpty ? try encoder.writeIfPresent(nil as String?) : try encoder.write(self.type)
        self.brandID.isEmpty ? try encoder.writeIfPresent(nil as String?) : try encoder.write(self.brandID)
        self.brandName.isEmpty ? try encoder.writeIfPresent(nil as String?) : try encoder.write(self.brandName)
        try encoder.writeIfPresent(self._polygon)
    }
    
    static func ==(lhs: PlacesV2_Place, rhs: PlacesV2_Place) -> Bool {
        if lhs.id != rhs.id {return false}
        if lhs.name != rhs.name {return false}
        if lhs.latitude != rhs.latitude {return false}
        if lhs.longitude != rhs.longitude {return false}
        if lhs.radius != rhs.radius {return false}
        if lhs.geohash != rhs.geohash {return false}
        if lhs._polygon != rhs._polygon {return false}
        if lhs.type != rhs.type {return false}
        if lhs.brandID != rhs.brandID {return false}
        if lhs.brandName != rhs.brandName {return false}
        return true
    }
}

struct PlacesV2_Polygon: Codable, BDFArchiveReadWritable, Equatable {
    
    var points: [PlacesV2_Point] = []
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFArchiveReader) throws {
        self.points = try decoder.read()
    }
    
    func write(to encoder: any BitDataFormat.BDFArchiveWriter) throws {
        try encoder.write(points)
    }
    
    static func ==(lhs: PlacesV2_Polygon, rhs: PlacesV2_Polygon) -> Bool {
        if lhs.points != rhs.points {return false}
        return true
    }
}

struct PlacesV2_Point: Codable, BDFArchiveReadWritable, Equatable {
    
    var longitude: Float = 0
    var latitude: Float = 0
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFArchiveReader) throws {
        self.longitude = try decoder.read()
        self.latitude = try decoder.read()
    }
    
    func write(to encoder: any BitDataFormat.BDFArchiveWriter) throws {
        try encoder.write(self.longitude)
        try encoder.write(self.latitude)
    }
    
    static func ==(lhs: PlacesV2_Point, rhs: PlacesV2_Point) -> Bool {
        if lhs.longitude != rhs.longitude {return false}
        if lhs.latitude != rhs.latitude {return false}
        return true
    }
}
