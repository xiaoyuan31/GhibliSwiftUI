//
//  FilmViewModel.swift
//  GhibliSwiftUI
//
//  Created by Xiao Yuan Lv on 3/20/26.
//

import Foundation
import Combine

@MainActor
class FilmViewModel: ObservableObject {
    
    @Published var films: [Film] = []
    @Published var searchText: String = ""
    @Published var favoriteIDs: Set<String> = []
    
    @Published var isLoading = false
    @Published var errorMessage : String?
    
    private let service = FilmService()
    private let favoritesKey = "favorite_films"
    
    private let repository: FilmRepositoryProtocol
    
    init(repository: FilmRepositoryProtocol = FilmRepository()) {
        self.repository = repository
        loadFav()
    }
    
    func toggleFav(film: Film) {
        if(favoriteIDs.contains(film.id)) {
            favoriteIDs.remove(film.id)
        } else {
            favoriteIDs.insert(film.id)
        }
        saveFav()
    }
    
    func isFavorite(film: Film) -> Bool {
        return favoriteIDs.contains(film.id)
    }
    
    private func saveFav() {
        UserDefaults.standard.set(Array(favoriteIDs), forKey: favoritesKey)
    }
    
    private func loadFav() {
        if let saved = UserDefaults.standard.array(forKey: favoritesKey)  as? [String] {
            favoriteIDs = Set(saved)
        }
    }
    
    
    func fetchFilms()  async {
        isLoading = true
        errorMessage = nil
        do {
            let films = try await repository.fetchFilms()
            self.films = films
        } catch {
            self.errorMessage = "Failed to load movies 😢"
            print("Error fetching films:", error)
        }
        
        isLoading = false
    }
    
    var filteredFilms: [Film] {
        if searchText.isEmpty {
            return films
        } else {
            return films.filter {
                $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.director.lowercased().contains(searchText.lowercased())
            }
        }
    }
    
}
