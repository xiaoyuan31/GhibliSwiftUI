//
//  FilmRepository.swift
//  GhibliSwiftUI
//
//  Created by Xiao Yuan Lv on 3/20/26.
//

import Foundation

protocol FilmRepositoryProtocol {
    func fetchFilms() async throws -> [Film]
}

class FilmRepository: FilmRepositoryProtocol {
    let service: FilmService

    init(service: FilmService = FilmService()) {
        self.service = service
    }

    func fetchFilms() async throws -> [Film] {
        try await service.fetchFilms()
    }
}
