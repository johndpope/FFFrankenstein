//
//  Codable+Extensions.swift
//  FFrankenstein
//
//  Created by Mark Malstrom on 10/29/18.
//

import Foundation

extension Encodable {
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
    
    func encode(with encoder: JSONEncoder = JSONEncoder()) throws -> [String : Any]? {
        let data: Data = try encode(with: encoder)
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any]
    }
}

extension Decodable {
    init(with decoder: JSONDecoder = JSONDecoder(), from data: Data) throws {
        decoder.dateDecodingStrategy = .iso8601
        self = try decoder.decode(Self.self, from: data)
    }
    
    init(with decoder: JSONDecoder = JSONDecoder(), from dictionary: [String : Any]) throws {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        try self.init(from: data)
    }
}

extension JSONSerialization {
    static func dictionary(from string: String) throws -> [String : Any]? {
        if let data = string.data(using: .utf8) {
            return try jsonObject(with: data) as? [String : Any]
        }
        
        return nil
    }
}
