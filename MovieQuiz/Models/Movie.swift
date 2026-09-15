//
//  Movie.swift
//  MovieQuiz
//
//  Created by Анастасия on 15.09.2026.
//

import Foundation


import Foundation

struct Movie: Decodable {
    let title: String
    let year: String
    let poster: String
    let imdbRating: String
    let imdbID: String
    let response: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case poster = "Poster"
        case imdbRating
        case imdbID
        case response = "Response"
    }
}
