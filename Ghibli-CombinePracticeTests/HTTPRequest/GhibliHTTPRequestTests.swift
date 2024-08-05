//
//  GhibliHTTPRequestTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class GhibliHTTPRequestTests: XCTestCase {
    
    func testFetch_throwsError_whenURLNil() async {
        await XCTAssertThrowsError(
            try await GhibliHTTPRequest.getData(url: nil),
            expectedError: HTTPRequestError.invalidURL
        )
    }
    
}
