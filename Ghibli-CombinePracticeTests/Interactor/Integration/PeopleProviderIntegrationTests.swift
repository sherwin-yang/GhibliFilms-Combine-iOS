//
//  GetPeopleIntegrationTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/21/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class PeopleProviderIntegrationTests: XCTestCase {

    func testFetch() async throws {
        do {
            _ = try await PeopleProvider(
                storage: GhibliDataStore<[PeopleResponse]>.makePeopleStorage(),
                request: GhibliHTTPRequest.getData
            ).get(for: "any-film-id-\(Int.random())")
        } catch {
            XCTFail("fetch people failed with error: \(error)")
        }
    }

}
