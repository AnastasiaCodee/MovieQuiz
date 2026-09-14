//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Анастасия on 27.03.2026.
//

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}



