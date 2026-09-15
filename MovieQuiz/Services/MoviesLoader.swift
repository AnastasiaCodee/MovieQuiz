//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Анастасия on 10.09.2026.
//

import Foundation

protocol MoviesLoading {
    func loadMovies(handler: @escaping (Result<[Movie], Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    
    private let apiKey = "260b510f"
    private let baseURL = "https://www.omdbapi.com/"
    
    private let movieIDs = [
        "tt0111161", // The Shawshank Redemption
        "tt0068646", // The Godfather
        "tt0468569", // The Dark Knight
        "tt0071562", // The Godfather Part II
        "tt0050083", // 12 Angry Men
        "tt0108052", // Schindler's List
        "tt0167260", // The Lord of the Rings: Return of the King
        "tt0110912", // Pulp Fiction
        "tt0120737", // The Lord of the Rings: Fellowship
        "tt0060196", // The Good, the Bad and the Ugly
        "tt0109830", // Forrest Gump
        "tt0137523", // Fight Club
        "tt1375666", // Inception
        "tt0167261", // The Lord of the Rings: Two Towers
        "tt0080684", // Star Wars: Empire Strikes Back
        "tt0133093", // The Matrix
        "tt0099685", // Goodfellas
        "tt0073486", // One Flew Over the Cuckoo's Nest
        "tt0114369", // Se7en
        "tt0047478"  // Seven Samurai
    ]
    
    func loadMovies(handler: @escaping (Result<[Movie], Error>) -> Void) {
        var movies: [Movie] = []
        let group = DispatchGroup()
        var loadingError: Error?
        let lock = NSLock()
        
        for id in movieIDs {
            guard let url = URL(string: "\(baseURL)?apikey=\(apiKey)&i=\(id)") else { continue }
            
            group.enter()
            URLSession.shared.dataTask(with: url) { data, _, error in
                defer { group.leave() }
                
                if let error = error {
                    lock.lock(); loadingError = error; lock.unlock()
                    return
                }
                guard let data = data else { return }
                
                do {
                    let movie = try JSONDecoder().decode(Movie.self, from: data)
                    if movie.response == "True" {
                        lock.lock(); movies.append(movie); lock.unlock()
                    }
                } catch {
                    lock.lock(); loadingError = error; lock.unlock()
                }
            }.resume()
        }
        
        group.notify(queue: .main) {
            if movies.isEmpty, let error = loadingError {
                handler(.failure(error))
            } else {
                handler(.success(movies))
            }
        }
    }
}
