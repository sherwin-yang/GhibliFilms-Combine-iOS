//
//  FilmsProvider.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation
import Combine

struct FilmsProvider {
    
    private let request: (String) async throws -> [FilmResponse]
    private let responseMapper: ([FilmResponse]) -> [Film]
    
    init(
        request: @escaping (String) async throws -> [FilmResponse],
        responseMapper: @escaping ([FilmResponse]) -> [Film]
    ) {
        self.request = request
        self.responseMapper = responseMapper
    }
    
    func getFilms() async throws -> [Film] {
        let response = try await request("films")
        return responseMapper(response)
    }
}

extension FilmsProvider {
    static func make() -> Self {
        .init(
            request: GetResponse<[FilmResponse]>.makeGetFilms().fetch,
            responseMapper: { $0.map { $0.toFilms() } }
        )
    }
}

private extension GetResponse {
    static func makeGetFilms() -> GetResponse<[FilmResponse]> {
        .init(
            request: GhibliHTTPRequest.getData,
            decode: [FilmResponse].decode
        )
    }
}
