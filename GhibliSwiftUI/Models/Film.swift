//
//  Film.swift
//  GhibliSwiftUI
//
//  Created by Xiao Yuan Lv on 3/20/26.
//

import Foundation

struct Film: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let director: String
    let release_date: String
    let image: String
}
