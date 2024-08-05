//
//  PeopleProvider.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/21/24.
//

import Foundation
import Combine

protocol PeopleProviderProtocol {
    associatedtype StorageType
    
    func get(for filmId: String) async throws -> [People]
}

struct PeopleProvider: PeopleProviderProtocol {
    typealias StorageType = GhibliDataStoreProtocol
    
    private let storage: any StorageType
    private let request: (URL?) async throws -> Data
    
    init(
        storage: some StorageType,
        request: @escaping (URL?) async throws -> Data
    ) {
        self.storage = storage
        self.request = request
    }
    
    func get(for filmId: String) async throws -> [People] {
        if let people = try? await getPeople(by: filmId) {
            return people
        } else {
            let data = try await request(GhibliURLBuilder(path: "people").createURL())
            await storage.save(data: data)
            return (try? await getPeople(by: filmId)) ?? []
        }
    }
    
    private func getPeople(by filmId: String) async throws -> [People]? {
        (try await storage.get() as? [PeopleResponse])?
            .filter { $0.films.contains { $0 == filmId } }
            .map { $0.toPeople() }
    }
}

extension PeopleProvider {
    static func make() -> PeopleProvider {
        PeopleProvider(
            storage: GhibliDataStore<[PeopleResponse]>.makePeopleStorage(),
            request: GhibliHTTPRequest.getData
        )
    }
}
