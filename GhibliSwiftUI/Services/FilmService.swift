//
//  FilmService.swift
//  GhibliSwiftUI
//
//  Created by Xiao Yuan Lv on 3/20/26.
//

import Foundation

class FilmService {
    func fetchFilms() async throws -> [Film] {
        guard let url = URL(string : "https://ghibliapi.vercel.app/films")
        else { return[] }
                
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let films = try JSONDecoder().decode([Film].self, from: data)
        return films
    }
}
