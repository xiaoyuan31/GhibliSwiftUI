//
//  FilmDetailView.swift
//  GhibliSwiftUI
//
//  Created by Xiao Yuan Lv on 3/20/26.
//

import SwiftUI

struct FilmDetailView: View {
    
    let film: Film
    @EnvironmentObject var viewModel: FilmViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                // MARK: Poster with parallax
                GeometryReader { geo in
                    AsyncImage(url: URL(string: film.image)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 440)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(height: 440)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .offset(y: -geo.frame(in: .global).minY)
                                .transition(.opacity.animation(.easeIn(duration: 0.3)))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 350)
                                .foregroundColor(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
                .frame(height: 300)
                
                // MARK: Film Info
                VStack(alignment: .leading, spacing: 12) {
                    Text(film.title)
                        .font(.largeTitle)
                        .bold()
                    
                    Text("🎬 Director: \(film.director)")
                        .font(.headline)
                    
                    Text("📅 Release: \(film.release_date)")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    // MARK: Favorite Button
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                            viewModel.toggleFav(film: film)
                        }
                    } label: {
                        Image(systemName: viewModel.isFavorite(film: film) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .font(.title)
                            .scaleEffect(viewModel.isFavorite(film: film) ? 1.5 : 1.0)
                            .rotationEffect(.degrees(viewModel.isFavorite(film: film) ? 360 : 0))
                    }
                    
                    Divider()
                    
                    Text(film.description)
                        .font(.body)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(12)
                .shadow(radius: 2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview

