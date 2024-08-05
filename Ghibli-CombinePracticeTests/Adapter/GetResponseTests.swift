//
//  GetResponseTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/21/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class GetResponseTests: XCTestCase {

    func testFetch_shouldPassCorrectParameter() async throws {
        var urlString: String?
        var dataPassed: Data?
        
        let data = Data(count: Int.random())
        let sut = GetResponse<StubResponse>(
            request: {
                urlString = $0?.absoluteString
                return data
            },
            decode: {
                dataPassed = $0
                return StubResponse()
            }
        )
        
        let path = "any-path-\(String.random())"
        _ = try await sut.fetch(path: path)
        
        XCTAssertEqual(urlString, "https://ghibliapi.vercel.app/\(path)")
        XCTAssertEqual(dataPassed, data)
    }
    
    func testFetch_shouldReturnResponseFromDecode() async throws {
        let response = (0...Int.random(in: 1...3)).map { _ in
            StubResponse()
        }
        let sut = GetResponse<[StubResponse]>(
            request: { _ in Data() },
            decode: { _ in response }
        )
        
        let result = try await sut.fetch(path: "any-path")
        
        XCTAssertEqual(result, response)
    }
    
    func testFetch_whenRequestThrewError_shouldThrowError() async throws {
        let sut = GetResponse<StubResponse>(
            request: { _ in throw ErrorInTest.sample },
            decode: { _ in StubResponse() }
        )
        
        await XCTAssertThrowsError(
            try await sut.fetch(path: "any-path"),
            expectedError: ErrorInTest.sample
        )
    }
    
    func testFetch_whenDecodeThrewError_shouldThrowError() async throws {
        let sut = GetResponse<StubResponse>(
            request: { _ in Data() },
            decode: { _ in throw ErrorInTest.sample }
        )
        
        await XCTAssertThrowsError(
            try await sut.fetch(path: "any-path"),
            expectedError: ErrorInTest.sample
        )
    }
}

private struct StubResponse: Decodable, Equatable {
    let identifier: UUID
    
    init() { identifier = UUID() }
}
