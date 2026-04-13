//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Анастасия on 17.03.2026.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
}

weak var delegate: QuestionFactoryDelegate?
