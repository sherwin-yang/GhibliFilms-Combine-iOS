//
//  Decodable+Encodable+Extension.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/21/24.
//

import Foundation

extension Decodable {
    static func decode(_ data: Data) throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Self.self, from: data)
    }
}

extension Encodable {
    func encode() throws -> Data {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        return try encoder.encode(self)
    }
}
