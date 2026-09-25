//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Анастасия on 10.09.2026.
//

import Foundation

struct MostPopularMovies: Codable {
    let errorMessage: String?
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: Double
    let imageURL: URL
    
    var resizedImageURL: URL {
            return imageURL
    
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}

