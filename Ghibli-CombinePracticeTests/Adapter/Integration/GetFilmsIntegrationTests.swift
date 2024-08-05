//
//  GetFilmsIntegrationTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class GetFilmsIntegrationTests: XCTestCase {
    
    func testFetch() async throws {
        do {
            _ = try await GetResponse<[FilmResponse]>(
                request: GhibliHTTPRequest.getData,
                decode: [FilmResponse].decode
            ).fetch(path: "films")
        } catch {
            XCTFail("fetch films failed with error: \(error)")
        }
    }
    
}
