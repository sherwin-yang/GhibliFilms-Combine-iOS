//
//  TestHelpers.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import XCTest

enum ErrorInTest: Error {
    case sample
}

struct DataStub: Codable, Equatable {
    let id: UUID
    
    init() { id = UUID() }
}

struct Dummy { }

func XCTAssertThrowsError<T, R>(
    _ expression: @autoclosure () async throws -> T,
    expectedError: R,
    _ message: @autoclosure () -> String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async where R: Equatable, R: Error {
    do {
        _ = try await expression()
        XCTFail(message(), file: file, line: line)
    } catch {
        XCTAssertEqual(error as? R, expectedError, file: file, line: line)
    }
}

extension String {
    static func random() -> Self {
        String(String.randomElement("abcdefghijklmnopqrstuvwxyz")()!)
    }
}

extension Int {
    static func random() -> Self {
        .random(in: 0...100)
    }
}

/*
extension XCTestCase {
    func expectedFunction(_ name: String) -> XCTestExpectation {
        expectation(description: "Function not called: " + name)
    }
}
*/
