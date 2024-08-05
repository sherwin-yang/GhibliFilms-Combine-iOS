//
//  GetResponse.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/21/24.
//

import Foundation

struct GetResponse<T> {
    private let request: (URL?) async throws -> Data
    private let decode: (Data) throws -> T
    
    init(
        request: @escaping (URL?) async throws -> Data,
        decode: @escaping (Data) throws -> T
    ) {
        self.request = request
        self.decode = decode
    }
    
    func fetch(path: String) async throws -> T {
        let data = try await request(GhibliURLBuilder(path: path).createURL())
        return try decode(data)
    }
}
