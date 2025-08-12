//
//  Place_V2.swift
//  BitDataFormat
//
//  Created by Alexey Siginur on 12/08/2025.
//

import BitDataFormat

struct PlacesV2_Places: Codable, BDFSchemaCodable {
    
    var places: [PlacesV2_Place] = []
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
        self.places = try decoder.decode(PlacesV2_Place.self)
    }
    
    func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
        try encoder.encode(self.places)
    }
    
    static func ==(lhs: PlacesV2_Places, rhs: PlacesV2_Places) -> Bool {
        if lhs.places != rhs.places {return false}
        return true
    }
}

struct PlacesV2_Place: Codable, BDFSchemaCodable, Equatable {
    
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
    
    init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
        self.id = try decoder.decode()
        self.name = try decoder.decodeIfPresent() ?? ""
        self.latitude = try decoder.decode()
        self.longitude = try decoder.decode()
        self.radius = try decoder.decodeIfPresent() ?? 0
        self.geohash = try decoder.decode()
        self.type = try decoder.decodeIfPresent() ?? ""
        self.brandID = try decoder.decodeIfPresent() ?? ""
        self.brandName = try decoder.decodeIfPresent() ?? ""
        self._polygon = try decoder.decodeIfPresent(PlacesV2_Polygon.self)
    }
    
    func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
        try encoder.encode(self.id)
        self.name.isEmpty ? try encoder.encodeIfPresent(nil as String?) : try encoder.encode(self.name)
        try encoder.encode(self.latitude)
        try encoder.encode(self.longitude)
        self.radius == 0 ? try encoder.encodeIfPresent(nil as Int32?) : try encoder.encode(self.radius)
        try encoder.encode(self.geohash)
        self.type.isEmpty ? try encoder.encodeIfPresent(nil as String?) : try encoder.encode(self.type)
        self.brandID.isEmpty ? try encoder.encodeIfPresent(nil as String?) : try encoder.encode(self.brandID)
        self.brandName.isEmpty ? try encoder.encodeIfPresent(nil as String?) : try encoder.encode(self.brandName)
        try encoder.encodeIfPresent(self._polygon)
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

struct PlacesV2_Polygon: Codable, BDFSchemaCodable, Equatable {
    
    var points: [PlacesV2_Point] = []
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
        self.points = try decoder.decode(PlacesV2_Point.self)
    }
    
    func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
        try encoder.encode(points)
    }
    
    static func ==(lhs: PlacesV2_Polygon, rhs: PlacesV2_Polygon) -> Bool {
        if lhs.points != rhs.points {return false}
        return true
    }
}

struct PlacesV2_Point: Codable, BDFSchemaCodable, Equatable {
    
    var longitude: Float = 0
    var latitude: Float = 0
    
    init() {}
    
    init(from decoder: any BitDataFormat.BDFSchemaDecoder) throws {
        self.longitude = try decoder.decode()
        self.latitude = try decoder.decode()
    }
    
    func encode(to encoder: any BitDataFormat.BDFSchemaEncoder) throws {
        try encoder.encode(self.longitude)
        try encoder.encode(self.latitude)
    }
    
    static func ==(lhs: PlacesV2_Point, rhs: PlacesV2_Point) -> Bool {
        if lhs.longitude != rhs.longitude {return false}
        if lhs.latitude != rhs.latitude {return false}
        return true
    }
}
