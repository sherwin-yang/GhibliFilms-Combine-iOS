//
//  FilmsViewModel.swift
//  Ghibli-CombinePractice
//
//  Created by Sherwin Yang on 7/19/24.
//

import Foundation
import Combine

protocol FilmsViewModelProtocol {
    var films: CurrentValueSubject<[Film], Never> { get }
    func viewDidLoad()
}

final class FilmsViewModel: FilmsViewModelProtocol {
    
    let films = CurrentValueSubject<[Film], Never>([])
    
    private let getFilms: () -> AnyPublisher<[Film], Error>
    private var cancellables = Set<AnyCancellable>()
    
    init(getFilms: @escaping () -> AnyPublisher<[Film], Error>) {
        self.getFilms = getFilms
    }
    
    func viewDidLoad() {
        getFilms()
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] in self?.films.send($0) }
            )
            .store(in: &cancellables)
    }
}

extension FilmsViewModel {
    static func make() -> FilmsViewModel {
        .init(
            getFilms: {
                ConverterToCombine<[Film]>.publisher(
                    FilmsProvider.make().getFilms
                )
            }
        )
    }
}
