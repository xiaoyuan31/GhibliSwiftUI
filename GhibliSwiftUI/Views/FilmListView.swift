//
//  FilmListView.swift
//  GhibliSwiftUI
//
//  Created by Xiao Yuan Lv on 3/20/26.
//

import SwiftUI

struct FilmListView: View {
    
    @StateObject private var viewModel = FilmViewModel()
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    VStack(spacing: 12) {
                        Spacer()
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Loading Ghibli magic... 🍃")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Spacer()
                        Text(error)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchFilms()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                } else {
                    if viewModel.filteredFilms.isEmpty {
                        VStack {
                            Spacer()
                            Text("No results found 🍃")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 8) {
                                ForEach(viewModel.filteredFilms) { film in
                                    NavigationLink(
                                        destination: FilmDetailView(film: film)
                                            .environmentObject(viewModel)
                                    ) {
                                        FilmRow(film: film, viewModel: viewModel)
                                            .padding(.horizontal)
                                            .padding(.vertical, 4)
                                            .transition(.move(edge: .bottom).combined(with: .opacity))
                                    }
                                }
                            }
                            .padding(.top, 8)
                        }
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                        .padding()
                    }
                }
            }
            .navigationTitle("Ghibli Movies 🍃")
            .searchable(text: $viewModel.searchText, prompt: "Search Movies ...")
           
        }
        .task {
            await viewModel.fetchFilms()
        }
    }
}

// MARK: - FilmRow View
struct FilmRow: View {
    let film: Film
    @ObservedObject var viewModel: FilmViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: film.image)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .transition(.opacity.animation(.easeIn(duration: 0.3)))
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView()
                }
            }
            .frame(width: 80, height: 100)
            .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(film.title)
                    .font(.headline)
                Text(film.director)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0)) {
                    viewModel.toggleFav(film: film)
                }
            } label: {
                Image(systemName: viewModel.isFavorite(film: film) ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                    .scaleEffect(viewModel.isFavorite(film: film) ? 1.3 : 1.0)
                    .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: viewModel.isFavorite(film: film))
            }
        }
    }
}

// MARK: - Preview
struct FilmListView_Previews: PreviewProvider {
    static var previews: some View {
        FilmListView()
    }
}
