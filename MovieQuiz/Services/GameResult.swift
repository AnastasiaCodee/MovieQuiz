//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Анастасия on 03.04.2026.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ another: GameResult) -> Bool {
        correct > another.correct
    }
}

