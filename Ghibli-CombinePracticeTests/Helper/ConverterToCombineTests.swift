//
//  ConverterToCombineTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/27/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class ConverterToCombineTests: XCTestCase {

    func testGetPublisher_shouldNotExecuteBlock_whenIsNotSinkYet() {
        var blockCalled = false
        let block: () async throws -> Dummy = {
            blockCalled = true
            return Dummy()
        }
        _ = ConverterToCombine<Dummy>.publisher(block)
        
        XCTAssertFalse(blockCalled)
    }
    
    func testGetPublisher_shouldNotExecuteBlock_whenIsNotSunk() {
        var blockCalled = false
        let block: () async throws -> Dummy = {
            blockCalled = true
            return Dummy()
        }
        _ = ConverterToCombine<Dummy>.publisher(block).sink(
            receiveCompletion: { _ in },
            receiveValue: { _ in })
        
        XCTAssertTrue(blockCalled)
    }

    func testGetPublisher_shouldReturnFromBlockResult() {
        let stub = DataStub()
        var result: DataStub?
        
        let expectation = expectation(description: "Publisher never completes")
        expectation.expectedFulfillmentCount = 1
        let cancellable = ConverterToCombine<DataStub>.publisher {
            return stub
        }.sink(
            receiveCompletion: { _ in },
            receiveValue: {
                result = $0
                expectation.fulfill()
            }
        )
        defer { cancellable.cancel() }
        
        waitForExpectations(timeout: 0.1)
        
        XCTAssertEqual(result, stub)
    }
    
    func testGetPublisher_shouldFail_whenBlockThrowError() {
        var error: Error?
        let expectation = expectation(description: "Publisher never completes")
        expectation.expectedFulfillmentCount = 1
        let cancellable = ConverterToCombine<DataStub>.publisher {
            throw ErrorInTest.sample
        }.sink(
            receiveCompletion: {
                switch $0 {
                case .failure(let failure): error = failure
                default: break
                }
                expectation.fulfill()
            },
            receiveValue: { _ in }
        )
        defer { cancellable.cancel() }
        
        waitForExpectations(timeout: 0.1)
        
        XCTAssertNotNil(error)
    }
}

