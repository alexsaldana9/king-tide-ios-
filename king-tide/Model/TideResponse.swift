//
//  File.swift
//  king-tide
//
//  Created by Erick Barbosa on 12/9/17.
//  Copyright © 2017 Alexandra Saldana. All rights reserved.
//

import Foundation
import UIKit

struct TideResponse: Codable {
    let id: Int
    let depth: Double
    let unitsDepth: String
    let salinity: Int
    let unitsSalinity, description, createdAt, updatedAt: String
    let approved, deleted: Bool
    let latitude, longitude: Double

    enum CodingKeys: String, CodingKey {
        case id, depth
        case unitsDepth = "units_depth"
        case salinity
        case unitsSalinity = "units_salinity"
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case approved, deleted, latitude, longitude
    }
}

// MARK: Convenience initializers

extension TideResponse {
    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(TideResponse.self, from: data) else { return nil }
        self = me
    }

    init?(_ json: String, using encoding: String.Encoding = .utf8) {
        guard let data = json.data(using: encoding) else { return nil }
        self.init(data: data)
    }

    init?(url: String) {
        guard let url = URL(string: url) else { return nil }
        guard let data = try? Data(contentsOf: url) else { return nil }
        self.init(data: data)
    }

    var jsonData: Data? {
        return try? JSONEncoder().encode(self)
    }

    var json: String? {
        guard let data = self.jsonData else { return nil }
        return String(data: data, encoding: .utf8)
    }
}


