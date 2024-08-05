//
//  GhibliDataStore.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/23/24.
//

import Foundation

enum DataStoreKey: String {
    case people
}

enum DataStoreError: Error {
    case dataEncodingFailure
}

protocol GhibliDataStoreProtocol {
    associatedtype DataType
    
    func save(data: Data) async
    func get() async throws -> DataType?
}

struct GhibliDataStore<T: Codable>: GhibliDataStoreProtocol {
    typealias DataType = T
    
    private let key: String
    private let cacheStorage: GhibliDataCacheProtocol
    
    init(
        key: String,
        cacheStorage: GhibliDataCacheProtocol
    ) {
        self.key = key
        self.cacheStorage = cacheStorage
    }
    
    func save(data: Data) async {
        await cacheStorage.save(object: data as AnyObject, forKey: key)
    }
    
    func get() async throws -> DataType? {
        guard let data = await cacheStorage.get(forKey: key) as? Data
        else { throw DataStoreError.dataEncodingFailure }
        
        return try DataType.decode(data)
    }
}

extension GhibliDataStore {
    static func makePeopleStorage() -> GhibliDataStore<[PeopleResponse]> {
        .init(
            key: DataStoreKey.people.rawValue,
            cacheStorage: GhibliDataCache.shared
        )
    }
}
