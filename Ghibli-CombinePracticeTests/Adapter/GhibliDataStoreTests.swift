//
//  GhibliDataStoreTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/24/24.
//

import XCTest

@testable import Ghibli_CombinePractice

final class GhibliDataStoreTests: XCTestCase {
    
    func test_CallStorageGetAndSave() async throws {
        let key = "any-key-\(String.random())"
        let cacheStorage = GhibliDataCacheMock()
        let sut = GhibliDataStore<DataStub>(
            key: key,
            cacheStorage: cacheStorage
        )
        
        let stub = DataStub()
        let data = try stub.encode()
        await sut.save(data: data)
        _ = try? await sut.get()
        
        XCTAssertEqual(cacheStorage.getWithKey, key)
        XCTAssertEqual(cacheStorage.savedWithKey, key)
        XCTAssertEqual(cacheStorage.savedObject as? Data, data)
    }
    
    func testGet_ShouldThrowError_whenCachedStorageIsNotTypeData() async {
        let sut = GhibliDataStore<DataStub>(
            key: String.random(),
            cacheStorage: GhibliDataCacheMock(cached: AnyObjectStub() as AnyObject)
        )
        
        await XCTAssertThrowsError(
            try await sut.get(), 
            expectedError: DataStoreError.dataEncodingFailure
        )
    }
    
    func testGet_shouldReturnCorrectData() async throws {
        let stub = DataStub()
        let data = try stub.encode()
        let sut = GhibliDataStore<DataStub>(
            key: String.random(),
            cacheStorage: GhibliDataCacheMock(cached: data as AnyObject)
        )
        
        let result = try await sut.get()
        
        XCTAssertEqual(result, stub)
    }
    
}

private final class AnyObjectStub { }

private final class GhibliDataCacheMock: GhibliDataCacheProtocol {
    
    private let cached: AnyObject
    init(cached: AnyObject = Data() as AnyObject) { self.cached = cached }
    
    var savedObject: AnyObject?
    var savedWithKey: String?
    func save(object: AnyObject, forKey key: String) async {
        savedObject = object
        savedWithKey = key
    }
    
    var getWithKey: String?
    func get(forKey key: String) async -> AnyObject? {
        getWithKey = key
        return cached
    }
}
