//
//  FilmsProviderTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class FilmsProviderTests: XCTestCase {
    
    func testGetFilms_shouldPassCorrectPath_toRequest() async throws {
        var path = ""
        let sut = FilmsProvider(
            request: { path = $0; return [] },
            responseMapper: { _ in [] }
        )
        
        _ = try await sut.getFilms()
        
        XCTAssertEqual(path, "films")
    }
    
    func testGetFilms_shouldThrowError_whenRequestError() async {
        let sut = FilmsProvider(
            request: { _ in throw ErrorInTest.sample },
            responseMapper: { _ in [] }
        )
        
        await XCTAssertThrowsError(
            try await sut.getFilms(),
            expectedError: ErrorInTest.sample
        )
    }
    
    func testGetFilms_passResponseToResponseMapper() async throws {
        let filmsResponse = [FilmResponse.sample(), .sample(), .sample()]
        var filmsPassed: [FilmResponse] = []
        let sut = FilmsProvider(
            request: { _ in
                filmsResponse
            },
            responseMapper: {
                filmsPassed = $0
                return [.sample()]
            }
        )
        
        _ = try await sut.getFilms()
        
        XCTAssertEqual(filmsPassed, filmsResponse)
    }
    
    func testGetFilms_shouldReturnFilms_fromResponseMapperResult() async throws {
        let films = [Film.sample(), .sample(), .sample()]
        
        let sut = FilmsProvider(
            request: { _ in [] },
            responseMapper: { _ in films }
        )
        
        let result = try await sut.getFilms()
        
        XCTAssertEqual(result, films)
    }
    
}

extension Film {
    static func sample(id: String = "id-\(Int.random())") -> Self {
        .init(
            id: id,
            title: "title-\(Int.random())",
            originalTitle: "originalTitle-\(Int.random())",
            image: URL(string: "image-\(Int.random())"),
            description: "description-\(Int.random())",
            releaseDate: "releaseDate-\(Int.random())",
            runningTime: "running-time-\(Int.random())",
            rtScore: "rt-score-\(Int.random())",
            people: ["people-\(Int.random())", "people-\(Int.random())"]
        )
    }
}
