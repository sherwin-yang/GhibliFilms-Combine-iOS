//
//  PeopleProviderTests.swift
//  Ghibli-CombinePracticeTests
//
//  Created by Sherwin Yang on 7/24/24.
//

import XCTest
import Combine

@testable import Ghibli_CombinePractice

private let fakePeople: [PeopleResponse] = []

final class PeopleProviderTests: XCTestCase {
    
    enum CallAction {
        case saveStorage
        case getStorage
        case request
    }
    
    func testGetPeople_actions_whenStorageHasData() async throws {
        let storage = GhibliPeopleDataStoreMock(availableData: { fakePeople })
        var actions: [CallAction] = []
        let sut = PeopleProvider(
            storage: storage,
            request: { _ in
                actions.append(.request)
                return Data()
            }
        )
        
        let cancellable = storage.actionPublisher.sink(
            receiveValue: { actions.append($0) }
        )
        defer { cancellable.cancel() }
        
        _ = try await sut.get(for: String.random())
        
        XCTAssertEqual(actions, [.getStorage])
    }
    
    func testGetPeople_actions_whenStorageHasNoData() async throws {
        func test(
            availableData: @escaping () throws -> [PeopleResponse]?,
            line: UInt = #line
        ) async throws {
            let storage = GhibliPeopleDataStoreMock(availableData: availableData)
            var actions: [CallAction] = []
            let sut = PeopleProvider(
                storage: storage,
                request: { _ in
                    actions.append(.request)
                    return Data()
                }
            )
            
            let cancellable = storage.actionPublisher.sink(
                receiveValue: { actions.append($0) }
            )
            defer { cancellable.cancel() }
            
            _ = try await sut.get(for: String.random())
            
            XCTAssertEqual(
                actions,
                [.getStorage, .request, .saveStorage, .getStorage],
                line: line
            )
        }
        
        try await test(availableData: { nil })
        try await test(availableData: { throw ErrorInTest.sample })
    }
    
    func testGetPeople_shouldThrowError() async {
        let error = ErrorInTest.sample
        let sut = PeopleProvider(
            storage: GhibliPeopleDataStoreMock(),
            request: { _ in throw error }
        )
        
        await XCTAssertThrowsError(
            try await sut.get(for: String.random()),
            expectedError: error
        )
    }
    
    func testGetPeople_passCorrectParameter() async throws {
        let storage = GhibliPeopleDataStoreMock()
        var passedUrl: URL?
        let data = Data(count: Int.random())
        let sut = PeopleProvider(
            storage: storage,
            request: {
                passedUrl = $0
                return data
            }
        )
        _ = try await sut.get(for: String.random())
        
        XCTAssertEqual(passedUrl?.absoluteString, "https://ghibliapi.vercel.app/people")
        XCTAssertEqual(storage.savedData, data)
    }
    
    func testGetPeople_shouldReturnFromStorage_filterByFilmId() async throws {
        let filmId = "film-\(Int.random())"
        let people: [PeopleResponse] = [
            .init(id: "id-\(Int.random())",
                  name: "name-\(String.random())",
                  films: ["film-\(Int.random())", filmId]),
            .init(id: "id-\(Int.random())",
                  name: "name-\(String.random())",
                  films: ["film-\(Int.random())", "film-\(Int.random())"]),
            .init(id: "id-\(Int.random())",
                  name: "name-\(String.random())",
                  films: [filmId])
        ]
        
        func test(
            storage: some GhibliDataStoreProtocol,
            line: UInt = #line
        ) async throws {
            let sut = PeopleProvider(
                storage: storage,
                request: { _ in try people.encode() }
            )
            
            let result = try await sut.get(for: filmId)
            
            XCTAssertEqual(
                result,
                [people[0].toPeople(), people[2].toPeople()],
                line: line
            )
        }
        
        try await test(storage: GhibliPeopleDataStoreMock(availableData: { people }))
        try await test(storage: GhibliPeopleDataStoreMockWithErrorOnce(dataAfterSaved: people))
        
    }
    
    func testGetPeople_shouldReturnEmpty() async throws {
        func test(
            storage: some GhibliDataStoreProtocol,
            line: UInt = #line
        ) async throws {
            let sut = PeopleProvider(
                storage: storage,
                request: { _ in Data() }
            )
            
            let result = try await sut.get(for: String.random())
            
            XCTAssertEqual(result, [])
        }
        
        try await test(storage: GhibliPeopleDataStoreMock(availableData: { [] }))
        try await test(storage: GhibliPeopleDataStoreMock(availableData: { nil }))
        try await test(storage: GhibliPeopleDataStoreMock(availableData: { throw ErrorInTest.sample }))
        try await test(storage: GhibliNonPeopleDataStoreMock())
    }
}

private final class GhibliPeopleDataStoreMock: GhibliDataStoreProtocol {
    typealias DataType = [PeopleResponse]
    
    private var availableData: () throws -> [PeopleResponse]?
    
    init(availableData: @escaping () throws -> [PeopleResponse]? = { nil }) {
        self.availableData = availableData
    }
    
    let actionPublisher = PassthroughSubject<PeopleProviderTests.CallAction, Never>()
    
    var savedData: Data?
    func save(data: Data) async {
        actionPublisher.send(.saveStorage)
        savedData = data
    }
    
    func get() async throws -> DataType? {
        actionPublisher.send(.getStorage)
        return try availableData()
    }
}

private final class GhibliPeopleDataStoreMockWithErrorOnce: GhibliDataStoreProtocol {
    typealias DataType = [PeopleResponse]
    
    let people: [PeopleResponse]
    
    init(dataAfterSaved people: [PeopleResponse]) {
        self.people = people
    }
    
    private var saveCalled = false
    func save(data: Data) async { saveCalled = true }
    
    func get() async throws -> DataType? {
        if saveCalled { people }
        else { throw ErrorInTest.sample }
    }
}

private final class GhibliNonPeopleDataStoreMock: GhibliDataStoreProtocol {
    typealias DataType = Dummy
    
    func save(data: Data) async { }
    func get() async throws -> DataType? { return Dummy() }
}
