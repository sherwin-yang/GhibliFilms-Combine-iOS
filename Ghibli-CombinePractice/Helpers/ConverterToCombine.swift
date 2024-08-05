//
//  ConverterToCombine.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/26/24.
//

import Combine

struct ConverterToCombine<T> {
    
    static func publisher(_ block: @escaping () async throws -> T) -> AnyPublisher<T, Error> {
        Deferred<Future> {
            Future<T, Error> { promise in
                Task {
                    do {
                        let result = try await block()
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
}
